#
# Validador para CPF.
#
# usage:
# ````ruby
# validates :cpf, presence: true, cpf: true
# # é o mesmo que
# validates :cpf, presence: true, cpf: { mask: true }
# ```
#
# Caso queira exigir que os dados não possuam máscara, sendo apenas dígitos, use:
# ```ruby
# validates :cpf, presence: true, cpf: { mask: false }
# ```
#
# @author Joe Blog <Joe.Blog@nowhere.com>
#
class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, options[:message] || :invalid) unless valid_cpf?(value)
  end

  private

  def valid_cpf?(value)
    is_valid = CPF.valid?(value)

    is_valid = is_valid && value =~ CPF::REGEX if options.fetch(:mask, true)

    is_valid
  end
end
