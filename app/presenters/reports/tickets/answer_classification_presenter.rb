class Reports::Tickets::AnswerClassificationPresenter < Reports::Tickets::BasePresenter
  include ActionView::Helpers::NumberHelper

  INTERNAL_STATUSES = [:department, :subnet_department]

  attr_reader :scope, :total, :hash_count, :classification_keys

  def initialize(scope, ticket_report)
    @ticket_report = ticket_report
    @scope = scope
    @hash_scope = scope.group('tickets.answer_classification')

    @total = within_confirmed_at(scope).count + reopened_count(scope)
  end

  def answer_classification_count(answer_classification)
    classifications_hash[answer_classification] || 0
  end

  def answer_classification_str(answer_classification)
    Ticket.human_attribute_name("answer_classification.#{answer_classification}")
  end

  def answer_classification_value(answer_classification)
    Answer.classifications[answer_classification]
  end

  def answer_percentage(count)
    number_to_percentage(count.to_f * 100 / total, precision: 2) if total > 0
  end

  def without_classification_count
    within_confirmed_at(reopened_in_range(scope)).where.not(internal_status: [:final_answer, :partial_answer]).count
  end

  def with_classification_count
    within_confirmed_at(reopened_in_range(hash_scope)).where(internal_status: [:final_answer, :partial_answer]).count
  end

  def classification_keys
    @classification_keys ||= classifications_hash.keys
  end

  private

  def classifications_hash
    return @classifications_hash if @classifications_hash.present?

    @classifications_hash = merge_hashs(reopened_count(hash_scope), within_confirmed_at(reopened_out_range(hash_scope)).count)
    @classifications_hash = merge_hashs(@classifications_hash, with_classification_count)
    @classifications_hash = merge_hashs(@classifications_hash, {nil => without_classification_count})

    @classifications_hash
  end

  def merge_hashs(h_1, h_2)
    h_1.merge(h_2) { |_, a, b| a + b }
  end

  def answer_types_hash
    @answer_types_hash ||= answer_scope.group(:'answers.answer_type').count
  end
end
