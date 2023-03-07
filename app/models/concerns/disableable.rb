##
# Módulo incluído por models que possuem escopagem genérica
##
module Disableable
  extend ActiveSupport::Concern

  # Attrbutes

  attr_accessor :_disable

  def set_disabled_at
    return unless _disable.present?
    self.disabled_at = ActiveModel::Type::Boolean.new.cast(_disable) ? DateTime.now : nil
  end

  class_methods do
    def disabled
      where.not(disabled_at: nil)
    end

    def enabled
      where(disabled_at: nil)
    end
  end

  def enable!
    self.disabled_at = nil
    self.save
  end

  def disable!
    self.disabled_at = DateTime.now
    self.save
  end

  def disabled?
    self.disabled_at.present?
  end

  def enabled?
    !disabled?
  end
end
