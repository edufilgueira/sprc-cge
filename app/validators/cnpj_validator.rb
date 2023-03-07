class CnpjValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless CNPJ.valid? value
      record.errors[attribute] << invalid_message(record)
    end
  end

  private

  def invalid_message(record)
    I18n.t 'cnpj.invalid',
      scope: "activerecord.errors.models.#{record.class.name.downcase}.attributes"
  end
end
