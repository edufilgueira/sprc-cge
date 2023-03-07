#
# Override de matcher para corrigir o have_db_index do shoulda_matcher.
#
# Ver mais em: https://github.com/thoughtbot/shoulda-matchers/pull/1051
#
# Ele não funciona com databases múltiplas pois usa:
#
# def indexes
#    ::ActiveRecord::Base.connection.indexes(table_name)
# end
#
# e deveria usar:
#
# def indexes
#    model_class.connection.indexes(table_name)
# end
#

module Shoulda
  module Matchers
    module ActiveRecord

      class HaveDbIndexMatcher

        def indexes
          model_class.connection.indexes(table_name)
        end
      end
    end
  end
end
