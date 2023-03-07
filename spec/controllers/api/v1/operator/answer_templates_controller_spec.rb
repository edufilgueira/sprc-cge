require 'rails_helper'

describe Api::V1::Operator::AnswerTemplatesController do
  include ResponseSpecHelper

  let(:user) { create(:user, :operator) }
  let(:empty_option) { {"#{I18n.t('messages.form.select')}": '' } }

  before { sign_in(user) }

  describe 'search' do
    let(:answer_template) { create(:answer_template, user: user, name: 'abcde') }

    let(:permitted_params) do
      [
        :name,
        :content
      ]
    end

    let(:expected) do
      JSON.parse([answer_template].to_json(only: permitted_params))
    end

    before do
      answer_template
      get(:search, xhr: true, params: { name: 'abc' })
    end

    it { expect(json).to eq(expected) }
  end
end
