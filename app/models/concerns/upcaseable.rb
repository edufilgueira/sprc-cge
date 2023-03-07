##
# Módulo incluído por models tem attributos que devem ser upcase
##
module Upcaseable
  extend ActiveSupport::Concern

  #
  # Define os atributos que devem ser upcase
  #
  # Ex:
  # [
  #   :name
  # ]
  UPCASE_ATTRIBUTES = []

  included do
    before_save :set_upcase_attributes
  end

  def set_upcase_attributes
    self.class::UPCASE_ATTRIBUTES.each do |attr|
      attr_value = self.send(attr)
      upcase_attr = attr_value.upcase
      self.send("#{attr}=", upcase_attr)
    end
  end
end
