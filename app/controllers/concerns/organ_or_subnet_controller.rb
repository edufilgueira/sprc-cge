##
# Módulo incluído por controllers que possuem organ ou subnet
##
module OrganOrSubnetController
  extend ActiveSupport::Concern

  included do
    before_action :update_organ_subnet, only: :update
  end

  private

  def update_organ_subnet
    if from_subnet?
      resource.organ = nil
    else
      resource.subnet = nil
    end
  end

  def from_subnet?
    params[:from_subnet].present? && ActiveModel::Type::Boolean.new.cast(params[:from_subnet])
  end
end
