module Operator::AnswerTemplates::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      home_breadcrumb,
      [ t(".title"), "" ]
    ]
  end

  def new_create_breadcrumbs
    [
      home_breadcrumb,
      answer_templates_home_breadcrumb,
      [ t(".title"), "" ]
    ]
  end

  def show_edit_update_breadcrumbs
    [
      home_breadcrumb,
      answer_templates_home_breadcrumb,
      [ answer_template.title, "" ]
    ]
  end

  private

  def home_breadcrumb
    [ t("operator.home.index.title"), operator_root_path ]
  end

  def answer_templates_home_breadcrumb
    [ t("operator.answer_templates.index.title"), operator_answer_templates_path ]
  end
end
