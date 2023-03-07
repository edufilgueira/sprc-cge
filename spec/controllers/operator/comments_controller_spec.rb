require 'rails_helper'

describe Operator::CommentsController do
  let(:user) { create(:user, :operator) }

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
    let(:ticket) { create(:ticket, :with_parent) }
    let(:parent) { ticket.parent }
    let(:inactive_ticket) { create(:ticket, :with_parent, :invalidated, parent: parent) }

    let(:valid_comment) do
      attributes_for(:comment, :internal).merge!(commentable)
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

    let(:internal_comment_attributes) do
      attributes_for(:comment, :internal).merge!(commentable)
    end

    let(:citizen_comment_attributes) do
      attributes_for(:comment, :external).merge!(commentable)
    end

    let(:valid_comment_params) do
      {
        comment: valid_comment
      }
    end

    before { inactive_ticket }


    context 'unauthorized' do
      before { post(:create, params: valid_comment_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      before { sign_in(user) }

      context 'operator user' do

        it 'permits comment params' do
          should permit(*permitted_params).
            for(:create, params:  valid_comment_params ).on(:comment)
        end

        context 'valid' do
          it 'creates a comment, assigning the author' do
            expect do
              post(:create, params: valid_comment_params)
            end.to change(Comment, :count).by(1)

            expect(response).to render_template('shared/tickets/_comments')

            created_comment = Comment.last
            expect(created_comment.author).to eq(user)
          end

          context 'scope' do

            it 'external' do
              post(:create, params: citizen_comment_attributes)

              expect(controller.comment.external?).to be_truthy
            end

            it 'internal' do
              post(:create, params: { comment: internal_comment_attributes })

              expect(controller.comment.internal?).to be_truthy
            end

          end

        end

        context 'invalid' do
          it 'does not save' do
            expect do
              post(:create, params: { comment: invalid_comment })

              expect(controller).to render_template('shared/tickets/_public_comments')

            end.to change(Comment, :count).by(0)
          end
        end

        context 'external comment' do
          let(:valid_comment) do
            attributes = attributes_for(:comment, :external).merge!(commentable)
            attributes
          end

          let(:valid_comment_params) do
            {
              comment: valid_comment
            }
          end

          context 'valid' do
            it 'saves' do
              expect do
                post(:create, params: valid_comment_params)

                expect(controller).to render_template('shared/tickets/_public_comments')

              end.to change(Comment, :count).by(1)
            end

            context 'when operator internal' do
              let(:user) { create(:user, :operator_internal) }

              it 'does not saves' do
                expect do
                  post(:create, params: valid_comment_params)

                  expect(controller).to respond_with(:forbidden)
                end.to change(Comment, :count).by(0)
              end
            end

            context 'when comment in child' do
              let(:parent) { ticket.parent }

              it 'saves comment in parent' do
                expect do
                  post(:create, params: valid_comment_params)

                  comment = Comment.last

                  expect(comment.commentable).to eq(parent)
                  expect(controller.ticket).to eq(ticket)

                end.to change(Comment, :count).by(1)
              end
            end
          end
        end

        describe 'helper methods' do
          it 'comment' do
            expect(controller.comment).to be_new_record
          end

          it 'comment_form_url' do
            post(:create, params: valid_comment_params)

            expect(controller.comment_form_url).to eq([:operator, controller.new_comment])
          end

          it 'scope' do
            post(:create, params: { comment: internal_comment_attributes })

            expect(controller.comment.scope).to eq(internal_comment_attributes[:scope].to_s)
          end

          context 'readonly?' do
            it { expect(controller.readonly?).to be_falsey }
          end

        end # helper methods
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
          post :create, params: valid_comment_params
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

        context 'when operator cge' do
          let!(:organ_cge) { create(:executive_organ, acronym: 'CGE') }
          let(:user) { create(:user, :operator_cge) }

          context 'when ticket parent' do
            let(:ticket) { create(:ticket, :confirmed) }
            let(:parent) { ticket }

            it 'call RegisterTicketLog for parent ticket' do
              post :create, params: valid_comment_params
              comment = controller.comment

              expected_attributes = {
                resource: comment
              }

              expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :comment, expected_attributes)
            end
          end

          context 'when ticket child' do
            it 'call RegisterTicketLog for parent ticket' do
              post :create, params: valid_comment_params
              comment = controller.comment

              expected_attributes = {
                resource: comment
              }

              expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :comment, expected_attributes)
              expect(RegisterTicketLog).to have_received(:call).with(ticket.parent, user, :comment, expected_attributes)
            end
          end
        end

        describe 'operator_type sectoral' do
          let(:user) { create(:user, :operator_sectoral) }

          it 'call RegisterTicketLog for parent ticket' do
            post :create, params: valid_comment_params
            comment = controller.comment

            expected_attributes = {
              resource: comment
            }

            expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :comment, expected_attributes)
            expect(RegisterTicketLog).to have_received(:call).with(ticket.parent, user, :comment, expected_attributes)
          end
        end

        describe 'operator_type internal' do
          let(:user) { create(:user, :operator_internal) }

          it 'call RegisterTicketLog for parent ticket' do
            post :create, params: valid_comment_params
            comment = controller.comment

            expected_attributes = {
              resource: comment
            }

            expect(RegisterTicketLog).to have_received(:call).with(ticket, user, :comment, expected_attributes)
            expect(RegisterTicketLog).to have_received(:call).with(ticket.parent, user, :comment, expected_attributes)
          end
        end
      end

      describe 'notify' do
        it 'external_comment' do

          valid_comment = attributes_for(:comment, :external).merge!(commentable)


          valid_comment_params =
            {
              ticket_id: ticket.id,
              comment: valid_comment
            }

          service = double

          allow(Notifier::UserComment).to receive(:delay) { service }
          allow(service).to receive(:call)

          post(:create, params: valid_comment_params)


          expect(service).to have_received(:call).with(controller.comment.id, user.id)
        end

        it 'internal_comment' do
          service = double

          allow(Notifier::InternalComment).to receive(:delay) { service }
          allow(service).to receive(:call)

          post(:create, params: { comment: internal_comment_attributes })

          expect(service).to have_received(:call).with(controller.comment.id, user.id)
        end
      end

      context 'with existent attachment' do

        let(:existent_comment) { create(:comment, commentable: ticket) }
        let(:existent_attachment) { create(:attachment, attachmentable: existent_comment)}

        let(:valid_comment) do
          attributes = attributes_for(:comment).merge!(commentable)
          attributes
        end

        let(:valid_comment_params) do
          {
            clone_attachments: [ existent_attachment.id ],
            comment: valid_comment
          }
        end

        let(:created_comment) { Comment.last }

        context 'valid' do

          before do
            existent_attachment
          end

          it 'saves' do
            expect do
              post(:create, params: valid_comment_params)

              created_attachment = created_comment.attachments.first

              expect(created_attachment.document_id).to eq(existent_attachment.document_id)
              expect(created_attachment.document_filename).to eq(existent_attachment.document_filename)
            end.to change(Attachment, :count).by(1)
          end
        end
      end
    end
  end
end
