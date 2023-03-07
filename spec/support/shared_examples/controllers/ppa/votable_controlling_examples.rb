#
# Shared example para controllers com que possuem inteirações de votos
#
# Basta incluir a chamada it_behaves_like PPA::VotableControlling
# dentro do spec e passar um bloco definindo o contexto:
# ```ruby
# it_behaves_like PPA::VotableControlling do
#   let(:votable) { proposal }         # the resource being liked
#   let(:params)  { base_params }      # params to be used in `post :create` request
# end
# ```
#
shared_examples_for PPA::VotableControlling do

  describe '#create' do
    subject(:post_create) { post :create, params: params }

    it 'defines the votable object' do
      post_create # providing context/params to the controller

      expect(controller.send(:votable)).to eq votable
    end

    it 'creates a like' do
      expect do
        post_create
      end.to change { votable.votes.count }.by(1)

      expect(response).to be_a_redirect
    end
  end

end
