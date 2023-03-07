namespace :pages do
  task set_collapse_hide: :environment do
    translations = Page::Translation.where("content ~ ?", 'data-toggle="collapse"')

    ActiveRecord::Base.transaction do
      translations.find_each do |translation|
        new_content = translation.content
        new_content = new_content.gsub(/aria-expanded=\"true\"/, 'aria-expanded="false"')
        new_content = new_content.gsub(/\"card-block collapse show\"/, '"card-block collapse"')

        translation.update_attributes!(content: new_content)
      end
    end
  end
end
