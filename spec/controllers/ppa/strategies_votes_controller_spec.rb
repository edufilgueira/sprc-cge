require 'rails_helper'

RSpec.describe PPA::StrategiesVotesController, type: :controller do
  let(:plan) { create :ppa_plan }
  let(:region) { create :ppa_region }
  let!(:user) { create :user }

  describe '#new' do
    describe 'not authenticated' do
      it do
        get(:new, params: { plan_id: plan.id, region_code: region.code })
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'with authentication' do


      before do
        sign_in user
      end

      describe 'region voting validation' do
        describe 'dont exist voting schedule' do

          it do
            get(:new, params: { plan_id: plan.id, region_code: region.code })
            result = region.strategic_voting_open?

            expect(result).to be(false)
            expect(response).to redirect_to ppa_plan_path(plan.id)
          end
        end

        describe 'opened to vote' do

          it do
            PPA::Voting.create(
              start_in: (Time.current - 1.days),
              end_in: (Time.current + 1.days),
              plan_id: plan.id,
              region_id: region.id
            )

            get(:new, params: { plan_id: plan.id, region_code: region.code })
            result = region.strategic_voting_open?
            redirect_url = new_ppa_plan_strategies_vote_path(region_code: region.code)

            expect(result).to be(true)
            is_expected.to render_template(:new)
          end
        end

        describe 'out of deadline to vote' do

          it do
            PPA::Voting.create(
              start_in: (Time.current - 10.days), # anterior data atual
              end_in: (Time.current - 5.days), # anterior data atual
              plan_id: plan.id,
              region_id: region.id
            )

            get(:new, params: { plan_id: plan.id, region_code: region.code })
            result = region.strategic_voting_open?

            expect(result).to be(false)
            expect(response).to redirect_to ppa_plan_path(plan.id)
          end
        end
      end

      it 'has vote in this plan' do
        PPA::Voting.create(
          start_in: (Time.current - 1.days),
          end_in: (Time.current + 1.days),
          plan_id: plan.id,
          region_id: region.id
        )
        10.times { create(:ppa_strategy) }

        str_vote = PPA::StrategiesVote.create(
          user: user,
          region: region,
        )
        5.times { |i| str_vote.strategies_vote_items.build(strategy_id: i+1).save }

        get(:new, params: { plan_id: plan.id, region_code: region.code })

        result = ppa_plan_path(plan.id)

        expect(response).to redirect_to ppa_plan_path(plan.id)
      end
    end
  end
end
