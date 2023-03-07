class Reports::Tickets::Evaluations::SummaryService < Reports::Tickets::Evaluations::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::Evaluations::SummaryPresenter.new(default_scope)
  end

  def build_sheet(sheet)
    add_header(sheet)
    xls_add_row(sheet, [])

    add_satisfaction_index(sheet)
    xls_add_row(sheet, [])
    
    add_expectation(sheet)
    xls_add_row(sheet, [])
    
    add_question05_average(sheet) if sou?

    xls_add_row(sheet, [ total_str, presenter.scope_count ], style_1)
  end

  def sheet_type
    :summary
  end

  def header_title
    type = ticket_type.upcase.to_s
    date_ini = beginning_date.to_s
    date_fin = end_date.to_s
    I18n.t("#{t_base}.title", type: type, begin: date_ini, end: date_fin)
  end

  def total_str
    I18n.t("#{t_base}.total.#{ticket_type.to_s}")
  end

  def add_header(sheet)
    xls_add_header(sheet, [ header_title, " " ])
  end

  def add_satisfaction_index(sheet)
    questions = [
      :question_01_a,
      :question_01_b,
      :question_01_c,
      :question_01_d
    ]

    xls_add_header(sheet, [ I18n.t("#{t_base}.satisfaction"), result ])
    
    average = []
    questions.each do |question|
      question_name = presenter.question_name(question,ticket_type)
      question_average = presenter.question_average(question)
      
      average.push(question_average)
      xls_add_row(sheet, [ question_name, question_average ])
    end

    avg = average_arr(average)
    xls_add_row(sheet, [ I18n.t("#{t_base}.notes_avg"), avg ], style_1, widths)
    xls_add_row(sheet, [ I18n.t("#{t_base}.satisfaction_avg"), "=B10*20" ], style_1, widths)

  end

  def add_expectation(sheet)
    questions = [
      :question_02,
      :question_03
    ]
    
    xls_add_header(sheet, [ I18n.t("#{t_base}.expectation"), result ])

    average = []
    questions.each do |question|
      question_name = presenter.question_name(question,ticket_type)
      question_average = presenter.question_average(question)

      xls_add_row(sheet, [ question_name, question_average ])
      average.push(question_average)
    end

    avg = citizen_expectation(average)
    xls_add_row(sheet, [ I18n.t("#{t_base}.expectation_index"), avg ], style_2, widths)
  end

  def add_question05_average(sheet)
    title  = I18n.t("#{t_base}.resolvability.title")
    xls_add_header(sheet, [ title, result, index ])

    xls_add_row(sheet, [ 
      I18n.t("#{t_base}.resolvability.positive"), 
      presenter.question05_sum('yes'), 
      presenter.question05_average('yes') 
    ], style_3, widths)

    xls_add_row(sheet, [ 
      I18n.t("#{t_base}.resolvability.negative"), 
      presenter.question05_sum('no'), 
      presenter.question05_average('no') 
    ], style_3, widths)

    xls_add_row(sheet, [ 
      I18n.t("#{t_base}.resolvability.partially"), 
      presenter.question05_sum('partially'), 
      presenter.question05_average('partially') 
    ], style_3, widths)

    xls_add_row(sheet, [])
  end

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

  def result
    I18n.t("#{t_base}.result")
  end

  def index 
    I18n.t("#{t_base}.index")
  end
end

