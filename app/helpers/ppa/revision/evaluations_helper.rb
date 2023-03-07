module PPA
  module Revision
  	module EvaluationsHelper

  		def evaluation_options
				PPA::Revision::Evaluation.question1s
					.sort
					.map {|i| [t(".#{i[0]}"), i[0] ]}
			end

			def evaluation_short_options
				PPA::Revision::Evaluation.question10s
					.map {|i| [t(".#{i[0]}"), i[0] ]}
			end
		end
	end
end
