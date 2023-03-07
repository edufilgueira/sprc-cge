class Operator::Export::UserPresenter < Operator::Export::BasePresenter

  COLUMNS = [
    :name,
    :email,
    :operator_type_str,
    :organ_acronym,
    :department_name
  ].freeze


  private

  def self.spreadsheet_header_title(column)
    I18n.t("activerecord.attributes.user.#{column}")
  end

  def self.columns
    self::COLUMNS
  end

  def columns
    self.class.columns
  end
end
