class Ckeditor::Asset < ApplicationRecord
  include Ckeditor::Backend::Refile
  include Ckeditor::Orm::ActiveRecord::AssetBase
end
