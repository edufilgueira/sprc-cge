require 'rails_helper'

describe Page::Chart::Translation do
  let(:page_chart) { create(:page_chart) }
  subject(:page_chart_translation) { build(:page_chart_translation, page_chart_id: page_chart.id) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:unit).of_type(:string) }
    end
  end
end
