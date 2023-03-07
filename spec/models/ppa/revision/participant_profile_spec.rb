require 'rails_helper'

RSpec.describe PPA::Revision::ParticipantProfile , type: :model do
  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:age).of_type(:integer) }
      it { is_expected.to have_db_column(:genre).of_type(:integer) }
      it { is_expected.to have_db_column(:breed).of_type(:integer) }
      it { is_expected.to have_db_column(:ethnic_group).of_type(:integer) }
      it { is_expected.to have_db_column(:educational_level).of_type(:integer) }
      it { is_expected.to have_db_column(:family_income).of_type(:integer) }
      it { is_expected.to have_db_column(:representative).of_type(:integer) }
      it { is_expected.to have_db_column(:representative_description).of_type(:string) }
      it { is_expected.to have_db_column(:collegiate).of_type(:string) }
      it { is_expected.to have_db_column(:other_ppa_participation).of_type(:boolean) }
      it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
      it { is_expected.to have_db_column(:sexual_orientation).of_type(:integer) }
      it { is_expected.to have_db_column(:deficiency).of_type(:integer) }
      it { is_expected.to have_db_column(:other_deficiency).of_type(:string) }
      it { is_expected.to have_db_column(:other_sexual_orientation).of_type(:string) }
      it { is_expected.to have_db_column(:other_genre).of_type(:string) }
      it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
  end

  describe 'data integrity' do
    context 'when other_sexual_orientation is defined' do
      it 'sexual_orientation is defined' do
        user = create(:user)
        participant_profile = PPA::Revision::ParticipantProfile.new
        participant_profile.other_sexual_orientation = 'Abc'
        participant_profile.user_id = user.id
        participant_profile.save
        expect(participant_profile.sexual_orientation).to eq('other_sexual_orientation')
      end
    end

    context 'when other_genre is defined' do
      it 'genre is defined' do
        user = create(:user)
        participant_profile = PPA::Revision::ParticipantProfile.new
        participant_profile.other_genre = 'Abc'
        participant_profile.user_id = user.id
        participant_profile.save
        expect(participant_profile.genre).to eq('other_genre')
      end
    end

    context 'when other_deficiency is defined' do
      it 'deficiency is defined' do
        user = create(:user)
        participant_profile = PPA::Revision::ParticipantProfile.new
        participant_profile.other_deficiency = 'Abc'
        participant_profile.user_id = user.id
        participant_profile.save
        expect(participant_profile.deficiency).to eq('other_deficiency')
      end
    end
  end
end
