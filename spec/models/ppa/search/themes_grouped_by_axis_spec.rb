require 'rails_helper'

module PPA::Search
  RSpec.describe ThemesGroupedByAxis, type: :model do

    let(:axis)  { create :ppa_axis }
    let!(:theme1) { create :ppa_theme, name: 'foo', axis: axis }
    let!(:theme2) { create :ppa_theme, name: 'bar', axis: axis }

    context 'SearchRecord' do
      let(:record) { described_class.new.records.first }

      describe '#name' do
        it 'is equal to axis name' do
          expect(record.name).to eq axis.name
        end
      end

      describe '#themes' do
        it 'returns an array' do
          expect(record.themes).to be_kind_of(Array)
        end

        it 'has PPA::Theme instances' do
          expect(record.themes.first).to be_kind_of(PPA::Theme)
        end
      end

      it 'is sorted by name' do
        expect(record.themes).to eq [theme2, theme1]
      end
    end

    context 'without search term' do
      let(:records) { described_class.new.records }

      it 'return both themes' do
        expect(records.first.themes).to match_array([theme1, theme2])
      end
    end

    context 'with foo as search term' do
      let(:records) { described_class.new({term: 'foo'}).records }

      it 'return filtered theme' do
        expect(records.first.themes).to match_array([theme1])
      end
    end

  end
end
