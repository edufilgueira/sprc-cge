require 'rails_helper'

describe Transparency::Sou::HomeController do

  let!(:page) { create(:page) }

  describe '#index' do

    context 'authorized' do
      before { get(:index) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
      end
    end

    describe 'helper methods' do
      describe 'upcoming_events' do
        let(:events) { spy :events, first: '' }
        before do
          allow(Event).to receive(:upcoming) { events }
          allow(events).to receive(:first).with(3)

          controller.upcoming_events
        end

        it { expect(Event).to have_received(:upcoming) }
        it { expect(events).to have_received(:first).with(3) }
      end
    end
  end


end
