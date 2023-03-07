class Transparency::Revenues::NodeTypesController < Transparency::Revenues::AccountsController
  include Transparency::RevenuesHelper

  def index_partial_view_path
    default_index_path
  end

  def javascript
    'transparency'
  end

  def default_index_path
    '/shared/transparency/revenues/node_types'
  end

end
