#
# Shared example para controllers com que possuem inteirações de likes
#
# Basta incluir a chamada it_behaves_like PPA::LikableControlling
# dentro do spec e passar um bloco definindo o contexto:
# ```ruby
# it_behaves_like PPA::LikableControlling do
#   let(:likable) { regional_strategy } # the resource being liked
#   let(:params) { base_params }        # params to be used in `post :create` request
# end
# ```
#
shared_examples_for PPA::LikableControlling do

  describe '#create' do
    subject(:post_create) { post :create, params: params }

    it 'defines the likable object' do
      post_create # providing context/params to the controller

      expect(controller.send(:likable)).to eq likable
    end

    it 'creates a like' do
      expect do
        post_create
      end.to change { likable.likes.count }.by(1)

      expect(response).to be_a_redirect
    end
  end

end
