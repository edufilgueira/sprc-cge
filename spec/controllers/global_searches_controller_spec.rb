require 'rails_helper'

describe GlobalSearchesController do

  context 'index' do
    it 'calls GlobalSearcher with search_group and search_content' do

      expect(GlobalSearcher).to receive(:call).with('search_content', 'a')
      get(:index, params: { search_group: :search_content, search_term: 'a' })

      expect(response).not_to render_template("layouts/application")
      expect(response).to render_template('index')
    end
  end
end
