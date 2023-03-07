require 'rails_helper'

describe Transparency::SurveyAnswerHelper do

  it 'survey options' do

    expected = [
      [I18n.t('transparency/survey_answer.answers.very_satisfied'), 'very_satisfied' ],
      [I18n.t('transparency/survey_answer.answers.somewhat_satisfied'), 'somewhat_satisfied' ],
      [I18n.t('transparency/survey_answer.answers.neutral'), 'neutral' ],
      [I18n.t('transparency/survey_answer.answers.somewhat_dissatisfied'), 'somewhat_dissatisfied' ],
      [I18n.t('transparency/survey_answer.answers.very_dissatisfied'), 'very_dissatisfied' ],
    ]

    expect(transparency_survey_answer_options).to eq(expected)
  end
end
