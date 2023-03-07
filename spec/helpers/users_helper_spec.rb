require 'rails_helper'

describe UsersHelper do

  describe 'document_type' do
    it 'user_document_types_for_select' do
      document_types = User.document_types.except(:cnpj, :registration)

      expected = document_types.keys.sort.map do |document_type|
        [ I18n.t("user.document_types.#{document_type}"), document_type ]
      end

      expect(user_document_types_for_select).to eq(expected)
    end

    it 'user_admin_document_types_for_select' do
      document_types = User.document_types.except(:cnpj)

      expected = document_types.keys.sort.map do |document_type|
        [ I18n.t("user.document_types.#{document_type}"), document_type ]
      end

      expect(user_admin_document_types_for_select).to eq(expected)
    end
  end

  describe 'user_type' do
    it 'user_user_types_for_select' do
      user_types = User.user_types

      expected = user_types.keys.map do |user_type|
        [ I18n.t("user.user_types.#{user_type}"), user_type ]
      end

      expect(user_user_types_for_select).to eq(expected)
    end

    it 'user_administrative_user_types_for_select' do
      user_types = [:operator, :admin]

      expected = user_types.map do |user_type|
        [ I18n.t("user.user_types.#{user_type}"), user_type ]
      end

      expect(user_administrative_user_types_for_select).to eq(expected)
    end
  end

  describe 'operator_type' do
    it 'user_operator_types_for_select' do
      operator_types = User.operator_types

      expected = operator_types.keys.map do |operator_type|
        [ I18n.t("user.operator_types.#{operator_type}"), operator_type ]
      end.sort.to_h

      expect(user_operator_types_for_select).to eq(expected)
    end

    context 'user_operator_types_for_operators_for_select' do
      it 'sou' do
        user = create(:user, :operator_sectoral)

        operator_types = [:internal, :sou_sectoral, :sic_sectoral, :subnet_sectoral]

        expected = operator_types.map do |operator_type|
          [ I18n.t("user.operator_types.#{operator_type}"), operator_type ]
        end.sort.to_h

        expect(user_operator_types_for_operators_for_select(user)).to eq(expected)
      end

      it 'subnet' do
        user = create(:user, :operator_subnet)

        operator_types = [:internal, :subnet_sectoral]

        expected = operator_types.map do |operator_type|
          [ I18n.t("user.operator_types.#{operator_type}"), operator_type ]
        end.sort.to_h

        expect(user_operator_types_for_operators_for_select(user)).to eq(expected)
      end

      it 'sic' do
        user = create(:user, :operator_sectoral_sic)

        operator_types = [:internal, :sic_sectoral]

        expected = operator_types.map do |operator_type|
          [ I18n.t("user.operator_types.#{operator_type}"), operator_type ]
        end.sort.to_h

        expect(user_operator_types_for_operators_for_select(user)).to eq(expected)
      end

      it 'cge' do
        user = create(:user, :operator_cge)

        operator_types = [:internal, :sou_sectoral, :sic_sectoral, :cge, :chief, :subnet_sectoral, :subnet_chief, :coordination]

        expected = operator_types.map do |operator_type|
          [ I18n.t("user.operator_types.#{operator_type}"), operator_type ]
        end.sort.to_h

        expect(user_operator_types_for_operators_for_select(user)).to eq(expected)
      end

      it 'rede ouvir' do
        rede_ouvir_organ = create(:rede_ouvir_organ)
        user = create(:user, :operator_sou_sectoral, organ: rede_ouvir_organ)

        operator_types = [:sou_sectoral]

        expected = operator_types.map do |operator_type|
          [ I18n.t("user.operator_types.#{operator_type}"), operator_type ]
        end.sort.to_h

        expect(user_operator_types_for_operators_for_select(user)).to eq(expected)
      end
    end
  end

  describe 'person_type' do
    it 'user_person_types_for_select' do
      person_types = User.person_types

      expected = person_types.keys.map do |person_type|
        [ I18n.t("user.person_types.#{person_type}"), person_type ]
      end.sort.to_h

      expect(user_person_types_for_select).to eq(expected)
    end
  end

  describe 'gender' do
    it 'user_gender_for_select' do
      genders = User.genders

      expected = genders.keys.map do |gender|
        [ I18n.t("user.genders.#{gender}"), gender ]
      end.sort.to_h

      expect(user_gender_for_select).to eq(expected)
    end
  end

  describe 'education_level' do
    it 'user_education_level_for_select' do
      education_levels = User.education_levels

      expected = education_levels.keys.map do |education_level|
        [ I18n.t("user.education_levels.#{education_level}"), education_level ]
      end.sort.to_h

      expect(user_education_level_for_select).to eq(expected)
    end
  end

  describe 'admin?' do
    let(:admin) { build(:user, :admin) }
    let(:user) { build(:user, :user) }
    let(:ticket) { build(:ticket) }

    it { expect(admin?(admin)).to be true }
    it { expect(admin?(user)).to be false }
    it { expect(admin?(ticket)).to be false }
  end

  describe 'operator?' do
    let(:operator) { build(:user, :operator) }
    let(:user) { build(:user, :user) }

    it { expect(operator?(operator)).to be true }
    it { expect(operator?(user)).to be false }
  end

  describe 'user?' do
    let(:user) { build(:user, :user) }
    let(:operator) { build(:user, :operator) }
    let(:admin) { build(:user, :admin) }

    it { expect(user?(user)).to be_truthy }
    it { expect(user?(operator)).to be_falsey }
    it { expect(user?(admin)).to be_falsey }
    it { expect(user?(nil)).to be_falsey }
  end

  describe 'user_facebook?' do
    let(:user) { build(:user, :user) }
    let(:user_facebook) { build(:user, :user_facebook) }

    it { expect(user_facebook?(user)).to be_falsey }
    it { expect(user_facebook?(user_facebook)).to be_truthy }
  end

  describe 'operator_sectoral_or_internal?' do
    let(:operator_cge) { build(:user, :operator_cge) }
    let(:operator_sectoral) { build(:user, :operator_sectoral) }
    let(:operator_internal) { build(:user, :operator_internal) }

    it { expect(operator_sectoral_or_internal?(operator_cge)).to be_falsey }
    it { expect(operator_sectoral_or_internal?(operator_sectoral)).to be_truthy }
    it { expect(operator_sectoral_or_internal?(operator_internal)).to be_truthy }

  end

  describe 'operator_subnet?' do
    let(:operator_cge) { build(:user, :operator_cge) }
    let(:operator_sectoral) { build(:user, :operator_sectoral) }
    let(:operator_subnet) { build(:user, :operator_subnet) }
    let(:operator_internal) { build(:user, :operator_internal) }
    let(:operator_subnet_chief) { build(:user, :operator_subnet_chief) }

    it { expect(operator_subnet?(operator_cge)).to be_falsey }
    it { expect(operator_subnet?(operator_sectoral)).to be_falsey }
    it { expect(operator_subnet?(operator_internal)).to be_falsey }
    it { expect(operator_subnet?(operator_subnet)).to be_truthy }
    it { expect(operator_subnet?(operator_subnet_chief)).to be_truthy }

  end

  describe 'operator_coordination?' do
    let(:operator_coordination) { build(:user, :operator_coordination) }
    let(:operator_sectoral) { build(:user, :operator_sectoral) }
    let(:operator_internal) { build(:user, :operator_internal) }

    it { expect(operator_coordination?(operator_coordination)).to be_truthy }
    it { expect(operator_coordination?(operator_sectoral)).to be_falsey }
    it { expect(operator_coordination?(operator_internal)).to be_falsey }
  end

  describe 'operator_coordination_or_cge?' do
    let(:operator_coordination) { build(:user, :operator_coordination) }
    let(:operator_cge) { build(:user, :operator_cge) }
    let(:operator_sectoral) { build(:user, :operator_sectoral) }
    let(:operator_internal) { build(:user, :operator_internal) }

    it { expect(operator_coordination_or_cge?(operator_coordination)).to be_truthy }
    it { expect(operator_coordination_or_cge?(operator_cge)).to be_truthy }
    it { expect(operator_coordination_or_cge?(operator_sectoral)).to be_falsey }
    it { expect(operator_coordination_or_cge?(operator_internal)).to be_falsey }
  end

  describe 'operator_sectoral?' do
    let(:operator_sectoral) { build(:user, :operator_sectoral) }
    let(:operator_internal) { build(:user, :operator_internal) }

    it { expect(operator_sectoral?(operator_sectoral)).to be_truthy }
    it { expect(operator_sectoral?(operator_internal)).to be_falsey }

  end

  describe 'operator_sectoral_sou?' do
    let(:operator_sectoral_sou) { build(:user, :operator_sectoral) }
    let(:operator_sectoral_sic) { build(:user, :operator_sectoral_sic) }

    it { expect(operator_sectoral_sou?(operator_sectoral_sou)).to be_truthy }
    it { expect(operator_sectoral_sou?(operator_sectoral_sic)).to be_falsey }

  end

  describe 'operator_internal?' do
    let(:operator_sectoral) { build(:user, :operator_sectoral) }
    let(:operator_internal) { build(:user, :operator_internal) }

    it { expect(operator_internal?(operator_sectoral)).to be_falsey }
    it { expect(operator_internal?(operator_internal)).to be_truthy }

  end

  describe 'operator_cge?' do
    let(:operator_cge) { build(:user, :operator_cge) }
    let(:operator_internal) { build(:user, :operator_internal) }

    it { expect(operator_cge?(operator_cge)).to be_truthy }
    it { expect(operator_cge?(operator_internal)).to be_falsey }

  end

  describe 'operator_cge_denunciation?' do
    let(:operator_cge_denunciation) { build(:user, :operator_cge_denunciation_tracking) }
    let(:operator_internal) { build(:user, :operator_internal) }

    it { expect(operator_denunciation?(operator_cge_denunciation)).to be_truthy }
    it { expect(operator_denunciation?(operator_internal)).to be_falsey }
  end

  describe 'operator_chief?' do
    let(:operator_chief) { build(:user, :operator_chief) }
    let(:operator_subnet_chief) { build(:user, :operator_subnet_chief) }
    let(:operator_internal) { build(:user, :operator_internal) }

    it { expect(operator_chief?(operator_chief)).to be_truthy }
    it { expect(operator_chief?(operator_subnet_chief)).to be_truthy }
    it { expect(operator_chief?(operator_internal)).to be_falsey }
  end

  describe 'operator call_center' do
    let(:two) { create(:user, :operator_call_center) }
    let(:one) { create(:ticket, :with_call_center_responsible, :replied).call_center_responsible }

    before  do
      create_list(:ticket, 2, :call_center, :replied, call_center_responsible: two)
      create(:ticket, :call_center, :replied, :feedback, call_center_responsible: two)
    end

    it 'call_center_responsible_for_select' do
      expected = [
        ["(1) #{one.name}", one.id],
        ["(2) #{two.name}", two.id]
      ]

      expect(call_center_responsible_for_select).to eq(expected)
    end

    it 'call_center_for_filter' do

      expected = [
        ["(1) #{one.name}", one.id],
        ["(2) #{two.name}", two.id]
      ]

      expected.unshift([I18n.t('messages.filters.select.none'), '__is_null__'])

      expect(call_center_for_filter).to eq(expected)
    end

  end

  context '#user_ticket_types_availables' do
    context 'operator_cge_denunciation_tracking' do
      it 'acts_as_sic = true' do
        user = build(:user, :operator_cge_denunciation_tracking, acts_as_sic: true)

        expect(user_ticket_types_availables(user)).to eq([:sou, :sic])
      end
    end

    context 'sou_sectoral' do
      it 'acts_as_sic = true' do
        user = build(:user, :operator_sectoral, acts_as_sic: true)

        expect(user_ticket_types_availables(user)).to eq([:sou, :sic])
      end

      it 'acts_as_sic = false' do
        user = build(:user, :operator_sectoral, acts_as_sic: false)

        expect(user_ticket_types_availables(user)).to eq([:sou])
      end
    end

    it 'sic_sectoral' do
      user = build(:user, :operator_sectoral_sic)

      expect(user_ticket_types_availables(user)).to eq([:sic])
    end

    it 'cosco' do
      organ_cosco = create(:executive_organ, acronym: 'COSCO')
      user = build(:user, :operator_sectoral, organ: organ_cosco)

      expect(user_ticket_types_availables(user)).to eq([:sou])
    end

    it 'operator_subnet' do
      user = build(:user, :operator_subnet)

      expect(user_ticket_types_availables(user)).to eq([:sou, :sic])
    end

    it 'sou_security_organ' do
      user = build(:user, :operator_security_organ_sou)

      expect(user_ticket_types_availables(user)).to eq([:sou])
    end
  end

  context '#users_name_by_id' do
    let(:user) { create(:user, :operator_cge) }

    it 'return name' do
      expect(users_name_by_id(user.id)).to eq(user.name)
    end

    it 'return blank when user dont exist' do
      expect(users_name_by_id(1222)).to eq("")
    end
	end

	describe '#user_enabled_to_view_topic' do
		context 'when user is unlogged' do
			it 'is enabled' do
				expect(user_enabled_to_view_topic(nil)).to be_truthy
			end
		end

		context 'when user is logged with a citizen' do
			it 'is enabled' do
				user = build(:user, :user)
				expect(user_enabled_to_view_topic(user)).to be_truthy
			end
		end

		context 'when user is logged different tahn citizen' do
			it 'is not enabled' do
				user = build(:user, :operator_cge)
				expect(user_enabled_to_view_topic(user)).to be_falsey
			end
		end
	end
end
