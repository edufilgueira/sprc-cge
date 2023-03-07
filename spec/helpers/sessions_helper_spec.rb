require 'rails_helper'

# Testa os endereços de login para páginas com e sem Ceará APP

describe SessionsHelper do
  describe 'URL for Sessions' do

    context 'Ceara APP' do
      before do
        set_ceara_app
      end

      it 'SIC' do
        url = '/ceara_app/sign_in'
        expect(url_for_session).to eq(url)
      end
    end

    context 'CT Web' do
      before do
        set_ceara_app(false)
      end

      it 'SIC' do
        url = '/sign_in'
        expect(url_for_session).to eq(url)
      end

    end
  end
end

def set_ceara_app(value=true)
  SessionsHelper.class_eval do
    define_method :is_ceara_app? do
      value
    end
  end
end