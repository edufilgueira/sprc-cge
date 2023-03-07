class PPA::Admin::Revision::ExportsController < PPA::AdminController
	include PPA::Admin::Revision::ExportsHelper

	before_action :generate_file, only: [:show]

	def generate_file
		PPA::Admin::Revision::ExportWorker.new.perform(ppa_plan_revising.id)
	end
end