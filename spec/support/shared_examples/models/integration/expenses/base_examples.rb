# Shared example básico para models relacionados a Despesas

shared_examples_for 'models/integration/expenses/base' do

  describe 'callbacks' do
    it 'date_of_issue' do
      subject.data_emissao = Date.today.to_s
      subject.save
      expect(subject.date_of_issue).to eq(Date.today)
    end
  end
end
