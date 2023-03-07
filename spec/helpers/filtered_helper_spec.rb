require 'rails_helper'

describe FilteredHelper do

  describe 'filtered status' do

    let(:filtered_items) do
      [:search, :user_type, :city_id, :column, :custom, :date_range, :ignored]
    end

    let(:filters) do
      filtered_items.inject({}) do |result, filter_name|
        result[filter_name] = 'test'
        result
      end
    end

    let(:filter_only) do
      { search: 'test' }
    end

    before do
      stub_const('ActionView::TestCase::TestController::FILTERED_COLUMNS', [:column, :ignored])
      stub_const('ActionView::TestCase::TestController::FILTERED_ENUMS', [:group])
      stub_const('ActionView::TestCase::TestController::FILTERED_ASSOCIATIONS', [:city_id, {members: :city_id}])
      stub_const('ActionView::TestCase::TestController::FILTERED_CUSTOM', [:custom])
      stub_const('ActionView::TestCase::TestController::FILTERED_DATE_RANGE', [:date_range])
      stub_const('ActionView::TestCase::TestController::FILTERED_IGNORE_IN_HIGHLIGHTS', [:ignored])
    end

    it 'not filtered' do
      expect(helper.filtered?).to eq(false)
    end

    it 'filtered' do
      allow(controller).to receive(:params).and_return(filters)

      expect(helper.filtered?).to eq(true)
    end

    it 'not filtered if ignored' do
      allow(controller).to receive(:params).and_return({ignored: '1'})

      expect(helper.filtered?).to eq(false)
    end

    it 'filtered by custom filters' do
      # usado para filtros que não estão mapeados mas que devem ser considerados
      # para exibir o aviso de que os resultados estão filtrados.

      allow(controller).to receive(:params).and_return({ custom: 123 })

      expect(helper.filtered?).to eq(true)
    end

    it 'filtered by association' do
      association_filters = {
        city_id: 1
      }

      allow(controller).to receive(:params).and_return(association_filters)

      expect(helper.filtered?).to eq(true)
    end

    it 'filtered by filter param' do
      allow(controller).to receive(:params).and_return(filter_only)

      expect(helper.filtered?).to eq(true)
    end

    it 'filter_expression for highlight' do
      search = ' teste 1234 '
      expected = search.strip.split(' ')

      allow(controller).to receive(:params).and_return({ search: search })

      expect(helper.filter_expression).to eq(expected)
    end

    it 'highlighted filtered expression' do
      expected = highlight('a', filter_expression)
      result = helper.filtered_highlighted('á') # verifica se dá highlight sem acento!

      expect(result).to eq(expected)
    end

    it 'filtered_highlighted accepts hash' do
      # Quando o filtered_highlighted é usado com uma tradução que não existe,
      # temos (undefined method `strip' for #<Hash:0x000000081d1138>).
      #

      result = helper.filtered_highlighted({ teste: '123' })
      expected = helper.filtered_highlighted({ teste: '123' }.to_s)

      expect(result).to eq(expected)
    end

    it 'filtered by column' do
      filters = {
        column: 'true'
      }

      allow(controller).to receive(:params).and_return(filters)

      expect(helper.filtered?).to eq(true)
    end
  end
end
