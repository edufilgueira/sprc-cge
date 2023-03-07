module PPA
  module RegionWithBiennium
    extend ActiveSupport::Concern

    included do
      helper_method :current_plan, :current_region, :current_biennium
    end

    def current_biennium
      @current_biennium ||= PPA::Biennium.new(params[:biennium])
    end

    def current_plan
      @current_plan ||= current_biennium.plan
    end

    def current_region
      @current_region ||= PPA::Region.find_by(code: params[:region_code])
    end

  end
end
