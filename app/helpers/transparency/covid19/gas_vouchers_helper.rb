module Transparency::Covid19::GasVouchersHelper

	def gas_voucher_file_paths
		{ xlsx: xlsx_download_path, csv: csv_download_path } 
	end

	def gas_voucher_filter_path
		"#{controller_path}/#{action_name}/filters"
	end

	def gas_voucher_partial_index_path
		"#{controller_path}/index"
	end
end