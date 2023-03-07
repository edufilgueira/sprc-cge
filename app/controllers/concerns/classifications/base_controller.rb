module Classifications::BaseController
  extend ActiveSupport::Concern

  included do
    helper_method [ :classification_other_organs ]
  end

  def classification_other_organs
    @classification_other_organs ||= build_classification_other_organs
  end

  private

  def build_classification_other_organs
    Classification.new(
      topic: Topic.other_organs,
      subtopic: Subtopic.other_organs,
      budget_program: BudgetProgram.other_organs,
      service_type: ServiceType.other_organs,
      other_organs: true
    )
  end
end
