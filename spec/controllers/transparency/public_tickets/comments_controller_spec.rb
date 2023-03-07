require 'rails_helper'

describe Transparency::PublicTickets::CommentsController do

  let(:user) { create(:user, :user) }

  let(:ticket) { create(:ticket) }
  # let(:citizen_comment) { create(:citizen_comment, ticket: ticket) }

  let(:resources) do
    # citizen_comment

    create_list(:citizen_comment, 1, ticket: ticket)


     # + [citizen_comment]
  end

  let(:permitted_params) { [ :description ] }

  let(:nested_params) do
    { public_ticket_id: ticket.id }
  end

  let(:valid_params) do
    nested_params.merge(citizen_comment: attributes_for(:citizen_comment))
  end

  let(:request_params) { nested_params }

  describe '#index' do
    before { nested_params }

    it_behaves_like 'controllers/base/index' do
      it_behaves_like 'controllers/base/index/xhr'
      it_behaves_like 'controllers/base/index/paginated'
      it_behaves_like 'controllers/base/assets'
    end
  end

  describe '#show' do
    it_behaves_like 'controllers/base/show'
  end

  describe '#new' do
    context 'unauthorized' do
      before { get(:new, params: nested_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/base/new'
    end
  end

  describe '#create' do
    context 'unauthorized' do
      before { post(:create, params: nested_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      render_views

      context 'helper methods' do
        before { post(:create, params: valid_params) }

        it 'comment_form' do
          expect(controller.view_context.comment_form).to be_new_record
        end
      end

      it 'permitted_params' do
        is_expected.to permit(*permitted_params).
        for(:create, params: valid_params).on(:citizen_comment)
      end

      context 'valid' do
        it 'saves' do
          expect do
            post(:create, params: valid_params)

            created = CitizenComment.last

            expect(response).to render_template('transparency/public_tickets/comments/_index')

          end.to change(CitizenComment, :count).by(1)
        end
      end

      context 'invalid' do
        render_views

        it 'does not save' do
          allow_any_instance_of(CitizenComment).to receive(:valid?).and_return(false)

          expect do
            post(:create, params: valid_params)

            expect(response).to render_template('transparency/public_tickets/comments/_index')
          end.to change(CitizenComment, :count).by(0)
        end
      end
    end
  end

  describe '#destroy' do
    context 'unauthorized' do
      before { delete(:destroy, params: nested_params.merge(id: 1)) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/base/destroy'
    end
  end
end
