#
# Shared example para action index com ordenação
#
# Espera os seguintes atributos para o teste:
#   sort_columns, first_unsorted, last_unsorted
#
# Ex:
#
# ...
#
#   let(:sort_columns) do
#     ['organs.acronym', 'organs.name']
#   end
#
#   let(:first_unsorted) do
#     create(:executive_organ, acronym: '456', name: '123')
#   end
#
#   let(:last_unsorted) do
#     create(:executive_organ, acronym: '123', name: '456')
#   end
#
#   it_behaves_like 'controllers/base/index/sorted'
#
# ...
#

shared_examples_for 'controllers/base/index/sorted' do

  let(:last_sort_column) do
    if sort_columns.is_a?(Array)
      sort_columns.last
    else
      # Hash
      sort_columns[sort_columns.keys.last]
    end
  end

  it 'sort_columns helper' do
    expect(controller.sort_columns).to eq(sort_columns)
  end

  private

  def resource_name
    controller.controller_name.singularize
  end

  def resources_symbol
    (controller.try(:send, :resource_symbol) || resource_name).to_s.pluralize.to_sym
  end
end
