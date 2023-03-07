module PPA
  module ScopedLinkHelper
    def ppa_scoped_path(path, *args)
      args.push(biennium: current_biennium.to_s, region_code: current_region.code)
      path = "ppa_scoped_#{path}_path"
      public_send path, *args
    end

    def ppa_plan_scoped_path(*args)
    	args.push(plan_id: plan.id, region_code: region.code)
    	path = "ppa_plan_themes_path"
    	public_send path, *args
    end
  end
end