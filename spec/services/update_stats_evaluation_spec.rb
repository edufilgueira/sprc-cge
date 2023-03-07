require 'rails_helper'

describe UpdateStatsEvaluation do

  let(:current_date) { Date.today }
  let(:current_month) { current_date.month }
  let(:previous_month) { current_date.last_month.month }
  let(:current_year) { current_date.year }

  it 'initialize' do
    allow(UpdateStatsEvaluation).to receive(:new)

    UpdateStatsEvaluation.new(1, 2018, 'sou')

    expect(UpdateStatsEvaluation).to have_received(:new).with(1, 2018, 'sou')
  end

  describe 'call' do
    let(:detran) { create(:executive_organ, acronym: 'DETRAN', name: 'Departamento Estadual de Trânsito') }
    let(:pmce) { create(:executive_organ, acronym: 'PMCE', name: 'Polícia Militar') }
    let(:theme_admin) { create(:theme, name: 'Adminstração') }
    let(:theme_agri) { create(:theme, name: 'Agricultura') }
    let(:budget_program_admin) { create(:budget_program, theme: theme_admin) }
    let(:budget_program_agri) { create(:budget_program, theme: theme_agri) }
    let(:ticket_detran) { create(:ticket, :with_parent, organ: detran) }
    let(:ticket_pmce) { create(:ticket, :with_parent, organ: pmce) }
    let(:classification_detran) { create(:classification, budget_program: budget_program_admin, ticket: ticket_detran) }
    let(:classification_pmce) { create(:classification, budget_program: budget_program_agri, ticket: ticket_pmce) }
    let(:answer_detran) { create(:answer, ticket: ticket_detran) }
    let(:answer_pmce) { create(:answer, ticket: ticket_pmce) }

    before do
      classification_detran; classification_pmce

      Organ.where.not(id: [detran, pmce]).destroy_all
    end

    let(:expected_data) do
      {
        'summary'=> {
          'total_answered_tickets'=> 2,
          'total_user_evaluations'=> 2,
          'average_question_01_a'=> 4.0,
          'average_question_01_b'=> 4.0,
          'average_question_01_c'=> 4.0,
          'average_question_01_d'=> 4.0,
          'average_question_02'=> 4.0,
          'average_question_03'=> 4.0,
        },

        'organs'=> {
          'PMCE'=> {
            'organ_name'=>'Polícia Militar',
            'total_tickets'=> 1,
            'total_answered_tickets'=> 1,
            'total_user_evaluations'=> 1,
            'average_evaluations'=> 3.0
          },

          'DETRAN'=> {
            'organ_name'=>'Departamento Estadual de Trânsito',
            'total_tickets'=> 1,
            'total_answered_tickets'=> 1,
            'total_user_evaluations'=> 1,
            'average_evaluations'=> 5.0
          }
        },

        'themes'=> {
          'Agricultura'=> {
            'average'=> 3.0
          },

          'Adminstração'=> {
            'average'=> 5.0
          }
        }
      }
    end

    let(:empty_expected_data) do
      {
        'summary'=> {
          'total_answered_tickets'=> 0,
          'total_user_evaluations'=> 0,
          'average_question_01_a'=> nil,
          'average_question_01_b'=> nil,
          'average_question_01_c'=> nil,
          'average_question_01_d'=> nil,
          'average_question_02'=> nil,
          'average_question_03'=> nil,
        },

        'organs'=> {
          'PMCE'=> {
            'organ_name'=>'Polícia Militar',
            'total_tickets'=> 0,
            'total_answered_tickets'=> 0,
            'total_user_evaluations'=> 0,
            'average_evaluations'=> nil
          },

          'DETRAN'=> {
            'organ_name'=>'Departamento Estadual de Trânsito',
            'total_tickets'=> 0,
            'total_answered_tickets'=> 0,
            'total_user_evaluations'=> 0,
            'average_evaluations'=> nil
          }
        },

        'themes'=> {
          'Agricultura'=> {
            'average'=> nil
          },

          'Adminstração'=> {
            'average'=> nil
          }
        }
      }
    end

    it 'create for sou' do
      ticket_rede_ouvir = create(:ticket, :with_rede_ouvir)
      create(:answer, ticket: ticket_rede_ouvir)

      evaluation_detran = create(:evaluation, :note_5, answer: answer_detran)
      evaluation_pmce = create(:evaluation, :note_3, answer: answer_pmce)

      UpdateStatsEvaluation.call(current_year, current_month, 'sou')

      stats_evaluation = Stats::Evaluation.last

      expect(stats_evaluation.data).to eq(expected_data)
    end

    it 'create for call_center' do
      attendance_detran = create(:attendance, ticket: ticket_detran.parent)
      attendance_pmce = create(:attendance, ticket: ticket_pmce.parent)
      evaluation_detran = create(:evaluation, :note_5, answer: answer_detran, evaluation_type: 'call_center')
      evaluation_pmce = create(:evaluation, :note_3, answer: answer_pmce, evaluation_type: 'call_center')

      other_ticket_detran = create(:ticket, :with_parent, organ: detran)
      other_ticket_pmce = create(:ticket, :with_parent, organ: pmce)
      other_answer_detran = create(:answer, ticket: other_ticket_detran)
      other_answer_pmce = create(:answer, ticket: other_ticket_pmce)

      UpdateStatsEvaluation.call(current_year, current_month, 'call_center')

      stats_evaluation = Stats::Evaluation.last

      expect(stats_evaluation.data).to eq(expected_data)
    end

    it 'out of range' do
      evaluation_detran = create(:evaluation, :note_5, answer: answer_detran)
      evaluation_pmce = create(:evaluation, :note_3, answer: answer_pmce)

      UpdateStatsEvaluation.call(current_year, previous_month, 'sou')

      stats_evaluation = Stats::Evaluation.last

      expect(stats_evaluation.data).to eq(empty_expected_data)
    end

    it 'with other answers' do
      create(:answer, :with_cge_approved_partial_answer, ticket: ticket_detran)
      create(:answer, :sectoral_approved, ticket: ticket_detran)
      create(:ticket)
      create(:ticket, :replied)
      create(:ticket, :replied, confirmed_at: Date.today.last_month)
      evaluation_detran = create(:evaluation, :note_5, answer: answer_detran)
      evaluation_pmce = create(:evaluation, :note_3, answer: answer_pmce)

      UpdateStatsEvaluation.call(current_year, current_month, 'sou')

      stats_evaluation = Stats::Evaluation.last

      expected_data['summary']['total_answered_tickets'] = 3
      expect(stats_evaluation.data).to eq(expected_data)
    end

    it 'create for transparency' do
      create(:transparency_survey_answer, answer: 0) # very_satisfied
      create(:transparency_survey_answer, answer: 4) # somewhat_satisfied
      create(:transparency_survey_answer, answer: 3, date: Date.today.last_month) # out

      UpdateStatsEvaluation.call(current_year, current_month, 'transparency')

      stats_evaluation = Stats::Evaluation.last

      expected_data = {
        'summary'=> {
          'total'=> 2,
          'average'=> 4.5,
          'very_dissatisfied'=>0,
          'somewhat_dissatisfied'=>0,
          'neutral'=>0,
          'somewhat_satisfied'=>1,
          'very_satisfied'=>1
        }
      }

      expect(stats_evaluation.data).to eq(expected_data)
    end
  end
end
