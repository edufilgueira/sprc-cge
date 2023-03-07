require 'rails_helper'

describe EvaluationExport::Search do

  describe 'title' do
    let(:evaluation_export) { create(:evaluation_export, title: 'abcdef') }
    let(:another) { create(:evaluation_export, title: 'ghij') }

    it do
      evaluation_export
      another

      expect(EvaluationExport.search('a d f')).to eq([evaluation_export])
    end
  end
end
