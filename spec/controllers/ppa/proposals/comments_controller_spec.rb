require 'rails_helper'

# Teste comentado. Controller não está sendo usado. Nem existe Rota.

RSpec.describe PPA::Proposals::CommentsController, type: :controller do

  # let!(:proposal) { create :ppa_proposal }

  # let(:base_params) do {
  #   proposal_id: proposal.id,
  #   ppa_comment: {
  #     content: 'To beer or not to beer?'
  #   }
  # } end

  # # requires authentication
  # let(:user) { create :user, :citizen }

  # before { sign_in user }

  # context 'behaviors' do
  #   it_behaves_like PPA::CommentableControlling do
  #     let(:commentable) { proposal }
  #     let(:params)      { base_params }
  #   end
  # end

  # describe '#create' do
  #   subject(:post_create) { post :create, params: base_params }

  #   it 'requires authentication' do
  #     sign_out user
  #     post_create
  #     expect(response).to redirect_to new_user_session_path
  #   end
  # end

end
