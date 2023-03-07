require 'rails_helper'

module PPA
  RSpec.describe WorkshopsHelper, type: :helper do

    describe '#workshop_title' do
      let(:workshop) { build :ppa_workshop, name: 'first workshop', start_at: '2018-10-05 09:50' }
      let(:title)    { helper.workshop_title(workshop) }

      it 'joins title and start_at' do
        expect(title).to eq 'FIRST WORKSHOP - 05/10/2018'
      end

      it 'capitalize name' do
        expect(title.chars.first).to eq 'F'
      end
    end

    describe '#workshop_duration' do
      let(:workshop) { build :ppa_workshop, workshop_attributes }
      let(:duration) { helper.workshop_duration(workshop) }
      
      contexts = [
        { 
          description: 'unify the output', 
          end_at: '2018-01-01 13:30', 
          expected_duration: '01/01/2018 das 10:00 às 13:30' 
        },
        { description: 'when starts and ends at different days',
          end_at: '2018-01-02 13:30',
          expected_duration: '01/01/2018 até 02/01/2018'
        }
      ]

      shared_examples 'check the correct duration' do |context|
        let(:workshop_attributes) { { start_at: '2018-01-01 10:00' }.merge({ end_at: context[:end_at] }) }
        
        context context[:description] do
          it { expect(duration).to eq context[:expected_duration] }
        end

      end

      contexts.each do |context|
        it_behaves_like 'check the correct duration', context
      end
      
    end

    describe '#remaining_time_for_next_workshop' do
      let(:response) { helper.remaining_time_for_next_workshop(workshop.plan_id) }
      

      context 'without next workshops scheduled' do
        let(:workshop) { create(:ppa_workshop, :past) }

        it 'no workshops scheduled for the next few days' do
          expect(response).to eq nil
        end
      end

      context 'with next scheduled workshop' do
        # A factory da workshop cria uma com início para o próximo dia
        let(:workshop) { create(:ppa_workshop) } 

        let(:workshop_today) { create(:ppa_workshop, start_at: Time.current) }


        it 'workshop scheduled for tomorrow' do
          expect(response).to eq '1 dia'
        end

        let(:response_today) { helper.remaining_time_for_next_workshop(workshop_today.plan_id) }

        it 'workshop scheduled for today' do
          expect(response_today).to eq 'Hoje é dia de encontro regional'
        end

      end
    end

  end
end
