require 'rails_helper'

describe User::Scopes do

  subject(:user) { build(:user) }

  describe 'scopes' do
    it 'sorted' do
      user = create(:user, name: 'XYZ')
      another_user = create(:user, name: 'ABC')

      expect(User.sorted).to eq([another_user, user])
    end

    it 'sorted_tickets' do
      expect(user.sorted_tickets).to eq(user.tickets.sorted)
    end

    describe 'operator_accessible_tickets' do
      let(:ticket_sou_parent) { create(:ticket) }
      let(:ticket_sic_parent) { create(:ticket, :sic) }
      let(:ticket_sou_child) { create(:ticket, :with_parent, parent: ticket_sou_parent) }
      let(:ticket_sic_child) { create(:ticket, :sic, :with_parent, parent: ticket_sic_parent) }

      it 'when cge' do
        ticket_sou_child
        ticket_sic_child
        user = build(:user, :operator_cge)

        expect(user.operator_accessible_tickets).to match_array(Ticket.where(parent_id: nil))
      end

      it 'when chief' do
        ticket_sou_child
        ticket_sic_child
        user = build(:user, :operator_chief)

        expect(user.operator_accessible_tickets).to match_array(Ticket.where(organ: user.organ))
      end

      it 'when call_center_supervisor' do
        ticket_sou_child
        create(:ticket, :with_parent, :with_organ)
        ticket_sic_child

        user = build(:user, operator_type: :call_center_supervisor)
        expect(user.operator_accessible_tickets).to match_array(Ticket.where(parent_id: nil))
      end

      it 'when coordination' do
        ticket_sou_child
        create(:ticket, :with_parent, :with_organ)
        ticket_sic_child

        user = build(:user, operator_type: :coordination)
        expect(user.operator_accessible_tickets).to match_array(Ticket.all)
      end

      it 'sou_sectoral' do
        user = create(:user, :operator_sou_sectoral, sectoral_denunciation: false)
        children_ticket = create(:ticket, :with_parent, organ: user.organ)
        denunciation_ticket = create(:ticket, :with_parent, :denunciation, organ: user.organ)

        expect(user.operator_accessible_tickets).to eq([children_ticket])
      end

      it 'sou_sectoral sectoral_denunciation' do
        user = create(:user, :operator_sou_sectoral, sectoral_denunciation: true)
        children_ticket = create(:ticket, :with_parent, organ: user.organ)
        denunciation_ticket = create(:ticket, :with_parent, :denunciation, organ: user.organ)

        expect(user.operator_accessible_tickets).to match_array([children_ticket, denunciation_ticket])
      end
    end

    context 'operator_accessible_tickets_for_report' do
      it 'sou_sectoral' do
        user = create(:user, :operator_sou_sectoral, sectoral_denunciation: false)

        silgular_ticket = create(:ticket, :confirmed, parent_id: nil)
        children_ticket = create(:ticket, :with_parent, organ: user.organ)
        denunciation_ticket = create(:ticket, :with_parent, :denunciation, organ: user.organ)
        parent_ticket = children_ticket.parent

        expect(user.operator_accessible_tickets_for_report).to eq([children_ticket])
      end

      it 'sou_sectoral sectoral_denunciation' do
        user = create(:user, :operator_sou_sectoral, sectoral_denunciation: true)
        children_ticket = create(:ticket, :with_parent, organ: user.organ)
        denunciation_ticket = create(:ticket, :with_parent, :denunciation, organ: user.organ)

        expect(user.operator_accessible_tickets_for_report).to match_array([children_ticket, denunciation_ticket])
      end

      it 'sic_sectoral' do
        user = create(:user, :operator_sic_sectoral)

        silgular_ticket = create(:ticket, :confirmed, :sic, parent_id: nil)
        children_ticket = create(:ticket, :sic, :with_parent_sic, organ: user.organ)
        parent_ticket = children_ticket.parent

        expect(user.operator_accessible_tickets_for_report).to match_array([children_ticket])
      end

      it 'chief' do
        user = create(:user, :operator_chief)

        silgular_ticket = create(:ticket, :confirmed, parent_id: nil)
        children_ticket = create(:ticket, :with_parent, organ: user.organ)
        parent_ticket = children_ticket.parent

        expect(user.operator_accessible_tickets_for_report).to match_array([children_ticket])
      end

      it 'cge' do
        user = create(:user, :operator_cge)

        silgular_ticket = create(:ticket, :confirmed, parent_id: nil)
        children_ticket = create(:ticket, :with_parent)
        parent_ticket = children_ticket.parent

        expect(user.operator_accessible_tickets_for_report.map{|t| t.id}).to match_array([silgular_ticket, children_ticket].map{|t| t.id})
      end

      it 'coordination' do
        user = build(:user, operator_type: :coordination)

        silgular_ticket = create(:ticket, :confirmed, parent_id: nil)
        children_ticket = create(:ticket, :with_parent)
        parent_ticket = children_ticket.parent

        expect(user.operator_accessible_tickets_for_report.map{|t| t.id}).to match_array([silgular_ticket, children_ticket].map{|t| t.id})
      end

      it 'call_center_supervisor' do
        user = build(:user, operator_type: :coordination)

        silgular_ticket = create(:ticket, :confirmed, parent_id: nil)
        children_ticket = create(:ticket, :with_parent)
        parent_ticket = children_ticket.parent

        expect(user.operator_accessible_tickets_for_report.map{|t| t.id}).to match_array([silgular_ticket, children_ticket].map{|t| t.id})
      end

      it 'subnet_sectoral' do
        user = create(:user, :operator_subnet_sectoral)

        silgular_ticket = create(:ticket, :confirmed, parent_id: nil)
        children_ticket = create(:ticket, :with_parent, organ: user.subnet.organ, subnet: user.subnet)

        parent_ticket = children_ticket.parent

        expect(user.operator_accessible_tickets_for_report).to match_array([children_ticket])
      end

      it 'subnet_chief' do
        user = create(:user, :operator_subnet_chief)

        silgular_ticket = create(:ticket, :confirmed, parent_id: nil)
        children_ticket = create(:ticket, :with_parent, organ: user.subnet.organ, subnet: user.subnet)
        parent_ticket = children_ticket.parent

        expect(user.operator_accessible_tickets_for_report).to match_array([children_ticket])
      end

      it 'sou_sectoral rede_ouvir' do
        user = create(:user, :operator_sou_sectoral, organ: create(:rede_ouvir_organ))

        silgular_ticket = create(:ticket, :confirmed, parent_id: nil)
        children_ticket = create(:ticket, :with_parent, :with_rede_ouvir, organ: user.organ)
        parent_ticket = children_ticket.parent

        executive_organ_ticket = create(:ticket, :with_parent, :with_organ)

        expect(user.operator_accessible_tickets_for_report).to match_array([children_ticket])
      end

      it 'others' do
        user = create(:user, :operator_internal)

        expect(user.operator_accessible_tickets_for_report.to_sql).to eq("")
      end
    end

    describe 'self.from_omniauth' do
      let(:auth) do
        a = OmniAuth::AuthHash.new
        a.provider = 'Facebook'
        a.uid = '123456'
        a.info = OmniAuth::AuthHash.new
        a.info.name = 'Teste 123'
        a.info.email = 'example@example.com'
        a.info.urls = OmniAuth::AuthHash.new
        a.info.urls.Facebook = 'https://www.facebook.com/app_scoped_user_id/[uid]/'
        a
      end

      it { expect(User.from_omniauth(auth)).to be_persisted }

      it 'create correct params' do
        User.from_omniauth(auth)
        last_user = User.last

        expect(last_user.provider).to eq(auth.provider)
        expect(last_user.email).to eq(auth.info.email)
        expect(last_user.name).to eq(auth.info.name)
        expect(last_user.facebook_profile_link).to eq(auth.info.urls.Facebook)
        expect(last_user.user?).to be_truthy
      end

      it 'create correct params and not duplicate email' do
        user = create(:user, email: 'example@example.com')
        last_user = User.from_omniauth(auth)

        expect(user).to eq(last_user)
        expect(last_user.provider).to eq(auth.provider)
        expect(last_user.email).to eq(auth.info.email)
        expect(last_user.facebook_profile_link).to eq(auth.info.urls.Facebook)
        expect(last_user.user?).to be_truthy
      end
    end

    describe 'self.sectorals' do
      it 'all' do
        sou_sectoral = create(:user, :operator_sectoral, operator_type: :sou_sectoral)
        sic_sectoral = create(:user, :operator_sectoral, operator_type: :sic_sectoral)
        expect(User.sectorals('sou')).to eq([sou_sectoral])
      end
    end

    it 'self.from_subnet' do
      user = create(:user, :operator_subnet)
      create(:user, :operator_subnet)

      expect(User.from_subnet(user.subnet)).to eq([user])
    end

    describe 'self.sectorals_from_organ' do
      it 'all' do
        organ = create(:executive_organ)
        sou_sectoral = create(:user, :operator_sectoral, operator_type: :sou_sectoral, organ: organ)
        sic_sectoral = create(:user, :operator_sectoral, operator_type: :sic_sectoral, organ: organ)
        expect(User.sectorals_from_organ_and_type(organ, 'sic')).to eq([sic_sectoral])
      end
    end

    describe 'scopeable' do
      it 'disabled' do
        user_enabled = create(:user)
        user_disabled = create(:user, disabled_at: DateTime.now)

        expect(User.disabled).to eq([user_disabled])
      end

      it 'enabled' do
        user_enabled = create(:user)
        user_disabled = create(:user, disabled_at: DateTime.now)

        expect(User.enabled).to eq([user_enabled])
      end
    end
  end

  describe 'instance scopes' do
    describe 'operator_accessible_tickets' do

      context 'parent_tickets' do
        context 'cge' do
          let(:expected) { Ticket.not_denunciation.parent_tickets.to_sql }

          before { user.operator_type = :cge }

          it { expect(user.operator_accessible_tickets.to_sql).to eq(expected) }
        end

        context 'call_center' do
          let(:expected) { Ticket.parent_tickets.to_sql }

          before { user.operator_type = :call_center }

          it { expect(user.operator_accessible_tickets.to_sql).to eq(expected) }
        end

        context 'call_center_supervisor' do
          let(:expected) { Ticket.parent_tickets.to_sql }

          before { user.operator_type = :call_center_supervisor }

          it { expect(user.operator_accessible_tickets.to_sql).to eq(expected) }
        end
      end

      context 'from_organ' do
        subject(:user) { build(:user, sectoral_denunciation: false, organ: create(:executive_organ)) }
        let(:expected) { Ticket.from_organ(user.organ).not_denunciation.to_sql }

        it 'sou_sectoral' do
          user.operator_type = :sou_sectoral

          expect(user.operator_accessible_tickets.to_sql).to eq(expected)
        end

        it 'sic_sectoral' do
          user.operator_type = :sic_sectoral

          expect(user.operator_accessible_tickets.to_sql).to eq(expected)
        end
      end

      context 'from_ticket_department' do
        subject(:user) { build(:user, department: create(:department)) }
        let(:expected) { Ticket.from_ticket_department(user.department)
          .where(internal_status: [:internal_attendance, :partial_answer, :final_answer, :sectoral_validation, :appeal]).to_sql }

        it 'internal' do
          user.operator_type = :internal

          expect(user.operator_accessible_tickets.to_sql).to eq(expected)
        end

        it 'internal with sub_department' do
          user.operator_type = :internal
          user.sub_department = create(:sub_department, department: user.department)

          expected = Ticket.joins(ticket_departments: :ticket_department_sub_departments).
            where(ticket_department_sub_departments: { sub_department_id: user.sub_department_id }).
            where(internal_status: [:internal_attendance, :partial_answer, :final_answer, :sectoral_validation, :appeal]).distinct.to_sql

          expect(user.operator_accessible_tickets.to_sql).to eq(expected)
        end
      end

      context 'from_subnet' do
        subject(:user) { build(:user, :operator_subnet) }
        let(:expected) { Ticket.from_subnet(user.subnet).to_sql }

        it 'operator_subnet' do
          expect(user.operator_accessible_tickets.to_sql).to eq(expected)
        end

        it 'operator_subnet' do
          user.operator_type = :subnet_chief
          expect(user.operator_accessible_tickets.to_sql).to eq(expected)
        end
      end
    end
  end

  context 'ticket with organ_association' do
    let(:organ_main) { create(:executive_organ, name: 'CGE') }
    let(:organ_associated) { create(:executive_organ, name: 'SESA') }
    let(:organ_not_associated) { create(:executive_organ, name: 'ETICE') }
    let(:organ_association) { create(:organ_association, organ: organ_main, organ_association: organ_associated) }
    
    let(:user) { create(:user, :operator_chief, organ: organ_main) }

    before { 
      organ_main
      organ_associated
      organ_not_associated
      organ_association
    }
    
    it 'value null return permission to organ_main' do
      expect(user.return_organ_or_organ_association_in_user).to eq(organ_main)
    end

    it 'organ_main is allowed access to itself' do
      expect(user.return_organ_or_organ_association_in_user(organ_main.id)).to eq(organ_main)
    end

    it 'organ_associated access permission' do
      organ_main.reload
      expect(user.return_organ_or_organ_association_in_user(organ_associated.id)).to eq(organ_associated)
    end

    it 'organ_not_associated return permission to organ_main' do
      organ_main.reload
      expect(user.return_organ_or_organ_association_in_user(organ_not_associated.id)).to eq(organ_main)
    end

    it 'organ_not_associated not have permission' do
      organ_main.reload
      expect(user.return_organ_or_organ_association_in_user(organ_not_associated.id)).not_to eq(organ_not_associated)
    end
  end
end
