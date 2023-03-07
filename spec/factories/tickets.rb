FactoryBot.define do

  factory :ticket do

    description 'Descrição da manifestação com mais de 20 caracteres'
    answer_type :default
    answer_phone '(85) 4332-1356'
    ticket_type :sou
    sou_type :complaint
    unknown_organ true
    parent_unknown_organ true
    unknown_classification true
    deadline_ends_at { Date.today + Holiday.next_weekday(Ticket.response_deadline(:sou)) }
    deadline { Holiday.next_weekday(Ticket.response_deadline(:sou)) }
    anonymous false
    appeals 0
    sequence(:email) { |n| "email_#{n}@example.com" }
    name 'Fulano de Tal'
    social_name 'Social user name'
    gender :not_informed_gender
    document { CNPJ.generate(true) }
    created_by nil
    updated_by nil
    internal_evaluation false

    city

    trait :invalid do
      description nil
    end

    trait :in_progress do
      internal_status :in_filling
      status :in_progress
      deadline_ends_at nil
      deadline nil
    end

    trait :confirmed do
      status :confirmed
      internal_status :waiting_referral
      confirmed_at Date.today
    end

    trait :replied do
      confirmed
      status            :replied
      internal_status   :final_answer
      responded_at      DateTime.now

      after(:create) do |ticket, evaluator|
        create(:answer, :final, ticket: ticket)
      end
    end

    trait :partial_answer do
      confirmed
      status            :replied
      internal_status   :partial_answer
      responded_at      DateTime.now

      after(:create) do |ticket, evaluator|
        create(:answer, :partial, ticket: ticket)
      end
    end

    trait :immediate_answer do
      with_organ
      with_classification

      immediate_answer true

      after(:build) do |ticket, evaluator|
        ticket.answers << build(:answer, :final)
      end
    end

    trait :with_organ do
      association :organ, factory: [:executive_organ]
      unknown_organ false
      parent_unknown_organ false
      internal_status :waiting_referral
    end

    trait :with_rede_ouvir do
      association :organ, factory: [:rede_ouvir_organ]
      unknown_organ false
      confirmed
      rede_ouvir true
      association :parent, factory: [:ticket, :in_sectoral_attendance]
    end

    trait :with_classification do
      classified true
      classification
      unknown_classification false
    end

    trait :with_classification_other_organs do
      classified true
      unknown_classification false
      association :classification, factory: [:classification, :other_organs]
    end

    trait :with_classification_with_subtopic do
      classified true
      unknown_classification false
      association :classification, factory: [:classification, :with_subtopic]
    end

    trait :with_parent do
      confirmed
      with_organ

      association :parent, factory: [:ticket, :in_sectoral_attendance]
    end

    trait :with_parent_sic do
      confirmed
      with_organ
      ticket_type :sic

      association :parent, factory: [:ticket, :sic, :in_sectoral_attendance]
    end

    trait :in_sectoral_attendance do
      confirmed
      internal_status :sectoral_attendance
    end

    trait :in_internal_attendance do
      confirmed
      internal_status :internal_attendance
    end

    trait :invalidated do
      confirmed
      internal_status :invalidated
    end

    trait :denunciation do
      sou_type :denunciation
      denunciation_type :against_the_state
      description nil
      unknown_organ false
      confirmed

      denunciation_against_operator true

      association :denunciation_organ, factory: 'organ'
      denunciation_description "description"
      denunciation_date "last week"
      denunciation_place "street 4"
      denunciation_witness "Joao"
      denunciation_evidence "yes"
      denunciation_assurance :rumor
    end

    trait :anonymous do
      created_by nil
      anonymous true
      name nil
      social_name nil
      email nil
      document nil
    end

    trait :unregistred_user do
      created_by nil
      anonymous false
      sequence(:name) { |n| "Fulano de Tal #{n}" }
      sequence(:social_name) { |n| "Social #{n}" }
      answer_by_phone
    end
    # aliasing trait
    trait :identified do
      unregistred_user
    end

    trait :from_registered_user do
      created_by { create :user, :user }
      anonymous false
      # XXX isso é necessário pelas validações atuais. Deveria ser recuperado automaticamente da associação!
      name { created_by.name }
      social_name { created_by.social_name }
      email nil
      document nil
    end

    trait :with_answer do
    end

    trait :attendance_evaluation do
      association             :attendance_evaluation, factory: :attendance_evaluation
    end

    trait :gross_export do
      ticket_type             :sou
      sou_type                :complaint
      with_organ
      status                  :confirmed
      internal_status         :cge_validation
      used_input              :system
      confirmed_at            Date.yesterday
      deadline                15
      description             'Test ticket export'
      responded_at            DateTime.now
      association             :classification, factory: :classification
      unknown_classification false

      answer_classification   :sic_attended_personal_info

      with_city

      transient do
        extensions_count      2
        ticket_logs_count     1
      end

      after(:create) do |ticket, evaluator|
        if ticket.ticket_type == 'sou'
          create(:attendance_evaluation, :sou, ticket: ticket)
        else
          create(:attendance_evaluation, ticket: ticket)
        end

        create_list(:extension, evaluator.extensions_count, ticket: ticket, status: :approved)
        ticket.reload
      end
    end

    trait :with_extension do
      with_organ
      with_parent
      description             'Test ticket export'
      confirmed_at            Date.yesterday
      deadline                15
      responded_at            DateTime.now
      association             :classification, factory: :classification
      unknown_classification false
      status                  :confirmed
      transient do
        extensions_count      2
        ticket_logs_count     1
      end

      after(:create) do |ticket, evaluator|
        create_list(:extension, evaluator.extensions_count, ticket: ticket, status: :approved)
        ticket.reload
      end
    end

    trait :call_center do
      used_input :phone
      answer_type :phone
      call_center_status :waiting_allocation
    end

    trait :sic do
      ticket_type :sic
      sou_type nil
      answer_classification :sic_attended_personal_info
    end

    trait :with_call_center_responsible do
      call_center
      association :call_center_responsible, factory: [:user, :operator_call_center]
      call_center_status :waiting_feedback
    end

    trait :with_city do
      city
    end

    trait :answer_by_phone do
      answer_type                   :phone
      answer_phone                  "(11) 91111-1111"
    end

    trait :answer_by_letter do
      answer_type                   :letter

      city
      answer_address_street         "Avenida"
      answer_address_number         "1"
      answer_address_zipcode        "11111111"
      answer_address_neighborhood   "Vila"
    end

    trait :answer_by_facebook do
      answer_type       :facebook

      answer_facebook   "https://facebook.com/profile_user"
    end

    trait :expired do
      expired_can_extend

      after(:create) do |ticket, evaluator|
        create(:extension, ticket: ticket, status: :approved)
        ticket.reload
      end
    end

    trait :expired_can_extend do
      deadline -10
      deadline_ends_at { Date.today - 10 }
    end

    trait :with_reopen do
      replied
      with_parent

      transient do
        reopened_count nil
      end

      reopened          { reopened_count.present? ? reopened_count : 1 }
      reopened_at       DateTime.now

      deadline          5
      deadline_ends_at  5.days.since

      internal_status   :sectoral_attendance
      status            :confirmed
    end

    trait :reopened_without_organ do
      replied

      transient do
        reopened_count nil
      end

      reopened          { reopened_count.present? ? reopened_count : 1 }
      reopened_at       DateTime.now

      deadline          5
      deadline_ends_at  5.days.since

      internal_status   :sectoral_attendance
      status            :confirmed
    end

    trait :with_reopen_and_log do
      with_reopen

      after(:create) do |ticket, evaluator|
        ticket.reopened.times do |i|
          create(:ticket_log, :reopened, ticket: ticket, resource: ticket, data: { count: i+1 })
        end
      end
    end

    trait :with_appeal do
      replied
      with_parent
      sic
      internal_status   :appeal
      status            :confirmed

      transient do
        appeals_count nil
      end

      appeals          { appeals_count.present? ? appeals_count : 1 }
      appeals_at       DateTime.now

      deadline          5
      deadline_ends_at  5.days.since

    end

    trait :with_appeal_second_instance do
      with_appeal
      appeals 2
    end

    trait :public_ticket do
      confirmed
      sic
      with_classification
      public_ticket true
      published true
    end

    trait :with_subnet do
      confirmed
      with_organ
      unknown_subnet false
      subnet

      organ { subnet.organ }
    end

    trait :for_clone do
      sic
      published true
      public_ticket true
      extended true
      call_center_allocation_at DateTime.now
      reopened true
      reopened_at DateTime.now
      responded_at DateTime.now
      deadline -1
      deadline_ends_at -1.days.ago
      answer_classification :sou_demand_unfounded
    end

    trait :feedback do
      call_center_feedback_at DateTime.now
      call_center_status :with_feedback
    end

    trait :attendance do
      after(:create) do |ticket, evaluator|
        create(:attendance, ticket: ticket.parent || ticket)
      end
    end

    trait :marked_internal_evaluation do
      marked_internal_evaluation true
    end

    trait :internal_evaluation do
      internal_evaluation true
    end

    trait :with_security_organ do
      association :organ, factory: [:executive_organ]
      unknown_organ false
      parent_unknown_organ false
    end
  end
end
