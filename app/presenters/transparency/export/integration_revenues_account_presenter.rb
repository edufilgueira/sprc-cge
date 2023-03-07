class Transparency::Export::IntegrationRevenuesAccountPresenter < Transparency::Export::BasePresenter

  COLUMNS = [
    :title,
    :valor_previsto_inicial,
    :valor_previsto_atualizado,
    :valor_arrecadado
  ].freeze

  # overriding
  def self.tree_structure
    true
  end

  def spreadsheet_row
    revenues_tree = Integration::Revenues::RevenuesTree.new(resource)
    nodes = revenues_tree.nodes(:organ)

    nodes.map do |node|
      columns.map do |column|
        node[column]
      end
    end
  end

  # Override

  private

  def self.spreadsheet_header_title(column)
    I18n.t("integration/revenues/account.spreadsheet.worksheets.default.header.#{column}")
  end

  def self.columns
    self::COLUMNS
  end

  def columns
    self.class.columns
  end
end
