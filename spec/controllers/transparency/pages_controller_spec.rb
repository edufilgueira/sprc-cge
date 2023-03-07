require 'rails_helper'

describe Transparency::PagesController do

  let(:page) { resource }

  let(:resources) { create_list(:page, 1) }

  let(:resource) { resources.first }

  let(:sort_columns) do
    {
      title: 'page_translations.title'
    }
  end

  it_behaves_like 'controllers/base/index' do
    before do
      allow(controller).to receive(:params_search).and_return(page.title)
    end

    it_behaves_like 'controllers/base/index/paginated'
    it_behaves_like 'controllers/base/index/sorted'
    it_behaves_like 'controllers/base/index/search'
  end

  describe '#show' do
    context 'authorized' do
      before { get(:show, params: { id: page }) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
      end

      describe 'helper methods' do
        it 'page' do
          expect(controller.page).to eq(page)
        end
      end
    end
  end

  describe 'attachments' do
    let(:valid_params) do
      { id: page, title: 'Arquivo', year: Date.current.year }
    end

    let(:attachment_1) { create(:page_attachment, page: page, imported_at: Date.current) }
    let(:attachment_2) { create(:page_attachment, page: page, imported_at: 1.year.ago) }

    context 'authorized' do
      before { get(:attachments, xhr: true, params: valid_params) }


      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template('transparency/pages/_attachments') }
        it { expect(response).not_to render_with_layout('transparency') }
      end
    end

    context 'authorized' do
      describe 'helper methods' do
        before do
          attachment_1
          attachment_2
        end

        describe '#page_attachments' do
          context 'when filter by a valid title' do
            let(:valid_title_params) do
              { id: page, title: 'Arquivo' }
            end

            before { get(:attachments, xhr: true, params: valid_title_params) }

            it 'return the attachment' do
              expect(controller.page_attachments).to eq([attachment_1, attachment_2])
            end
          end

          context 'when filter by a invalid title' do
            let(:invalid_title_params) do
              { id: page, title: 'Teste' }
            end

            before { get(:attachments, xhr: true, params: invalid_title_params) }

            it 'return empty data' do
              expect(controller.page_attachments).to eq([])
            end
          end

          context 'when filter by a valid year' do
            let(:valid_year_params) do
              { id: page, year: Date.current.year }
            end

            before { get(:attachments, xhr: true, params: valid_year_params) }

            it 'return the attachment' do
              expect(controller.page_attachments).to eq([attachment_1])
            end
          end

          context 'when filter by a invalid year' do
            let(:invalid_year_params) do
              { id: page, year: 2.years.ago.year }
            end

            before { get(:attachments, xhr: true, params: invalid_year_params) }

            it 'return the attachment' do
              expect(controller.page_attachments).to eq([])
            end
          end
        end
      end
    end
  end
end
