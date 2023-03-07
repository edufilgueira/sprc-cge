require 'rails_helper'

describe Transparency::EventsController do

  let(:event) { create(:event) }

  let(:resources) { [event] + create_list(:event, 1) }

  describe '#index' do

    context 'template' do
      render_views

      before { get(:index) }

      it 'responds with success and renders templates' do
        expect(response).to be_success
        expect(response).to render_template('transparency/events/index')
      end

      describe 'xhr' do
        it 'does not render layout and renders only _index partial' do
          get(:index, xhr: true)

          expect(response).not_to render_template('application')
          expect(response).not_to render_template('index')
          expect(response).to render_template(partial: '_index')
        end
      end
    end

    describe 'sort' do
      let(:first_unsorted) do
        create(:event, starts_at: 3.days.ago)
      end
      let(:last_unsorted) do
        create(:event, starts_at: Time.current)
      end

      it 'default' do
        first_unsorted
        last_unsorted

        get(:index)

        expect(controller.events).to eq([first_unsorted, last_unsorted])
      end
    end

    describe 'helper methods' do
      before { get(:index) }
      it 'events' do
        expect(controller.events).to eq([event])
      end
    end

    describe 'pagination' do
      it 'calls kaminari methods' do
        allow(Event).to receive(:page).and_call_original
        expect(Event).to receive(:page).and_call_original

        get(:index)

        # para poder chamar o page que estamos testando
        controller.events
      end

      it 'per_page' do
        create_list(:event, 20)

        get(:index)

        expect(controller.events.count).to eq(9)
      end
    end
  end

  describe '#show' do
    it_behaves_like 'controllers/transparency/base/show'
  end
end
