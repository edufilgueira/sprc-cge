require 'rails_helper'

describe Admin::MobileAppsController do

  let(:admin) { create(:user, :admin) }

  let(:mobile_app) { create(:mobile_app) }

  let(:permitted_params) do
    [
      :name,
      :description,
      :icon,
      :official,
      :link_apple_store,
      :link_google_play,
      mobile_tag_ids: []
    ]
  end

  describe '#index' do
    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(admin) && get(:index) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:index) }
      end

     it_behaves_like 'controllers/base/index/paginated'

      context 'helper methods' do
        it 'transparency_apps' do
          mobile_app_1 = create(:mobile_app, name: 'A')
          mobile_app_2 = create(:mobile_app, name: 'Z')

          expect(controller.mobile_apps).to eq([mobile_app_1, mobile_app_2])
        end
      end
    end

    context 'search' do
      it 'name case insensitive' do
        filtered = create(:mobile_app, name: 'filtered')
        mobile_app

        get(:index, params: { search: 'filTer' })

        expect(controller.mobile_apps).to eq([filtered])
      end
    end
  end

  describe '#new' do
    context 'unauthorized' do
      before { get(:new) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(admin) && get(:new) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:new) }
        it { is_expected.to render_template('admin/mobile_apps/_form') }
      end

      describe 'helper methods' do
        it 'mobile_app' do
          expect(controller.mobile_app).to be_new_record
        end
      end
    end
  end

  describe '#create' do

    let(:tempfile) do
      file = Tempfile.new("test.png", Rails.root + "spec/fixtures")
      file.write('1')
      file.close
      file.open
      file
    end

    let(:icon) { Rack::Test::UploadedFile.new(tempfile, "image/png") }

    let(:invalid_params) do
      {
        mobile_app: attributes_for(:mobile_app, :invalid, icon: icon)
      }
    end

    let(:mobile_tags) { create_list(:mobile_tag, 1) }

    let(:valid_params) do
      params = {}
      params[:mobile_app] = attributes_for(:mobile_app, icon: icon)
      params[:mobile_app][:mobile_tag_ids] = mobile_tags.pluck(:id)
      params
    end


    let(:created_mobile_app) { MobileApp.last }

    context 'unauthorized' do
      before { post(:create, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      context 'admin user' do

        before { sign_in(admin) }

        it 'permits user params' do
          # XXX: params: params: pois o shoulda_matchers está usando partes
          # deprecated!
          should permit(*permitted_params).
            for(:create, params: valid_params ).on(:mobile_app)
        end

        context 'valid' do
          it 'saves' do
            expect do
              post(:create, params: valid_params)

              expected_flash = I18n.t('admin.mobile_apps.create.done', title: created_mobile_app.title)

              expect(response).to redirect_to(admin_mobile_app_path(created_mobile_app))
              expect(controller).to set_flash.to(expected_flash)
            end.to change(MobileApp, :count).by(1)
          end
        end

        context 'invalid' do
          render_views

          it 'does not save' do
            expect do
              post(:create, params: invalid_params)

              expected_flash = I18n.t('admin.mobile_apps.create.error')

              expect(controller).to set_flash.now.to(expected_flash)
              expect(response).to render_template(:new)
            end.to change(MobileApp, :count).by(0)
          end
        end
      end
    end
  end

  describe '#show' do
    context 'unauthorized' do
      before { get(:show, params: { id: mobile_app }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(admin) && get(:show, params: { id: mobile_app }) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:show) }
      end

      describe 'helper methods' do
        it 'mobile_app' do
          expect(controller.mobile_app).to eq(mobile_app)
        end
      end
    end
  end

  describe '#edit' do

    let(:valid_params) do
      {
        id: mobile_app
      }
    end

    context 'unauthorized' do
      before { get(:edit, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(admin) && get(:edit, params: valid_params) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:edit) }
        it { is_expected.to render_template('admin/mobile_apps/_form') }
      end

      describe 'helper methods' do
        it 'mobile_app' do
          expect(controller.mobile_app).to eq(mobile_app)
        end
      end
    end
  end

  describe '#update' do
    let(:valid_mobile_app) { create(:mobile_app) }
    let(:invalid_mobile_app) do
      invalid = valid_mobile_app
      invalid.name = nil
      invalid
    end

    let(:invalid_params) do
      {
        id: invalid_mobile_app.id,
        mobile_app: invalid_mobile_app.attributes
      }
    end

    let(:valid_params) do
      {
        id: valid_mobile_app.id,
        mobile_app: valid_mobile_app.attributes
      }
    end

    context 'unauthorized' do
      before { patch(:update, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(admin) }

      it 'permits user params' do
        should permit(*permitted_params).
          for(:update, params: valid_params ).on(:mobile_app)
      end

      context 'valid' do
        it 'saves' do
          valid_params[:mobile_app]['name'] = 'new name'

          patch(:update, params: valid_params)

          expect(response).to redirect_to(admin_mobile_app_path(valid_mobile_app))

          valid_mobile_app.reload

          expected_flash = I18n.t('admin.mobile_apps.update.done', title: valid_mobile_app.title)

          expect(valid_mobile_app.name).to eq('new name')
          expect(controller).to set_flash.to(expected_flash)
        end
      end

      context 'invalid' do
        render_views

        it 'does not save' do
          patch(:update, params: invalid_params)
          expect(response).to render_template('admin/mobile_apps/edit')
        end
      end

      describe 'helper methods' do
        it 'mobile_app' do
          patch(:update, params: valid_params)
          expect(controller.mobile_app).to eq(valid_mobile_app)
        end
      end
    end
  end

  describe '#destroy' do
    let(:valid_params) do
      {
        id: mobile_app
      }
    end

    context 'unauthorized' do
      before { delete(:destroy, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(admin) }

      it 'destroys' do
        mobile_app

        expect do
          delete(:destroy, params: valid_params)

          expected_flash = I18n.t('admin.mobile_apps.destroy.done',
            title: mobile_app.title)

          expect(response).to redirect_to(admin_mobile_apps_path)
          expect(controller).to set_flash.to(expected_flash)
        end.to change(MobileApp, :count).by(-1)
      end

      it 'does not destroys' do
        allow_any_instance_of(MobileApp).to receive(:destroy).and_return(false)
        delete(:destroy, params: valid_params)

        expected_flash = I18n.t('admin.mobile_apps.destroy.error',
          title: mobile_app.title)

        expect(response).to redirect_to(admin_mobile_apps_path)
        expect(controller).to set_flash.to(expected_flash)
      end

      describe 'helper methods' do
        it 'mobile_app' do
          delete(:destroy, params: valid_params)
          expect(controller.mobile_app).to eq(mobile_app)
        end
      end
    end
  end
end
