require 'rails_helper'

describe StatsEvaluationsHelper do

  it 'stats_evaluations_sorted_organs_data' do
    organs_hash = {
      'PMCE'=> {
        'total_tickets'=> 1,
        'total_answered_tickets'=> 1,
        'total_user_evaluations'=> 1,
        'average_evaluations'=> 3.0
      },

      'DETRAN'=> {
        'total_tickets'=> 1,
        'total_answered_tickets'=> 1,
        'total_user_evaluations'=> 1,
        'average_evaluations'=> 5.0
      },

      'CAGECE'=> {
        'total_tickets'=> 1,
        'total_answered_tickets'=> 2,
        'total_user_evaluations'=> 1,
        'average_evaluations'=> 3.0
      },

      'ARCE'=> {
        'total_tickets'=> 1,
        'total_answered_tickets'=> 1,
        'total_user_evaluations'=> 2,
        'average_evaluations'=> 3.0
      },

      'SESA'=> {
        'total_tickets'=> 0,
        'total_answered_tickets'=> 0,
        'total_user_evaluations'=> 0,
        'average_evaluations'=> nil
      },

      'SEMA'=> {
        'total_tickets'=> 0,
        'total_answered_tickets'=> 0,
        'total_user_evaluations'=> 0,
        'average_evaluations'=> nil
      },
    }

    expect(stats_evaluations_sorted_organs_data(organs_hash).keys).to eq(['DETRAN', 'ARCE', 'CAGECE', 'PMCE', 'SEMA', 'SESA'])
    expect(stats_evaluations_sorted_organs_data(organs_hash)['SESA']['average_evaluations']).to be_nil
  end

  it 'sorts without data' do
    organs_hash = nil

    expect(stats_evaluations_sorted_organs_data(organs_hash).keys).to eq([])
  end

  it 'stats_evaluations_sorted_organs_data' do
    themes_hash = {
      'SAÚDE'=>{
        'average'=>nil
      },
      'CULTURA'=>{
        'average'=>nil
      },
      'TURISMO'=>{
        'average'=>nil
      }
    }

    expect(stats_evaluations_sorted_themes_data(themes_hash).keys).to eq(['CULTURA', 'SAÚDE', 'TURISMO'])
  end

  it 'stats_evaluation_last' do
    create(:stats_evaluation, year: 2018, month: 1, evaluation_type: 'sou')
    expected = create(:stats_evaluation, year: 2018, month: 2, evaluation_type: 'sou')
    create(:stats_evaluation, year: 2017, month: 1, evaluation_type: 'sou')
    create(:stats_evaluation, year: 2017, month: 2, evaluation_type: 'sou')

    expect(stats_evaluation_last('sou')).to eq(expected)
  end

  it 'stats_evaluation_transparency_average_icon' do
    expect(stats_evaluation_transparency_average_icon(1.8)).to eq('very_dissatisfied_color')
    expect(stats_evaluation_transparency_average_icon(1.81)).to eq('somewhat_dissatisfied_color')
    expect(stats_evaluation_transparency_average_icon(2.61)).to eq('neutral_color')
    expect(stats_evaluation_transparency_average_icon(3.41)).to eq('somewhat_satisfied_color')
    expect(stats_evaluation_transparency_average_icon(4.21)).to eq('very_satisfied_color')
  end
end
