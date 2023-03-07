require 'rails_helper'

describe Platform::HomeController do

  let(:user) { create(:user) }

  describe '#index' do

    it 'unauthorized' do
      get(:index)

      is_expected.to redirect_to(new_user_session_path)
    end

    it 'authorized' do
      sign_in(user) && get(:index)

      is_expected.to respond_with(:success)
      is_expected.to render_template('home/index')
    end

    it 'status_count' do
      create(:ticket, internal_status: :cge_validation, created_by: user)
      create(:ticket, internal_status: :internal_attendance, created_by: user)
      create(:ticket, internal_status: :final_answer, created_by: user)
      create(:ticket, :sic, internal_status: :internal_attendance, created_by: user)

      # não deve ser contabilizado
      create(:ticket, :with_parent, internal_status: :internal_attendance, created_by: user)

      sign_in(user) && get(:index)

      expect(controller.status_count(:sou)[:active]).to eq(2)
      expect(controller.status_count(:sou)[:inactive]).to eq(1)
      expect(controller.status_count(:sic)[:active]).to eq(1)
      expect(controller.status_count(:sic)[:inactive]).to eq(0)
    end
  end
end
