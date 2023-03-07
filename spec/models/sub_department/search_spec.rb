require 'rails_helper'

describe SubDepartment::Search do
  it 'name' do
    sub_department = create(:sub_department, name: 'HOSPITAL GERAL DA POLÍCIA MILITAR JOSÉ MARTINIANO DE ALENCAR')
    another_sub_department = create(:sub_department, name: 'SUPERINDENT DO DESENV URBANO DO ESTADO DO CEARA')
    another_sub_department
    sub_departments = SubDepartment.search('HOSP')
    expect(sub_departments).to eq([sub_department])
  end

  it 'acronym' do
    sub_department = create(:sub_department, acronym: 'PM')
    another_sub_department = create(:sub_department, acronym: 'ARCE')
    another_sub_department
    sub_departments = SubDepartment.search('PM')
    expect(sub_departments).to eq([sub_department])
  end
end
