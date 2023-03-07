# Descrição:
#   Valida que um atributo aninhado deve ser único dentro de uma lista.
# Utilização:
#   validates :atributo_aninhado, uniq_nested_attributes: { attribute: :chave_unica_do_atributo_aninhado, message: "elemento de despesa deve ser único dentro da subação."}

class UniqNestedAttributesValidator < ActiveModel::EachValidator
	def validate_each record, attribute, collection
		repeated_objects = collection.to_a.reject(&:marked_for_destruction?).select do |object|
			if object.send(options[:attribute]).present?
				collection.to_a.reject(&:marked_for_destruction?).count { |obj| obj.send(options[:attribute]) == object.send(options[:attribute]) } > 1
			end
		end

    if options[:message].present?
      repeated_objects.drop(1).each{ |object| object.errors[options[:attribute]] << options[:message] }
      record.errors[attribute] << options[:message] if repeated_objects.any?
    else
      repeated_objects.drop(1).each { |object| object.errors[options[:attribute]] << I18n.t('activerecord.errors.messages.repeated') }
      record.errors[attribute] << I18n.t('activerecord.errors.messages.repeated') if repeated_objects.any?
    end
	end
end