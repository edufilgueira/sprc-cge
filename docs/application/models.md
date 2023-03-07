# Model

_Active Record_ é o M do MVC. O componente de _Model_ do Rails é um conjunto de classes que usam o `ActiveRecord`, uma classe ORM que mapeia objetos em tabelas do banco de dados. O `ActiveRecord` usa convenções de nome para determinar os mapeamentos, utilizando uma série de regras que devem ser seguidas para que a configuração seja a mínima possível.

## Criando um novo model

Usando o terminal é possível criar facilmente um model. Por exemplo: Ao rodar:

`rails generate model Ticket description:string email:string organ:references answer_type:integer`

é gerando automaticamente o arquivo `app/models/ticket.rb` com o conteúdo

```ruby
class Ticket < ApplicationRecord
end
```

Ao gerar o model também é criado o arquivo de _migration_.
Ex: `db/migrate/20170404213710_create_tickets.rb`

com o conteúdo:

```ruby
class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.string :description, null: false
      t.integer :answer_type, null: false
      t.string :email
      ...

      t.timestamps
    end

  end
end
```

Para aplicar as alterações no banco basta rodar o seguinte comando:
`rake db:migrate`

e para desfazer a última alteração:
`rake db:rollback`

## Esqueleto

Além do mapeamento da estrutura de dados por padrões de nomeação, os models são responsáveis por manter métodos de classe, lógicas de validadação de atributos, associações com outros models e setup de bibliotecas envolvidas.

O conteúdo dos models deste projeto seguem a estrutura e ordem definidas conforme a organização abaixo:

```ruby
class Ticket < ApplicationRecord
  # Setup
  # Enums
  # Associations
  # Nesteds
  # Delegations
  # Validations
  # Public methods
  ## Class methods
  ## Instance methods
  # Private methods
  ## Class methods
  ## Instance methods
end
```

### 1. Setup

  Integra bibliotecas (gems) como o model, como por exemplo o `devise` para habilitar e configurar a autenticação deste model e a _gem_ `acts_as_paranoid` para deleção lógica dos registros.

### 2. Enums

  Seção que define as opções dos atributos que funcionam como enumeradores do projeto.

### 3. Associations

  Define as associações com os demais models.
  Estão organizados em 3 grupos na ordem: `belongs_to`, `has_one`, `has_many`

### 4. Nesteds

  Atributos aninhados pemitem salvar atributos de registros associados

  Ex:
  ```ruby
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  ```

  No exemplo acima, podemos criar um novo objeto junto com uma coleção de _attachments_ (anexos)

### 5. Delegations

  Fornece um método de classe delegado de outro objeto para expor facilmente novos métodos.

  ex:
  ```ruby
  delegate :name, :acronym, to: :organ, prefix: true, allow_nil: true
  ```
  e posso recupera a informação apenas com `ticket.organ_name` ao invés de `ticket.organ.acronym`

### 6. Validations

  Lógica de validação de atributos como presença, unicidade e outros validações específicas que podem ser definidas através de novos métodos.

### 7. Public methods

  Seção onde os métodos podem ser acessados por módulos externos

### 7.1 Class methods

  Métodos de clase estáticos onde não é necessário criar uma instância

### 7.2 Instance methods

  Métodos que para serem invocados necessitam um nova instância

### 8. Private methods

  Seção onde os métodos podem ser acessados somente por métodos dentro do próprio model

### 8.1 Class methods

  Métodos de clase estáticos onde não é necessário criar uma instância para invocá###lo

### 8.2 Instance methods

  Métodos que para serem invocados necessitam um nova instância dentro da própria classe

## Testes

Os testes de models devem ser construídos para garantir a configuração e o comportamento esperados de um model.

Por exemplo, devemos garantir a validação de presença de atributos, e se existir, testar a lógica de validação desses atributos.


```ruby
require 'rails_helper'

describe Ticket do
  # shared_examples;
  # subject;
  # factories;
  # db
  ## columns;
  ## indexes;
  # enums;
  # associations;
  # validations;
  # helpers;
end
```

### 1. shared_examples
  Shared examples permite que você descreva o comportamento de classes e módulos. Quando declarado, o conteúdo do grupo compartilhado é armazenado e pode ser invocado por qualquer outro módulo de teste.

  ex:

  `paranoia_example.rb`
  ```ruby
  shared_examples_for 'models/paranoia' do
    it { is_expected.to act_as_paranoid }
    ...
  end
  ```

  `ticket_spec.rb`
  ```ruby
  describe Ticket do
    it_behaves_like 'models/paranoia'
    ...
  end
  ```

  `user_spec.rb`
  ```ruby
  describe User do
    it_behaves_like 'models/paranoia'
    ...
  end
  ```

### 2. subject
  Use _subject_ para definir um valor a ser retornado pelo método _subject_ dentro do seu escopo declarado.

  ex:

  ```ruby
  describe Ticket do

    subject(:ticket) { build(:ticket) }
    ...

    describe 'helpers' do
      it 'title' do
        expected = I18n.t('ticket.protocol_title', protocol: ticket.parent_protocol)
        expect(ticket.title).to eq(expected)
      end
    end
    ...
  end
  ```

### 3. factories

  Escopo para testar a criação de objetos
  ex:

  ```ruby
  describe Ticket do

    describe 'factories' do
      it { is_expected.to be_valid }

      it { expect(build(:ticket, :confirmed)).to be_valid }

      it { expect(build(:ticket, :invalid)).to be_invalid }
    end
    ...
  end

  ```
### 4. db
  É importante testar a presença de colunas e indices na estrutura da tabela do banco de dados

### 4.1 columns
  ex:

  ```ruby
  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:answer_type).of_type(:integer) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
      ...
    end
  end

  ```
### 4.2 indexes
  Ex:

  ```ruby
  describe 'db' do
    describe 'indexes' do
      it { is_expected.to have_db_index(:organ_id) }
      it { is_expected.to have_db_index(:protocol) }
      ...
    end
  end
```
### 5. enums
  Escopo de testes de presença do atributos enumerados e seus valores permitidos

  ex:

  ```ruby
  describe 'enums' do
    it 'answer_type' do
      answer_types = [:default, :phone, :letter]

      is_expected.to define_enum_for(:answer_type).with(answer_types)
    end

    it 'status' do
      statuses = [:in_progress, :confirmed]

      is_expected.to define_enum_for(:status).with(statuses)
    end
  end
  ```

### 6. associations
  Teste para garantir associações com os demais _models_

  ex:

  ```ruby
  describe 'associations' do
    it { is_expected.to belong_to(:organ) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end
  ```

### 7. validations

  Teste para garantiar a presença das validações dos atributos

  ex:
  ```ruby
    describe 'validations' do
      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to validate_presence_of(:answer_type) }

      it { is_expected.to validate_uniqueness_of(:protocol) }
    end
  ```

### 8. helpers

  Teste para garantir o retorno dos métodos helper do model

  ex:
  ```ruby
  describe 'helpers' do
    it 'title' do
      expected = I18n.t('ticket.protocol_title', protocol: ticket.parent_protocol)
      expect(ticket.title).to eq(expected)
    end
  end
  ```
