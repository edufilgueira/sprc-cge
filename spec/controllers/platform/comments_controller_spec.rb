require 'rails_helper'

describe Platform::CommentsController do
  let(:user) { create(:user, :user) }
  let(:ticket) { create(:ticket) }

  let(:permitted_params) do
    [
      :description,
      :commentable_type,
      :commentable_id,
      :scope,

      attachments_attributes: [
        :document
      ]
    ]
  end

  describe '#create' do
    let(:ticket) { create(:ticket, created_by: user) }

    let(:valid_comment) do
      attributes_for(:comment).merge!(commentable)
    end

    let(:invalid_comment) do
      attributes_for(:comment, :invalid).merge!(commentable)
    end

    let(:commentable) do
      {
        commentable_id: ticket.id,
        commentable_type: 'Ticket'
      }
    end

    let(:created_comment) { Comment.last }

    context 'unauthorized' do
      before { post(:create, params: { comment: valid_comment }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      before { sign_in(user) }

      context 'platform user' do

        it 'permits comment params' do
          is_expected.to permit(*permitted_params).
            for(:create, params: { comment: valid_comment }).on(:comment)
        end

        context 'valid' do
          it 'creates a comment, assigning the author' do
            expect do
              post(:create, params: { comment: valid_comment })
            end.to change(Comment, :count).by(1)

            expect(response).to render_template('shared/tickets/_public_comments')

            created_comment = Comment.last
            expect(created_comment.author).to eq user
          end

          it 'creates a public comment, assigning the author' do
            expect do
              post(:create, params: { comment: valid_comment, public_comment: 1 })
            end.to change(Comment, :count).by(1)

            expect(response).to render_template('shared/tickets/_public_comments')

            created_comment = Comment.last
            expect(created_comment.author).to eq user
          end

          describe 'scope' do

            it 'external' do
              post(:create, params: { comment: valid_comment })

              expect(controller.comment.scope).to eq('external')
            end

          end
        end

        context 'invalid' do
          it 'does not save' do
            expect do
              post(:create, params: { comment: invalid_comment })

              expect(controller).to render_template('shared/tickets/_public_comments')
              expect(controller.new_comment.errors[:description]).not_to be_empty

            end.to change(Comment, :count).by(0)
          end
        end

        describe 'helper methods' do
          it 'comment' do
            expect(controller.comment).to be_new_record
          end

          it 'new_comment' do
            post(:create, params: { comment: valid_comment })

            expect(controller.new_comment).to be_new_record
            expect(controller.new_comment.commentable).to eq(ticket)
          end

          it 'comment_form_url' do
            post(:create, params: { comment: valid_comment })

            expect(controller.comment_form_url).to eq([:platform, controller.new_comment])
          end
        end
      end

      describe 'call register ticket log job' do
        let(:tempfile) do
          file = Tempfile.new("test.png", Rails.root + "spec/fixtures")
          file.write('1')
          file.close
          file.open
          file
        end

        let(:attachment) { Rack::Test::UploadedFile.new(tempfile, "image/png") }

        let(:comment_with_attachment) do
          valid_comment[:attachments_attributes] = {
            '1': {
              document: attachment
            }
          }
          valid_comment
        end

        it 'is called after save' do
          allow(RegisterTicketLog).to receive(:call)

          post :create, params: { comment: valid_comment }
          comment = controller.comment

          expected_attributes = {
            resource: comment
          }

          expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :comment, expected_attributes)
        end

        it 'for attachments' do
          allow(RegisterTicketLog).to receive(:call).with(anything, user, :comment, anything)
          allow(RegisterTicketLog).to receive(:call).with(anything, user, :create_attachment, anything)

          post(:create, params: { comment: comment_with_attachment })

          comment = controller.comment
          ticket.reload

          created_attachment = comment.attachments.first

          expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :create_attachment, { resource: created_attachment })
        end
      end

      it 'notify' do
        valid_comment = attributes_for(:comment, :external).merge!(commentable)

        valid_comment_params =
          {
            public_comment: 1,
            ticket_id: ticket.id,
            comment: valid_comment
          }

        service = double

        allow(Notifier::UserComment).to receive(:delay) { service }
        allow(service).to receive(:call)

        post(:create, params: valid_comment_params)


        expect(service).to have_received(:call).with(controller.comment.id, user.id)
      end
    end
  end
end
