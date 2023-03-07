#
# Shared example para controllers com que possuem inteirações de dislikes
#
# Basta incluir a chamada it_behaves_like PPA::DislikableControlling
# dentro do spec e passar um bloco definindo o contexto:
# ```ruby
# it_behaves_like PPA::DislikableControlling do
#   let(:dislikable) { regional_strategy } # the resource being disliked
#   let(:params)     { base_params }        # params to be used in `post :create` request
# end
# ```
#
shared_examples_for PPA::DislikableControlling do

  describe '#create' do
    subject(:post_create) { post :create, params: params }

    it 'defines the dislikable object' do
      post_create # providing context/params to the controller

      expect(controller.send(:dislikable)).to eq dislikable
    end

    it 'creates a dislike' do
      expect do
        post_create
      end.to change { dislikable.dislikes.count }.by(1)

      expect(response).to be_a_redirect
    end
  end

end
