class GasVoucher < ApplicationDataRecord
	include GasVoucher::Search

	def self.default_sort_direction
   :asc
  end

  def self.sorted(*)
    order(:cpf)
  end

  def lot
  	lot_1 || lot_2 || lot_3
  end
end
