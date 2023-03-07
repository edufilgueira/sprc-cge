##
# Módulo incluído por models que são usados para relatório
##
module Reportable
  extend ActiveSupport::Concern
  include FilteredController
  include Filterable

  included do
    # Associations

    belongs_to :user

    # Enums

    enum status: [:preparing, :generating, :error, :success]

    # Validations

    ## Presence

    validates :user,
      :title,
      :status,
      presence: true

    # Serializations

    serialize :filters, Hash

    # Callbacks

    before_destroy :remove_spreadsheet

    ## Scopes
    def self.sorted
      order(created_at: :desc)
    end
  end

  # Implementar

  def sorted_tickets
    # Deve ser implementado por quem inclue o módulo
  end


  ## Helpers

  def report_name
    self.class.name.underscore
  end

  def status_str
    I18n.t("#{report_name}.statuses.#{status}")
  end

  def progress
    return 0 if (total_to_process.to_i.zero?)
    ((processed / total_to_process.to_f) * 100).to_i
  end

  def processing?
    (preparing? || generating?)
  end

  def filtered_scope
    filtered_tickets
  end

  def ticket_type_filter
    self.filters.with_indifferent_access[:ticket_type].to_s
  end

  def dir_path
    Rails.root.join('public', 'files', 'downloads', report_name, id.to_s)
  end

  def file_path
    "#{dir_path}/#{file_name}"
  end

  def file_name
    "#{report_name}_#{id}.xlsx"
  end

  def file
    File.new(file_path) if File.exist?(file_path)
  end

  def params
    (filters && filters.with_indifferent_access) || {}
  end

  ## Callbacks

  def remove_spreadsheet
    RemoveReportableSpreadsheet.call(self)
  end
end
