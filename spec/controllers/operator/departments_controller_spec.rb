require 'rails_helper'

describe Operator::DepartmentsController do

  let(:user) { create(:user, :operator_sectoral) }
  let(:department) { create(:department, organ: user.organ) }

  let(:permitted_params) do
    [
      :name,
      :acronym,
      :organ_id,
      :subnet_id,
      sub_departments_attributes: [
        :id,
        :name,
        :acronym,
        :_disable
      ]
    ]
  end

  describe '#index' do
    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:index) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
      end

      describe 'helper methods' do
        describe 'for  sectoral operator' do
          it 'departments' do
            another_organ_department = create(:department)

            expect(another_organ_department.organ).not_to eq(user.organ)

            expect(controller.departments).to eq([department])
          end
          describe 'for subnet operator' do
            let(:user) { create(:user, :operator_subnet) }
            let(:subnet_department) { create(:department, :with_subnet, subnet: user.subnet) }
            it 'departments' do
              department
              create(:department)

              expect(controller.departments).to eq([subnet_department])
            end
          end
        end
      end
    end
  end

  describe '#new' do
    context 'unauthorized' do
      before { get(:new) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:new) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template('operator/departments/new') }
        it { is_expected.to render_template('operator/departments/_form') }
      end

      describe 'helper methods' do
        it 'department' do
          expect(controller.department).to be_new_record
        end
      end
    end
  end

  describe '#create' do
    let(:organ) { create(:executive_organ) }
    let(:valid_department) do
      attributes_for(:department, organ_id: organ.id)
    end
    let(:invalid_department) { attributes_for(:department, :invalid) }

    let(:created_department) { Department.last }

    context 'unauthorized' do
      before { post(:create, params: { department: valid_department }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      context 'operator' do

        before { sign_in(user) }

        it 'permits department params' do
          should permit(*permitted_params).
            for(:create, params: { department: valid_department  }).on(:department)
        end

        context 'valid' do
          it 'saves'  do
            expect do
              post(:create, params: { department: valid_department })

              created_department = controller.department

              expected_flash = I18n.t('operator.departments.create.done',
                title: created_department.title)

              expect(response).to redirect_to(operator_department_path(created_department))
              expect(controller).to set_flash.to(expected_flash)
            end.to change(Department, :count).by(1)
          end
        end

        context 'invalid' do
          render_views

          it 'does not save' do
            expect do
              post(:create, params: { department: invalid_department })

              expected_flash = I18n.t('operator.departments.create.error')

              expect(controller).to set_flash.now.to(expected_flash)
              expect(response).to render_template('operator/departments/new')
            end.to change(Department, :count).by(0)
          end
        end

        describe 'helper methods' do
          it 'department' do
            expect(controller.department).to be_new_record
          end
        end
      end
    end
  end

  describe '#show' do
    context 'unauthorized' do
      before { get(:show, params: { id: department }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:show, params: { id: department }) }

      describe 'helper methods' do
        it 'department' do
          expect(controller.department).to eq(department)
        end

        it 'sub_departments' do
          create_list(:sub_department, 2, department: department)
          expect(controller.sub_departments).to eq(department.sub_departments.sorted)
        end
      end
    end
  end

  describe '#edit' do
    context 'unauthorized' do
      before { get(:edit, params: { id: department }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:edit, params: { id: department }) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template('operator/departments/edit') }
        it { is_expected.to render_template('operator/departments/_form') }
      end

      describe 'helper methods' do
        it 'department' do
          expect(controller.department).to eq(department)
        end
      end
    end
  end

  describe '#update' do
    let(:valid_department) { department }
    let(:invalid_department) do
      department = create(:department)
      department.name = nil
      department
    end

    let(:valid_department_attributes) { valid_department.attributes }
    let(:valid_department_params) { { id: department, department: valid_department_attributes } }
    let(:invalid_department_params) do
      { id: invalid_department, department: invalid_department.attributes }
    end

    context 'unauthorized' do
      before { patch(:update, params: valid_department_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'permits department params' do
        should permit(*permitted_params).
          for(:update, params: valid_department_params ).on(:department)
      end

      context 'valid' do
        it 'saves' do
          valid_department_params[:department][:name] = 'new name'
          patch(:update, params: valid_department_params)

          expect(response).to redirect_to(operator_department_path(department))

          valid_department.reload

          expected_flash = I18n.t('operator.departments.update.done',
            title: valid_department.title)

          expect(valid_department.name).to eq('new name'.upcase)
          expect(controller).to set_flash.to(expected_flash)
        end
      end

      context 'invalid' do
        render_views

        it 'does not save' do
          patch(:update, params: invalid_department_params)
          expect(response).to render_template('operator/departments/edit')
        end
      end

      describe 'helper methods' do
        it 'department' do
          patch(:update, params: valid_department_params)
          expect(controller.department).to eq(valid_department)
        end
      end

      context 'change field to nil' do

        before { sign_in(user) }

        let(:organ) { user.organ }
        let(:subnet) { create(:subnet) }

        it 'subnet when update for organ' do
          user = create(:user, :operator_subnet)
          valid_department = create(:department, :with_subnet, subnet: user.subnet)
          valid_department_params = valid_department.attributes
          valid_department_params.delete("subnet_id")
          valid_department_params["organ_id"] = organ.id

          patch(:update, params: { id: valid_department.id, department: valid_department_params} )

          valid_department.reload

          expect(valid_department.organ).not_to eq(nil)
          expect(valid_department.subnet).to eq(nil)
        end

        it 'subnet when update for organ' do
          valid_department = create(:department, organ: user.organ)
          valid_department_params = valid_department.attributes
          valid_department_params.delete("organ_id")
          valid_department_params["subnet_id"] = subnet.id

          patch(:update, params: { id: valid_department.id, department: valid_department_params , from_subnet: "1" })

          valid_department.reload

          expect(valid_department.organ).to eq(nil)
          expect(valid_department.subnet).not_to eq(nil)
        end
      end
    end
  end

  describe '#destroy' do
    context 'unauthorized' do
      before { delete(:destroy, params: { id: department }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'destroys' do
        department

        expect do
          delete(:destroy, params: { id: department })

          expected_flash = I18n.t('operator.departments.destroy.done',
            title: department.title)

          expect(response).to redirect_to(operator_departments_path)
          expect(controller).to set_flash.to(expected_flash)
        end.to change(Department, :count).by(-1)
      end

      describe 'helper methods' do
        it 'department' do
          delete(:destroy, params: { id: department })
          expect(controller.department).to eq(department)
        end
      end
    end
  end
end
