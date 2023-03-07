require 'rails_helper'

describe SorteredHelper do

  context 'table' do

    let(:sort_column) { :status }
    let(:sort_direction) { :desc }
    let(:inverted_sort_direction) { :asc }

    let(:params) do
      {
        id: 'NAO_DEVE_APARECER',
        sort_column: sort_column,
        sort_direction: inverted_sort_direction }
    end

    let(:request_params) do
      {
        controller: 'home',
        sort_direction: 'DEVE SER SOBRESCRITO',
        custom_filter: 'test'
      }
    end

    before do
      controller_class = ActionView::TestCase::TestController
      allow_any_instance_of(controller_class).to receive(:params).and_return(params)
      allow_any_instance_of(controller_class).to receive(:controller_path).and_return('home')

      request = double
      allow(self).to receive(:request) { request }
      allow(request).to receive(:query_parameters).and_return(request_params)
    end

    it 'sortered_table_header' do

      sort_icon_desc = content_tag(:i, '', class: 'fa fa-sort-desc')
      th_content = raw('titulo' + sort_icon_desc)
      link_content = content_tag(:span, th_content, class: 'sorted desc')

      expected_params = request_params.merge(params.except(:id))
      expected = link_to(link_content, expected_params)

      result = sortered_table_header(:status, 'titulo')

      expect(result).to eq(expected)
    end

    it 'sortered_table_active_class' do
      result = sortered_table_active_class(:status)
      expected = 'table-active'

      expect(result).to eq(expected)

      non_active_result = sortered_table_active_class(:other)
      expect(non_active_result).to eq('')
    end
  end
end
