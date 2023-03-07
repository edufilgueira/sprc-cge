#
# Métodos e constantes para os escopos de User
#

module User::Scopes
  extend ActiveSupport::Concern

  ## Class methods
  class_methods do

    # Public
    def from_omniauth(auth)
      user = where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
        build_facebook_user(user, auth)
      end

      return user if user.persisted? || auth.info.email.blank?

      create_or_update_facebook_user(user, auth)
    end

    def sectorals(ticket_type)
      type = ticket_type == 'sic' ? :sic_sectoral : :sou_sectoral
      where(operator_type: type)
    end

    def sectorals_from_organ_and_type(organ, ticket_type)
      sectorals(ticket_type).where(organ: organ)
    end

    def from_subnet(subnet)
      subnet_sectoral.where(subnet: subnet)
    end

    private

    def build_facebook_user(user, auth)
      user.email = auth.info.email
      user.email_confirmation = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.facebook_profile_link = auth.info.urls.Facebook if auth.info.urls.present?
      user.user_type = :user
      user
    end

    def update_facebook_user(user, auth)
      user.provider = auth.provider
      user.uid = auth.uid
      user.facebook_profile_link = auth.info.urls.Facebook if auth.info.urls.present?
      user.save
    end

    def create_or_update_facebook_user(user, auth)
      if exists?(email: auth.info.email)
        user = find_by_email(auth.info.email)
        update_facebook_user(user, auth)
      else
        user.save(validate: false)
      end

      user
    end
  end

  included do

    ## Instance methods
    def sorted_tickets
      tickets.sorted
    end

    def operator_accessible_tickets(organ_association=nil)
      case operator_type
      when 'cge'
        denunciation_tracking? ? Ticket.parent_tickets : Ticket.not_denunciation.parent_tickets
      when 'call_center', 'call_center_supervisor'
        Ticket.parent_tickets
      when 'coordination'
        Ticket.all
      when 'sou_sectoral', 'sic_sectoral', 'chief'
        scope_tickets_sou_sectoral(Ticket, organ_association)
      when 'subnet_sectoral', 'subnet_chief'
        Ticket.from_subnet(subnet)
      when 'security_organ'
        Ticket.from_security_organ
      when 'internal'
        scope =
          if sub_department.present?
            Ticket.from_ticket_sub_department(sub_department)
          else
            Ticket.from_ticket_department(department)
          end
          scope.where(internal_status: [:internal_attendance, :partial_answer, :final_answer, :sectoral_validation,:appeal])
      else
        Ticket.none
      end
    end

    def operator_accessible_tickets_for_report
      scope_tickets_by_operator_type(Ticket.leaf_tickets)
    end

    def scope_tickets_by_operator_type(scope)
      case operator_type
      when 'cge', 'coordination', 'call_center_supervisor'
        scope
      when 'sou_sectoral', 'sic_sectoral', 'chief'
        scope_tickets_sou_sectoral(scope)
      when 'subnet_sectoral', 'subnet_chief'
        scope.where(subnet: subnet)
      else
        scope.none
      end
    end

    def scope_tickets_sou_sectoral(scope, organ_association=nil)
      organ_selected = return_organ_or_organ_association_in_user(organ_association)
      
      tickets = scope.from_organ(organ_selected)
      
      sectoral_denunciation? ? tickets : tickets.not_denunciation
    end
    
    def return_organ_or_organ_association_in_user(organ_association=nil)

      organ_selected = organ
      
      organ_association = nil unless organ_association.present?

      return  organ_selected if organ_association.nil?
    
      organ_association = organ_association.to_i unless organ_association.nil?
      
      organ.organ_associations.each do | organ_ass |
        id = organ_ass.organ_association.id
        organ_selected = organ_ass.organ_association if organ_association == id
      end

      organ_selected
    end

  end
end