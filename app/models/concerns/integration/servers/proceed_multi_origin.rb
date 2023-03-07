module Integration
  module Servers
		module ProceedMultiOrigin
		  extend ActiveSupport::Concern

		  def proceed_type_origin
		    if cod_orgao == '010'
		      1
		    else
		      0
		    end
		  end

		end
	end
end