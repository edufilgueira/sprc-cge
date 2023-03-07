FactoryBot.define do
  factory :gas_voucher , class: 'GasVoucher'do
  	#34836365368;Cariri;ABAIARA;12345476054;MARIA APARECIDA SOBRINHO;;LOTE 02;
  	region "Cariri"
		city "ABAIARA"
		nis "12345476054"
		cpf "348.363.653-68"
		name "MARIA APARECIDA SOBRINHO"
		lot_1 nil
		lot_2 "LOTE 02"
		lot_3 nil

  end
end