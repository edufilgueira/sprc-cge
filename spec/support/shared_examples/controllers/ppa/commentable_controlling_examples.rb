#
# Shared example para controllers com que possuem inteirações de comments
#
# Basta incluir a chamada it_behaves_like PPA::CommentableControlling
# dentro do spec e passar um bloco definindo o contexto:
# ```ruby
# it_behaves_like PPA::CommentableControlling do
#   let(:commentable) { regional_strategy } # the resource being liked
#   let(:params)      { base_params }        # params to be used in `post :create` request
# end
# ```
#
shared_examples_for PPA::CommentableControlling do

  describe '#create' do
    subject(:post_create) { post :create, params: params }

    it 'implements the #comment_params method' do
      post_create # providing context/params to the controller

      expect { controller.send(:comment_params) }.not_to raise_error
    end

    it 'defines the commentable object' do
      post_create # providing context/params to the controller

      expect(controller.send(:commentable)).to eq commentable
    end

    it 'creates a comment' do
      expect do
        post_create
      end.to change { commentable.comments.count }.by(1)

      expect(commentable.comments.last).to have_attributes controller.send(:comment_params).to_h
      expect(response).to be_a_redirect
    end
  end

end
