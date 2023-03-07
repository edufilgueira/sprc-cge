require 'rails_helper'

describe BudgetProgram::Search do

  let!(:budget_program) { create(:budget_program) }

  it 'by name' do
    budget_program = create(:budget_program, name: 'Construção de escola')
    budget_programs = BudgetProgram.search(budget_program.name)

    expect(budget_programs).to eq([budget_program])
  end

  it 'by code' do
    budget_program = create(:budget_program, code: '16.10')
    budget_programs = BudgetProgram.search(budget_program.code)

    expect(budget_programs).to eq([budget_program])
  end

  it 'by theme' do
    theme = create(:theme, name: 'FORTALECIMENTO DO SISTEMA ESTADUAL DE PLANEJAMENTO')
    budget_program = create(:budget_program, theme: theme)

    budget_programs = BudgetProgram.search(budget_program.theme_name)

    expect(budget_programs).to eq([budget_program])
  end

  it 'by organ' do
    organ = create(:executive_organ, acronym: 'GSN')
    budget_program = create(:budget_program, organ: organ)

    budget_programs = BudgetProgram.search(budget_program.organ_acronym)

    expect(budget_programs).to eq([budget_program])
  end

  it 'by subnet' do
    subnet = create(:subnet, acronym: 'GSN')
    budget_program = create(:budget_program, subnet: subnet)

    budget_programs = BudgetProgram.search(budget_program.subnet_acronym)

    expect(budget_programs).to eq([budget_program])
  end
end
