module Transparency::Expenses::FundSupplies::BaseController
  extend ActiveSupport::Concern
  include Transparency::Expenses::BaseController

  included do

    helper_method [
      :fund_supplies,

      :fund_supply,

      :year
    ]

    # Helper methods

    def fund_supplies
      paginated_resources
    end

    def fund_supply
      resource
    end

    # Private

    private

    def resource_klass
      Integration::Expenses::FundSupply
    end

    def transparency_id
      'expenses/fund_supplies'
    end

    ## Spreadsheet

    def spreadsheet_download_prefix
      'expenses/fund_supplies'
    end

    def spreadsheet_file_prefix
      :suprimento_fundos
    end

    ## Stats

    def stats_klass
      Stats::Expenses::FundSupply
    end

    def stats_yearly?
      true
    end
  end
end
