require 'rails_helper'

describe OrgansHelper do
  let(:organ) { build(:executive_organ) }
  let!(:other_organ) { create(:executive_organ) }
  let!(:cosco_organ) { create(:executive_organ, acronym: 'COSCO') }
  let!(:couvi_organ) { create(:executive_organ, acronym: 'COUVI') }
  let(:ticket) { create(:ticket, :with_parent, organ: other_organ, department: create(:department, organ: other_organ)) }


  describe '#organs_for_select' do
    context 'when user is not operator cge or coordination' do
      it 'return organs list without cosco and couvi' do
        create(:executive_organ)

        organs = Organ.sorted.where.not(id: [cosco_organ, couvi_organ])
        expected = organs.map do |organ|
          ["#{organ.acronym} - #{organ.name}", organ.id]
        end

        allow(self).to receive(:share_to_couvi?).and_return(false)
        allow(self).to receive(:share_to_cosco?).and_return(false)
        expect(organs_for_select).to eq(expected)
      end
    end
  end

  it 'organs_for_select for cge' do
    denunciation_tracking_user = create(:user, :admin)
    create(:executive_organ)

    organs = Organ.sorted
    expected = organs.map do |organ|
      ["#{organ.acronym} - #{organ.name}", organ.id]
    end

    allow(self).to receive(:share_to_couvi?).and_return(true)
    allow(self).to receive(:share_to_cosco?).and_return(true)
    expect(organs_for_select).to eq(expected)
  end

  it 'organs_for_select_with_all_option' do
    create(:executive_organ)

    organs = Organ.sorted.where.not(id: [cosco_organ, couvi_organ])
    expected = organs.map do |organ|
      ["#{organ.acronym} - #{organ.name}", organ.id]
    end

    expected.insert(0, ['Todos os órgãos', ' '])

    allow(self).to receive(:share_to_couvi?).and_return(false)
    allow(self).to receive(:share_to_cosco?).and_return(false)
    expect(organs_for_select_with_all_option).to eq(expected)
  end

  describe '#organs_to_share_for_select_with_subnet_info' do
    context 'when ticket is blank' do
      it 'return empty data' do
        expect(organs_to_share_for_select_with_subnet_info(nil)).to eq([])
      end
    end

    context 'when ticket share deadline expired' do
      context 'when ticket has a organ with subnet' do
        it 'return the ticket organ with subnet info' do
          ticket = create(
            :ticket, :with_parent, :in_sectoral_attendance, :with_subnet,
            confirmed_at: 1.month.ago
          )

          expect(organs_to_share_for_select_with_subnet_info(ticket)).to eq(
            [[organ_title(ticket.organ), ticket.organ_id, { "data-subnet": true }]]
          )
        end
      end

      context 'when ticket has a organ without subnet' do
        it 'return the list of organs with subnet info when exist' do
          ticket = create(
            :ticket, :with_parent, :in_sectoral_attendance, confirmed_at: 1.month.ago
          )

          allow(self).to receive(:share_to_couvi?).and_return(false)
          allow(self).to receive(:share_to_cosco?).and_return(false)
          expect(organs_to_share_for_select_with_subnet_info(ticket)).to eq(
            organs_for_select_with_subnet_info
          )
        end
      end
    end

    context 'when ticket share deadline on time' do
      context 'when ticket has a organ with subnet' do
        it 'return the list of organs with subnet info when exist' do
          ticket = create(:ticket, :with_parent, :in_sectoral_attendance)

          allow(self).to receive(:share_to_couvi?).and_return(false)
          allow(self).to receive(:share_to_cosco?).and_return(false)
          expect(organs_to_share_for_select_with_subnet_info(ticket)).to eq(
            organs_for_select_with_subnet_info
          )
        end
      end

      context 'when ticket has a organ without subnet' do
        it 'return the list of organs with subnet info when exist' do
          ticket = create(:ticket, :with_parent, :in_sectoral_attendance)

          allow(self).to receive(:share_to_couvi?).and_return(false)
          allow(self).to receive(:share_to_cosco?).and_return(false)
          expect(organs_to_share_for_select_with_subnet_info(ticket)).to eq(
            organs_for_select_with_subnet_info
          )
        end
      end
    end
  end

  it 'organs_for_select_with_subnet_info' do
    create(:executive_organ, subnet: true)

    organs = Organ.sorted.where.not(id: [cosco_organ, couvi_organ])
    expected = organs.map do |organ|
      ["#{organ.acronym} - #{organ.name}", organ.id, 'data-subnet': organ.subnet, 'data-topic': true]
    end

    allow(self).to receive(:share_to_couvi?).and_return(false)
    allow(self).to receive(:share_to_cosco?).and_return(false)
    expect(organs_for_select_with_subnet_info).to eq(expected)
  end

  describe 'acronym_organs_list' do

    context 'parent ticket' do
      it 'blank' do
        parent_ticket = create(:ticket)
        expect(acronym_organs_list(parent_ticket)).to eq('')
      end

      it 'one' do
        organ = create(:executive_organ)
        parent_ticket = create(:ticket)
        child_ticket = create(:ticket, :with_organ, organ: organ, parent: parent_ticket)
        expect(acronym_organs_list(parent_ticket)).to eq(organ.acronym)
      end

      it 'more than one' do
        organ = create(:executive_organ)
        another_organ = create(:executive_organ)
        parent_ticket = create(:ticket)
        child_ticket = create(:ticket, unknown_organ: false, organ: organ, parent: parent_ticket)
        another_child_ticket = create(:ticket, :with_organ, organ: another_organ, parent: parent_ticket)
        expect(acronym_organs_list(parent_ticket)).to eq("#{child_ticket.organ.acronym}; #{another_child_ticket.organ.acronym}")
      end
    end

    context 'child_ticket' do
      it 'one' do
        ticket = create(:ticket, :with_parent)
        expect(acronym_organs_list(ticket)).to eq(ticket.organ.acronym)
      end
    end
  end

  it 'organs from parent' do
    ticket_organ1 = create(:ticket, :with_parent, :with_classification)
    ticket_parent = ticket_organ1.parent
    ticket_organ2 = create(:ticket, :with_organ)
    ticket_parent.tickets << ticket_organ2
    ticket_parent.save

    expected = [
      ["#{ticket_organ1.organ_acronym} - #{ticket_organ1.organ_name}", ticket_organ1.organ.id, 'data-url': operator_ticket_classification_path(ticket_organ1, ticket_organ1.classification)],
      ["#{ticket_organ2.organ_acronym} - #{ticket_organ2.organ_name}", ticket_organ2.organ.id, 'data-url': new_operator_ticket_classification_path(ticket_organ2)]
    ]

    expect(organs_from_parent_classification(ticket_parent)).to match_array(expected)
  end
end
