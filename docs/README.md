Estrura e rascunho geral da documentação que deve ser atualizada durante o desenvolvimento.

Cada documentação deve ficar em seu arquivo específico.

Devemos criar:

  servers.md, application/models.md, application/controllers.md, application/views.md, ...

---


- Servers

  - Sistema Operacional (CentOS ou similar)

    - iptables com portas liberadas 22, 80 e 443;

    - iptables com acesso a todas as máquinas envolvidas na aplicação;

    - /etc/hosts com o apelido de cada máquina;


  - App

    - RVM, Ruby, Rails, Passenger;

    - Apache (config);

    - SSL (Let's encrypt);

    - Criação do usuário da app pertencendo também ao grupo 'rvm';

    - Deploy (estrutura básica da app pertencendo ao usuário da app)


  - Database

    - Config básica do PG (pg_hba.conf);

  - File

    - Explicar a importância de centralizar o servidor de arquivos em um cenário com mais de um servidor de aplicação;

  - Services

    - DelayedJob (deve também ser configurado com o init.d, colocar exemplo do init.d)


- Application



  - Models

    - Seções (Setup, Validations, Associations...):

      * pra que serve cada seção (esqueleto e exemplos básicos de testes)

      [esqueleto de um model]

        ```

          # Setup (acts_as.., devise, ...)

          # Enums

          # Associations (3 grupos na ordem: belongs_to, has_one, has_many)

          # Nesteds

          # Delegations

          # Validations

          # Public methods

          ## Class methods

          ## Instance methods

          # Private methods

          ## Class methods

          ## Instance methods

        ```

      [esqueleto de teste do model]

      ```
        shared_examples;

        subject;

        factories;

        db

          columns;

          indexes;

        enums;

        associations;

        validations;

        helpers;
      ```

  - Controllers

    - 7 actions (esqueleto e exemplos básicos)

  - Views

    - Aspectos gerais (nunca usar textos não localizáveis, não exagerar na lógica de negócio que deveria estar em 'helpers de views', acessam infos do controller por 'helpers de controller')

    - Partials (devem receber as variáveis locais sempre...)

  - Helpers

    - Responsáveis por lógicas de negócio da camada de apresentação;

    - Devem gerar o mínimo de código html pois dificulta teste, desenvolvimento e manutenção;

    - Tem relação com controllers e os métodos públicos deve ser prefixados com o nome do model relacionado ao controller.

      Exemplo: helper para cuidar do controller de tickets:

        - TicketsHelper

        - métodos devem começar com ticket_... (ex: ticket_answer_types_for_select)

    - Exemplos com testes: Enums em um select do form, ...


  - Services

    - Responsáveis por grande parte das lógicas de negócio;

  - Mailers

  - Jobs

  - Rakes

    - Explicar sobre o 'application:setup', 'application:reset';

    - Explicar o conceito de tasks ':create_or_update' (São seguras pois não destroem dados e geralmente usadas para inicializar a aplicação em determinado ambiente)

- Frontend

  - Bootstrap 4

  - Arquitetura básica de um crud no admin

  - Responsividade

  - Acessibilidade

- Mobile
