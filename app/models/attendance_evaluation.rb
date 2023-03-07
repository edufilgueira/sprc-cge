class AttendanceEvaluation < ApplicationRecord

  # Setup

  acts_as_paranoid
  
  # Constants

  # pesos avaliação interna SIC
  EVALUATION_WEIGHTS = {
    clarity: 2,
    content: 5,
    wording: 2,
    kindness: 1
  }

  # pesos avaliação interna SOU
  EVALUATION_WEIGHTS_SOU = {
    textual_structure: 1,
    treatment: 2,
    quality: 5,
    classification: 2
  }


  # Associations

  belongs_to :ticket
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'


  # Validations

  validates :clarity,
    :content,
    :wording,
    :kindness,
    presence: true,
    inclusion: { in: 0..10 }, if: -> { ticket_type == 'sic' }

  validates :textual_structure,
    :treatment,
    :quality,
    :classification,
    presence: true,
    inclusion: { in: 0..10 }, if: -> { ticket_type == 'sou' }


  # Callbacks

  before_save :calculate_average

  after_create :update_protocol_evaluated, :update_sou_evaluation_sample, if: -> { ticket_type == 'sou' }

  private

  def clarity_weighted
    clarity * EVALUATION_WEIGHTS[:clarity]
  end

  def content_weighted
    content * EVALUATION_WEIGHTS[:content]
  end

  def wording_weighted
    wording * EVALUATION_WEIGHTS[:wording]
  end

  def kindness_weighted
    kindness * EVALUATION_WEIGHTS[:kindness]
  end

  def textual_structure_weighted
    textual_structure * EVALUATION_WEIGHTS_SOU[:textual_structure]
  end

  def treatment_weighted
    treatment * EVALUATION_WEIGHTS_SOU[:treatment]
  end

  def quality_weighted
    quality * EVALUATION_WEIGHTS_SOU[:quality]
  end

  def classification_weighted
    classification * EVALUATION_WEIGHTS_SOU[:classification]
  end

  # somatório dos pesos das catagorias de avaliação SIC
  def evaluations_weighted_sum
    clarity_weighted + content_weighted + wording_weighted + kindness_weighted
  end

  # somatório dos pesos das catagorias de avaliação SOU
  def evaluations_weighted_sum_sou
    textual_structure_weighted + treatment_weighted + quality_weighted + classification_weighted
  end

  def calculate_average
    self.average = ticket_type == 'sic' ? (evaluations_weighted_sum / 10.0) : (evaluations_weighted_sum_sou / 10.0)
  end

  def ticket_type
    Ticket.find(self.ticket_id).ticket_type
  end

  # atualiza as informações do ticket Filho (do órgão) e do ticket Pai.
  def update_protocol_evaluated
    # ticket é o filho
    ticket = self.ticket

    ticket_parent = ticket.parent

    ticket.internal_evaluation = true

    # atualizando o ticket filho
    ticket.save

    # Obs. no sou_evaluation_sample_details só possui tickets Filhos (dos órgãos)
    details_ticket = last_sou_evaluation_sample_details(ticket)

    details_ticket.rated = true

    details_ticket.save

    # o ticket pai é sempre atualizado, considerando que nenhum outro filho desse Pai
    # será separado nas amostras futuras, visto que o ticket pai já foi separado e não
    # será mais exibido para ser selecionado nas próximas amostras.

    # atualizando o ticket pai
    ticket_parent.internal_evaluation = true

    ticket_parent.save
  end

  # ticket é o filho
  def last_sou_evaluation_sample_details(ticket)
    ticket.sou_evaluation_sample_details.where(rated: false).last
  end

  def update_sou_evaluation_sample
    # temos um problema aqui, quando o ultimo detalhe é avaliado o rated: false nao existe,
    # por isso utilizo o . last
    sou_evaluation_sample_details = ticket.sou_evaluation_sample_details.last

    if sou_evaluation_sample_details
      sou_evaluation_sample = sou_evaluation_sample_details.sou_evaluation_sample

      if all_sample_details_evaluated?(sou_evaluation_sample)
        sou_evaluation_sample.status = :completed

        sou_evaluation_sample.save
      end
    end
  end

  def all_sample_details_evaluated?(sou_evaluation_sample)
    sou_evaluation_sample.sou_evaluation_sample_details.pluck(:rated).uniq.exclude? false
  end

  def find_sou_evaluation_samples_details_by_ticket(ticket_parent)
    # quando implementar o ticket_id do filho no details não sera necessario o .last
    ticket_parent.sou_evaluation_sample_details.last
  end

end
