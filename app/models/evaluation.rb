class Evaluation < ApplicationRecord

  # Callbacks

  after_validation :calculate_average

  # Associations

  belongs_to :answer

  has_one :ticket, through: :answer

  # Enuns

  enum evaluation_type: [
    :sou,
    :sic,
    :call_center
  ]

  QUESTION_05_OPTIONS = [:yes, :no, :partially]

  # Validations

  validates :question_01_a,
    :question_01_b,
    :question_01_c,
    :question_01_d,
    :question_02,
    :question_03,
    presence: true

  validates_presence_of :question_05, if: -> { evaluation_type == 'sou' }

  validates :answer_id,
    uniqueness: true

  # privates

  private

  def calculate_average
    #
    # A pedido da CGE a média aritmética deve considerar apenas todos os itens da questão 1
    #
    summable_attributes = [question_01_a, question_01_b, question_01_c, question_01_d]

    return if summable_attributes.any?(&:blank?)

    questions_sum = summable_attributes.sum

    self.average = questions_sum / 4.0
  end
end
