# Controllers

## O que é?

Action Controller é o C em MVC. Depois que as rotas determinam qual `controller` usar para uma solicitação, o `controller` é responsável por entender o `request` e produzir a saída apropriada.

A convenção de nomenclatura do controller é usar o plural para a ultima palavra do nome, por exemplo `UsersController`, `SiteAdminsController`.
Seguindo a convenção do nome, pode usar os geradores de rotas padrão do Rails para as 7 actions: `:index`, `:new`, `:create`, `:show`, `:edit`, `:update`, `:destroy`.

## Estrutura

```ruby
class ResourceController < ApplicationController
  # include de concerns
  # Ex: include BaseController

  # constants
  # Ex: ACCESSIBLE_PARAMS = [ ]

  # filters
  # Ex: before_action :authenticate_user!

  helper_method [:resources, :resource]

  # actions

  # helper methods

  # private methods
  private

end

```

## Actions

### Index

Método HTTP: `GET`

Url: `/resources`

Responsável por listar todos os recursos contidos em `resources`. Renderiza a view `resources/index.html.haml`

Index padrão:

```ruby
  helper_method :resources

  def index
  end

  def resources
    @resources ||= Resource.all
  end

```

Teste para action index:

```ruby
  let(:user) { create(:user) }
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
        it 'resources' do
          expect(controller.resources).to eq(Resource.all)
        end
      end
    end
  end
```

### New

Método HTTP: `GET`

Url: `/resources/new`

Responsável por retornar um formulário html para criar um novo `resource`.

New padrão:

```ruby
  PERMITTED_PARAMS = []

  helper_method :resource

  def new
  end

  def resource
    @resource ||= Resource.find(params[:id]) if find_action?
    @resource ||= Resource.new(resource_params)
  end

  private

  def find_action?
    ['show', 'edit', 'update', 'destroy'].include?(action_name)
  end

  def resource_params
    if params[:resource]
      params.require(:resource).permit(PERMITTED_PARAMS)
    end
  end
```

Teste para action new:

```ruby
  let(:user) { create(:user) }

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
        it { is_expected.to render_template('resources/new') }
        it { is_expected.to render_template('resources/_form') }
      end

      describe 'helper methods' do
        it 'resource' do
          expect(controller.resource).to be_new_record
        end
      end
    end
  end
```

### Create

Método HTTP: `POST`

Url: `/resources`

Responsável por salvar um novo `resource`. Irá redirecionar para a action `show` ao salvar com sucesso, caso contrário, irá renderizar o formulário com os erros encontrados.

Create padrão:

```ruby
  helper_method :resource

  def create
    if resource.save
      redirect_to_show_with_success
    else
      render :new
    end
  end
```

Teste para action create:

```ruby
  describe '#create' do
    let(:user) { create(:user) }

    let(:valid_resource) { attributes_for(:resource) }
    let(:invalid_resource) { attributes_for(:resource, :invalid) }

    let(:created_resource) { Resource.last }

    context 'unauthorized' do
      before { post(:create, params: { resource: valid_resource }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      context 'user' do

        before { sign_in(user) }

        it 'permits resource params' do
          is_expected.to permit(*permitted_params).
            for(:create, params: { params: { resource: valid_resource } }).on(:resource)
        end

        context 'valid' do
          it 'saves' do
            resource = attributes_for(:resource)
            expect do
              post(:create, params: { resource: resource })

              expected_flash = I18n.t('resources.create.done',
                title: valid_resource[:name])

              expect(response).to redirect_to(resource_path(created_resource))
              expect(controller).to set_flash.to(expected_flash)
            end.to change(Resource, :count).by(1)
          end
        end

        context 'invalid' do
          render_views

          it 'does not save' do
            expect do
              post(:create, params: { resource: invalid_resource })

              expect(response).to render_template('resources/new')
            end.to change(Resource, :count).by(0)
          end
        end

        describe 'helper methods' do
          it 'resource' do
            expect(controller.resource).to be_new_record
          end
        end
      end
    end
  end

```

### Show

Método HTTP: `GET`

Url: `/resources/:id`

Responsável por mostrar um `resource` específico, encontrado pelo `:id` na url.

Show padrão:

```ruby
  helper_method :resource

  def show
  end

  def resource
    @resource ||= Resource.find(params[:id]) if find_action?
    @resource ||= Resource.new(resource_params)
  end

  private

  def find_action?
    ['show', 'edit', 'update', 'destroy'].include?(action_name)
  end
```

Teste para action show:

```ruby
  let(:user) { create(:user) }
  let(:resource) { create(:resource) }

  describe '#show' do

    context 'unauthorized' do
      before { get(:show, params: { id: resource }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:show, params: { id: resource }) }

      describe 'helper methods' do
        it 'resource' do
          expect(controller.resource).to eq(resource)
        end
      end
    end
  end
```

### Edit

Método HTTP: `GET`

Url: `/resources/:id/edit`

Responsável por retornar um formulário html preenchido com `resource` para edição.

Edit padrão:

```ruby
  PERMITTED_PARAMS = []

  helper_method :resource

  def edit
  end

  def resource
    @resource ||= Resource.find(params[:id]) if find_action?
    @resource ||= Resource.new(resource_params)
  end

  private

  def find_action?
    ['show', 'edit', 'update', 'destroy'].include?(action_name)
  end

  def resource_params
    if params[:resource]
      params.require(:resource).permit(PERMITTED_PARAMS)
    end
  end
```

Teste para action edit:
```ruby
  let(:user) { create(:user) }
  let(:resource) { create(:resource) }

  describe '#edit' do
    context 'unauthorized' do
      before { get(:edit, params: { id: resource }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:edit, params: { id: resource }) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template('resources/edit') }
        it { is_expected.to render_template('resources/_form') }
      end

      describe 'helper methods' do
        it 'javascript' do
          expected = 'views/resources/edit'

          expect(controller.javascript).to eq(expected)
        end

        it 'resource' do
          expect(controller.resource).to eq(resource)
        end
      end
    end
  end
```

### Update

Método HTTP: `PUT`

Url: `/resources/:id`

Responsável por atualizar um `resource`. Irá redirecionar para a action `show` ao salvar com sucesso, caso contrário, irá renderizar o formulário com os erros encontrados.

Update padrão:

```ruby
  def update
    if resource.update_attributes(resource_params)
      redirect_to_show_with_success
    else
      render :edit
    end
  end
```

Teste para action update:

```ruby
  let(:user) { create(:user) }

  describe '#update' do
    let(:valid_resource) { create(:resource) }
    let(:invalid_resource) do
      resource = create(:resource)
      resource.name = nil
      resource
    end

    let(:valid_resource_attributes) { valid_resource.attributes }
    let(:valid_resource_params) { { id: resource, resource: valid_resource_attributes } }
    let(:invalid_resource_params) do
      { id: invalid_resource, resource: invalid_resource.attributes }
    end

    context 'unauthorized' do
      before { patch(:update, params: valid_resource_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'permits resource params' do
        is_expected.to permit(*permitted_params).
          for(:update, params: { params: valid_resource_params }).on(:resource)
      end

      context 'valid' do
        it 'saves' do
          valid_resource_params[:resource][:name] = 'new name'
          patch(:update, params: valid_resource_params)

          expect(response).to redirect_to(resource_path(resource))

          valid_resource.reload

          expected_flash = I18n.t('resources.update.done',
            title: valid_resource.title)

          expect(valid_resource.name).to eq('new name')
          expect(controller).to set_flash.to(expected_flash)
        end
      end

      context 'invalid' do
        render_views

        it 'does not save' do
          patch(:update, params: invalid_resource_params)
          expect(response).to render_template('resources/edit')
        end
      end

      describe 'helper methods' do
        it 'resource' do
          patch(:update, params: valid_resource_params)
          expect(controller.resource).to eq(valid_resource)
        end
      end
    end
  end
```

### Destroy

Método HTTP: `DELETE`

Url: `/resources/:id`

Responsável por remover um `resource`. Irá redirecionar para a action `index` com uma mensagem de erro ou sucesso.

Destroy padrão:

```ruby
  def destroy
    if resource.destroy
      redirect_to_index_with_success
    else
      redirect_to_index_with_error
    end
  end
```

Teste para action destroy:

```ruby
  let(:user) { create(:user) }

  describe '#destroy' do
    let(:resource) { create(:resource) }

    context 'unauthorized' do
      before { delete(:destroy, params: { id: resource }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'destroys' do
        resource

        expect do
          delete(:destroy, params: { id: resource })

          expected_flash = I18n.t('resources.destroy.done',
            title: resource.title)

          expect(response).to redirect_to(resources_path)
          expect(controller).to set_flash.to(expected_flash)
        end.to change(User, :count).by(-1)
      end

      describe 'helper methods' do
        it 'resource' do
          delete(:destroy, params: { id: resource })
          expect(controller.resource).to eq(resource)
        end
      end
    end
  end
```
