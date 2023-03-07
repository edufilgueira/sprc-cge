require 'fig_leaf'
#
# Cidades escopo limitado do model City do SPRC
# a lib FigLeaf serve pra imperdir que métodos como
# destroy ou delete apaguem registros de City
#
module PPA
  class City < ::City
    include ::FigLeaf

    hide :destroy, :delete, :update!, :update, :update_column, :update_columns

    hide_singletons ActiveRecord::Calculations, ActiveRecord::FinderMethods, ActiveRecord::Attributes,
      except: [ :all, :find, :find_by ]

    belongs_to :region, foreign_key: :ppa_region_id

    default_scope -> { where(state_id: state&.id) } # safe-navigation para factories/tests


    delegate :code, to: :region, prefix: true


    def self.state
      ::State.find_by acronym: 'CE'
    end

  end
end
