FactoryBot.define do
  factory :integration_eparcerias_work_plan_attachment, class: 'Integration::Eparcerias::WorkPlanAttachment' do
    isn_sic { convenant.isn_sic }
    association :convenant, factory: :integration_contracts_convenant

    file_name 'Plano de Trabalho - SOBEF.PDF'
    file_size 790183
    file_type 'application/x-download'
    description 'Descrição'

    trait :invalid do
      file_name nil
    end
  end
end
