require 'rails_helper'

RSpec.describe PPAController, type: :controller do

  describe '#current_plan' do
    before do
      allow(PPA::Plan).to receive(:current)
      controller.send :current_plan
    end

    it 'call PPA::Plan.current' do
      expect(PPA::Plan).to have_received(:current)
    end
  end

end
