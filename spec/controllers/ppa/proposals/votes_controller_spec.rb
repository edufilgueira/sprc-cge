require 'rails_helper'

# Testes comentados. Controller em desuso. A votação foi construida em outro controller.

RSpec.describe PPA::Proposals::VotesController, type: :controller do

  # let(:plan)        { create :ppa_plan, base_date: Date.today, voting_start_in: Date.today } # must be open for voting
  # let(:proposal)    { create :ppa_proposal, plan: plan }
  # let(:base_params) { { proposal_id: proposal.id } }

  # # requires authentication
  # let(:user) { create :user, :citizen }
  # before { sign_in user }

  # it_behaves_like PPA::VotableControlling do
  #   let(:votable) { proposal }
  #   let(:params) { base_params }
  # end

  # describe '#create' do
  #   subject(:post_create) { post :create, params: base_params }

  #   context 'requirements' do
  #     it 'requires authentication' do
  #       sign_out user
  #       post_create
  #       expect(response).to redirect_to new_user_session_path
  #     end

  #     it 'requires proposal plan to be open for voting on its proposals' do
  #       plan = proposal.plan
  #       plan.update! voting_start_in: Date.yesterday - 6.months,
  #                    voting_end_in:   Date.yesterday - 1.month
  #       expect(plan).not_to be_open_for_voting # sanity check

  #       post_create
  #       expect(response).to redirect_to ppa_root_path
  #       expect(flash[:alert]).to include I18n.t('ppa.proposals.votes.ensure_open_for_voting.alert')
  #     end
  #   end
  # end

end
