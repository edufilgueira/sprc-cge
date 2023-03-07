require 'rails_helper'

describe Admin::MobileTagsController do

  let(:admin) { create(:user, :admin) }

  let(:mobile_tag) { create(:mobile_tag) }

  let(:permitted_params) { [:name] }

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

      context 'helper methods' do

        it 'transparency_tags' do
          mobile_tag_1 = create(:mobile_tag)
          mobile_tag_2 = create(:mobile_tag)

          expect(controller.mobile_tags).to eq([mobile_tag_1, mobile_tag_2])
        end
      end
    end

    context 'pagination' do
      it 'calls kaminari methods' do
        allow(MobileTag).to receive(:page).and_call_original
        expect(MobileTag).to receive(:page).and_call_original

        get(:index)

        # para poder chamar o page que estamos testando
        controller.mobile_tags
      end
    end

    context 'search' do
      it 'name case insensitive' do
        filtered = create(:mobile_tag, name: 'filtered')
        mobile_tag

        get(:index, params: { search: 'filTer' })

        expect(controller.mobile_tags).to eq([filtered])
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
        it { is_expected.to render_template('admin/mobile_tags/_form') }
      end

      describe 'helper methods' do
        it 'tag' do
          expect(controller.mobile_tag).to be_new_record
        end
      end
    end
  end

  describe '#create' do

    let(:invalid_params) do
      {
        mobile_tag: attributes_for(:mobile_tag, :invalid)
      }
    end

    let(:valid_params) do
      {
        mobile_tag: attributes_for(:mobile_tag)
      }
    end


    let(:created_mobile_tag) { MobileTag.last }

    context 'unauthorized' do
      before { post(:create, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      context 'admin user' do

        before { sign_in(admin) }

        it 'permits user params' do
          should permit(*permitted_params).
            for(:create, params: valid_params ).on(:mobile_tag)
        end

        context 'valid' do
          it 'saves' do
            expect do
              post(:create, params: valid_params)

              expected_flash = I18n.t('admin.mobile_tags.create.done', title: created_mobile_tag.title)

              expect(response).to redirect_to(admin_mobile_tags_path)
              expect(controller).to set_flash.to(expected_flash)
            end.to change(MobileTag, :count).by(1)
          end
        end

        context 'invalid' do
          render_views

          it 'does not save' do
            expect do
              post(:create, params: invalid_params)

              expected_flash = I18n.t('admin.mobile_tags.create.error')

              expect(controller).to set_flash.now.to(expected_flash)
              expect(response).to render_template(:new)
            end.to change(MobileTag, :count).by(0)
          end
        end
      end
    end
  end

  describe '#edit' do

    let(:valid_params) do
      {
        id: mobile_tag
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
        it { is_expected.to render_template('admin/mobile_tags/_form') }
      end

      describe 'helper methods' do
        it 'mobile_tag' do
          expect(controller.mobile_tag).to eq(mobile_tag)
        end
      end
    end
  end

  describe '#update' do
    let(:valid_mobile_tag) { create(:mobile_tag) }
    let(:invalid_mobile_tag) do
      invalid = valid_mobile_tag
      invalid.name = nil
      invalid
    end

    let(:invalid_params) do
      {
        id: invalid_mobile_tag.id,
        mobile_tag: invalid_mobile_tag.attributes
      }
    end

    let(:valid_params) do
      {
        id: valid_mobile_tag.id,
        mobile_tag: valid_mobile_tag.attributes
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
          for(:update, params: valid_params ).on(:mobile_tag)
      end

      context 'valid' do
        it 'saves' do
          valid_params[:mobile_tag]['name'] = 'new name'

          patch(:update, params: valid_params)

          expect(response).to redirect_to(admin_mobile_tags_path)

          valid_mobile_tag.reload

          expected_flash = I18n.t('admin.mobile_tags.update.done', title: valid_mobile_tag.title)

          expect(valid_mobile_tag.name).to eq('new name')
          expect(controller).to set_flash.to(expected_flash)
        end
      end

      context 'invalid' do
        render_views

        it 'does not save' do
          patch(:update, params: invalid_params)
          expect(response).to render_template('admin/mobile_tags/edit')
        end
      end

      describe 'helper methods' do
        it 'mobile_tag' do
          patch(:update, params: valid_params)
          expect(controller.mobile_tag).to eq(valid_mobile_tag)
        end
      end
    end
  end

  describe '#destroy' do
    let(:valid_params) do
      {
        id: mobile_tag
      }
    end

    context 'unauthorized' do
      before { delete(:destroy, params: valid_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(admin) }

      it 'destroys' do
        mobile_tag

        expect do
          delete(:destroy, params: valid_params)

          expected_flash = I18n.t('admin.mobile_tags.destroy.done',
            title: mobile_tag.title)

          expect(response).to redirect_to(admin_mobile_tags_path)
          expect(controller).to set_flash.to(expected_flash)
        end.to change(MobileTag, :count).by(-1)
      end

      it 'does not destroys' do
        allow_any_instance_of(MobileTag).to receive(:destroy).and_return(false)
        delete(:destroy, params: valid_params)

        expected_flash = I18n.t('admin.mobile_tags.destroy.error',
          title: mobile_tag.title)

        expect(response).to redirect_to(admin_mobile_tags_path)
        expect(controller).to set_flash.to(expected_flash)
      end

      describe 'helper methods' do
        it 'mobile_tag' do
          delete(:destroy, params: valid_params)
          expect(controller.mobile_tag).to eq(mobile_tag)
        end
      end
    end
  end

end
