require 'rails_helper'

describe Transparency::SurveyAnswersController do

  let(:permitted_params) do
    [
      :transparency_page,
      :answer,
      :email,
      :message,
      :controller,
      :action,
      :url
    ]
  end

  let(:valid_params) do
    {
      transparency_survey_answer: attributes_for(:transparency_survey_answer).merge(answer: :very_satisfied)
    }
  end

  describe '#create' do
    render_views

    it 'permitted_params' do
      is_expected.to permit(*permitted_params).
        for(:create, params: { params: valid_params }).on(:transparency_survey_answer)
    end

    it 'invalid' do
      allow_any_instance_of(Transparency::SurveyAnswer).to receive(:save).and_return(false)

      post(:create, params: valid_params, xhr: true)

      expect(response).to render_template(partial: 'shared/transparency/survey_answers/_form')
    end

    it 'saves' do
      Timecop.freeze(DateTime.now) do
        expect do
          post(:create, params: valid_params, xhr: true)

          created = Transparency::SurveyAnswer.last

          expect(created.date).to eq(Date.today)

          expect(response).to render_template(partial: 'shared/transparency/survey_answers/_create')

        end.to change(Transparency::SurveyAnswer, :count).by(1)
      end
    end
  end
end
