require 'rails_helper'

describe Page do
  subject(:page) { build(:page) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:slug).of_type(:string) }
      it { is_expected.to have_db_column(:status).of_type(:integer) }
      it { is_expected.to have_db_column(:parent_id).of_type(:integer) }
      it { is_expected.to have_db_column(:show_survey).of_type(:boolean) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:slug) }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:attachments).dependent(:destroy).class_name('Page::Attachment') }
    it { is_expected.to have_many(:pages).order('page_translations.menu_title') }
    it { is_expected.to have_many(:page_charts).class_name('Page::Chart') }

    it { is_expected.to belong_to(:parent).class_name('Page') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:menu_title) }
    it { is_expected.to validate_presence_of(:status) }

    describe 'can be parent' do
      let(:page_child) { create(:page, :with_parent) }
      let(:page_parent) { page_child.parent }

      context 'invalid' do
        it 'page with parent can`t be parent' do
          page.parent = page_child

          expect(page).to_not be_valid
        end

        it 'parent_id != id' do
          page_parent.parent = page_parent

          expect(page_parent).to_not be_valid
        end
      end

      it 'valid' do
        page.parent = page_parent

        expect(page).to be_valid
      end

    end
  end

  describe 'enums' do

    it 'status' do
      statuses = [:active, :inactive]

      is_expected.to define_enum_for(:status).with_values(statuses)
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:menu_title).to(:parent).with_prefix }
  end

  describe 'helper' do
      it 'status_str' do
      # helper para poder ser usado com content_with_label(page, :status_str)

      expected = Page.human_attribute_name("status.#{page.status}")
      expect(page.status_str).to eq(expected)
    end
  end

  describe 'serializers' do
    it { expect(page.cached_charts).to eq([]) }
  end

  describe 'nested' do
    it { is_expected.to accept_nested_attributes_for(:page_charts) }

    context 'attachments' do

      let(:page) { build(:page) }
      let(:attachment) { attributes_for(:page_attachment) }

      it { is_expected.to accept_nested_attributes_for(:attachments) }

      it 'with document' do
        page.assign_attributes( { attachments_attributes: [ attachment ] } )

        page.save

        expect(page.attachments.count).to eq 1
      end

      it 'with blank document' do
        page.assign_attributes( { attachments_attributes: [ document: '{}' ] } )

        page.save

        expect(page.attachments.count).to eq 0
      end

    end
  end

  describe 'scopes' do
    context 'sorted' do
      it 'sorted' do
        expected = Page.joins(:translations).where("page_translations.locale = '#{I18n.locale}'").order('page_translations.title ASC').to_sql.downcase
        result = Page.sorted.to_sql.downcase
        expect(result).to eq(expected)
      end

      it 'parents' do
        first_unsorted = create(:page, menu_title: 'XYZ', status: :active)
        second_unsorted = create(:page, menu_title: 'ABC', status: :active)
        create(:page, menu_title: 'ABC', status: :inactive)

        create(:page, menu_title: 'ABC', parent_id: second_unsorted.id, status: :active)
        create(:page, menu_title: 'ABC', parent_id: second_unsorted.id, status: :active)

        expect(Page.sorted_parents).to eq([second_unsorted, first_unsorted])
      end
    end
  end

  describe 'callbacks' do
    describe 'after_commit' do
      describe 'cached_charts' do
        let!(:series_item) { create(:page_series_item) }
        let(:series_datum) { series_item.page_series_datum }
        let(:chart) { series_datum.page_chart }
        let(:page) { chart.page }
        let(:expected) { PageSerializer.new(page).to_h[:page_charts] }

        it { expect(page.cached_charts).to eq(expected) }
      end
    end
  end
end
