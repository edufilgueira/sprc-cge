require 'rails_helper'

describe TicketArea::CommentsController do

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
    let(:ticket) { create(:ticket) }

    let(:valid_comment) do
      attributes_for(:comment).merge!({
        commentable_id: ticket.id,
        commentable_type: 'Ticket'
      })
    end
    let(:invalid_comment) { attributes_for(:comment, :invalid) }

    let(:created_comment) { Comment.last }

    context 'unauthorized' do
      before { post(:create, params: { comment: valid_comment }) }

      it { is_expected.to redirect_to(new_ticket_session_path) }
    end

    context 'authorized' do

      before { sign_in(ticket) }

      it 'permits comment params' do
        is_expected.to permit(*permitted_params).
          for(:create, params: { params: { comment: valid_comment } }).on(:comment)
      end

      context 'valid' do
        it 'creates a comment, assigning the author' do
          expect do
            post(:create, params: { comment: valid_comment })
          end.to change(Comment, :count).by(1)

          expect(response).to render_template('shared/tickets/_public_comments')

          created_comment = Comment.last
          expect(created_comment.author).to eq ticket
        end
      end

      context 'invalid' do
        it 'does not save' do
          expect do
            post(:create, params: { comment: invalid_comment })

            expect(controller).to render_template('shared/tickets/_public_comments')

          end.to change(Comment, :count).by(0)
        end

        describe 'scope' do
          it 'external' do
            post(:create, params: { comment: valid_comment })

            expect(controller.comment.external?).to be_truthy
          end
        end
      end

      describe 'helper methods' do
        it 'ticket' do
          expect(controller.ticket).to eq(ticket)
        end

        it 'comment' do
          expect(controller.comment).to be_new_record
        end

        it 'comment_form_url' do
          expect(controller.comment_form_url).to eq([:ticket_area, controller.new_comment])
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

        before { allow(RegisterTicketLog).to receive(:call) }

        it 'is called after save' do
          post :create, params: { comment: valid_comment }

          comment = controller.comment
          expected_attributes = {
            resource: comment
          }

          expect(RegisterTicketLog).to have_received(:call).with(ticket, ticket, :comment, expected_attributes)
        end

        it 'for attachments' do
          allow(RegisterTicketLog).to receive(:call).with(anything, ticket, :comment, anything)
          allow(RegisterTicketLog).to receive(:call).with(anything, ticket, :create_attachment, anything)

          post(:create, params: { comment: comment_with_attachment })

          comment = controller.comment
          ticket.reload

          created_attachment = comment.attachments.first

          expect(RegisterTicketLog).to have_received(:call).with(ticket, ticket, :create_attachment, { resource: created_attachment })
        end
      end

      it 'notify' do

        valid_comment = attributes_for(:comment, :external).merge!({
          commentable_id: ticket.id,
          commentable_type: 'Ticket'
        })

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


        expect(service).to have_received(:call).with(controller.comment.id, nil)
      end
    end
  end
end
