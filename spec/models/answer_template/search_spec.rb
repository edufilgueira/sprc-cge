require 'rails_helper'

describe AnswerTemplate::Search do
  subject(:answer_template) { create(:answer_template, name: 'abcdef') }
  subject(:another) { create(:answer_template, name: 'ghij') }

  before do
    answer_template
    another
  end

  describe 'name' do
    it { expect(AnswerTemplate.search('a d f')).to eq([answer_template]) }
  end
end
