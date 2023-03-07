class Operator::Export::BasePresenter

  attr_reader :resource

  def initialize(resource)
    @resource = resource
  end

  def self.spreadsheet_header
    columns.map do |column|
      spreadsheet_header_title(column)
    end
  end

  def self.tree_structure
  end

  def spreadsheet_row
    columns.map do |column|
      resource.send(column.to_s)
    end
  end
end
