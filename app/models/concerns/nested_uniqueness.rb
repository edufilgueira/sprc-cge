#
# @see https://medium.com/@viduranga/ruby-on-rails-uniqueness-scope-validation-breaks-when-saving-multiple-nested-records-has-many-d4119e34940e
# @see https://github.com/rails/rails/issues/20676
#
#
# Valida unicidade de objetos nested
#
# options:
# - attribute:        Nome do atributo a ser validado
# - case_sensitive:   (opcional) true ou false. default: false
# - message:          (opcional) Mensagem de erro. default: :taken
#
#
#
# Ex.:
#
# validates_uniqueness :ticket_department_sub_departments, { attribute: :sub_department_id, case_sensitive: false, message: :taken }
#

#
module NestedUniqueness
  extend ActiveSupport::Concern

  class_methods do

    def validates_uniqueness(*attribute_names)
      configuration = attribute_names.extract_options!

      validates_each(attribute_names) do |record, association_name, value|
        track_values = {}
        attribute_name = configuration[:attribute]

        value.map.with_index do |object, index|
          attribute_value = object.try(attribute_name)
          attribute_value = attribute_value.downcase if configuration[:case_sensitive] == false && attribute_value.respond_to?(:downcase)

          if track_values[attribute_value].present?
            track_values[attribute_value].push({index: index, record: record})
          else
            track_values[attribute_value] = [{index: index, record: record}]
          end

          track_values.each do |key, track_value|
            next unless track_value.count > 1

            track_value.each do |value|
              error_key = "#{association_name}[#{value[:index]}].#{attribute_name}"
              message = configuration[:message] || :taken
              value[:record].errors[error_key] << message
              value[:record].send(association_name)[value[:index]].errors.add(attribute_name, message)
            end
          end
        end
      end
    end

  end
end
