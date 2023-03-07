require 'rails_helper'

describe Admin::PagesController do

  let(:user) { create(:user, :admin) }

  let(:resources) { create_list(:page, 1) }

  let(:permitted_params) do
    [
      :title,
      :content,
      :status,
      :menu_title,
      :parent_id,

      :show_survey,

      attachments_attributes: [
        :id, :document, :title, :imported_at, :_destroy
      ],
      page_charts_attributes: [
        :id, :title, :unit, :_destroy,
        page_series_data_attributes: [
          :id, :title, :series_type, :_destroy,
          page_series_items_attributes: [
            :id, :title, :value, :_destroy
          ]
        ]
      ]
    ]
  end

  let(:valid_params) { { page: attributes_for(:page) } }

  let(:sort_columns) do
    {
      title: 'page_translations.title'
    }
  end

  it_behaves_like 'controllers/admin/base/index' do
    it_behaves_like 'controllers/base/index/paginated'
    it_behaves_like 'controllers/base/index/search'
    it_behaves_like 'controllers/base/index/sorted'

    it_behaves_like 'controllers/admin/base/index/xhr'
  end

  it_behaves_like 'controllers/admin/base/new'
  it_behaves_like 'controllers/admin/base/create'
  it_behaves_like 'controllers/admin/base/show'
  it_behaves_like 'controllers/admin/base/edit'
  it_behaves_like 'controllers/admin/base/update'
  it_behaves_like 'controllers/admin/base/destroy'

  describe 'attachments' do
    let(:page) { create(:page) }
    let(:attachment_1) { create(:page_attachment, page: page, imported_at: Date.current) }
    let(:attachment_2) { create(:page_attachment, page: page, imported_at: 1.year.ago) }

    let(:valid_params) do
      {
        id: page,
        year: Date.current.year
      }
    end

    context 'unauthorized' do
      before { get(:attachments, xhr: true, params: valid_params) }

      it { is_expected.to respond_with(:unauthorized) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:attachments, xhr: true, params: valid_params) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template('admin/pages/_attachments') }
        it { expect(response).not_to render_with_layout('admin') }
      end

      describe 'helper methods' do
        before do
          attachment_1
          attachment_2
        end

        it 'page_attachments' do
          expect(controller.page_attachments).to eq([attachment_1])
        end
      end
    end
  end
end
