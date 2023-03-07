module Reports::Tickets::Report::Evaluation::BaseService
  extend ActiveSupport::Concern
  
  included do

    private

    def presenter
      @presenter ||= Reports::Tickets::EvaluationPresenter.new(evaluation_scope)
    end

    def evaluation_scope
      @evaluation_scope ||= ::Evaluation.joins(answer: [:ticket]).where(tickets: { id: default_scope.ids })
    end

    def build_sheet(sheet)
      add_basic_questions(sheet)

      xls_add_row(sheet, [])
      add_total_of_resolubility(sheet)
    end

    def sheet_type
      :evaluation
    end

    def add_basic_questions(sheet)

      questions = [
        :question_01_a,
        :question_01_b,
        :question_01_c,
        :question_01_d
      ]

      xls_add_header(sheet, [ I18n.t("#{t_base}.satisfaction"), result ])

      average = []
      ticket_type = ticket_report.ticket_type_filter

      questions.each do |question|
        question_name = presenter.question_name(question,ticket_type)
        question_average = presenter.question_average(question) 
        xls_add_row(sheet, [ question_name, question_average ])
        average.push(question_average)
      end

      avg = presenter.average_arr(average)
      xls_add_row(sheet, [ I18n.t("#{t_base}.notes_avg"), avg ], style_1, widths)
      xls_add_row(sheet, [ I18n.t("#{t_base}.satisfaction_avg"), "=B8*20" ], style_1, widths)

    end

    def add_expectation(sheet)

      xls_add_header(sheet, [ I18n.t("#{t_base}.expectation"), result ])

      ticket_type = ticket_report.ticket_type_filter
      average = []

      questions = [ :question_02, :question_03 ]
      questions.each do |question|

        question_name = presenter.question_name(question,ticket_type)
        question_average = presenter.question_average(question)

        xls_add_row(sheet, [ question_name, question_average ])
        average.push(question_average)

      end
  
      avg = presenter.citizen_expectation(average)
      xls_add_row(sheet, [ I18n.t("#{t_base}.expectation_index"), avg ], style_2, widths)

    end

    def resolubility(sheet)

      title  = I18n.t("#{t_base}.resolvability.title")
      xls_add_header(sheet, [ title, result, index ])

      Evaluation::QUESTION_05_OPTIONS.each do |option|

        label = I18n.t("#{t_resolubility_title}.#{option}")
        total = presenter.question05_sum(evaluation_scope, option.to_s, ticket_report_type)
        indice = presenter.question05_average(evaluation_scope, option.to_s) 

        xls_add_row(sheet, [label, total, indice], style_3, widths)

      end

    end

    def add_total_of_resolubility(sheet)

      ticket_type = ticket_report.ticket_type_filter
      title = I18n.t("services.reports.tickets.#{ticket_type}.evaluation.total")
      value = evaluation_scope.send(ticket_report.ticket_type_filter).count

      xls_add_row(sheet, [ title, value ], style_1)

    end

    # Estilo das colinas
    def style_1
      ['bold', 'bold']
    end

    def style_2
      ['bold', 'bold_percent']
    end

    def style_3
      ['default', 'bold', 'bold_percent']
    end

    def widths
      [120, 10, 10]
    end

    def sic?
      ticket_type.to_s == 'sic'
    end

    def sou?
      ticket_type.to_s == 'sou'
    end

    def t_base
      'services.reports.tickets.evaluations.summary'
    end

    def t_resolubility_title 
      'shared.answers.evaluations.questions.sou.question_05'
    end

    def result
      I18n.t("#{t_base}.result")
    end

    def index
      I18n.t("#{t_base}.index")
    end

  end
end
