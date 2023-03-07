#
# Rake para importar os dados necessários para a aplicação estar pronta para
# o desenvolvimento.
#
# Tasks:
#
# - setup: carrega os dados necessários sem limpar o banco de dados;
# - reset: recria o banco de dados e carrega os dados iniciais;
#

namespace :application do

  desc 'Setup application'
  task :setup => :environment do

    # tasks

    tasks = [
      'states:create_or_update',
      'cities:create_or_update',
      'organs:create_or_update',
      'executive_organs:create_or_update',
      'rede_ouvir_organs:create_or_update',
      'departments:create_or_update',
      'users:create_or_update',
      'topics:create_or_update',
      'budget_programs:create_or_update',
      'service_types:create_or_update',
      'search_contents:pages:create_or_update',
      'search_contents:transparency:create_or_update',

      # ppa
      #'ppa:users:create_or_update',
      'ppa:plans:create_or_update'
    ]

    tasks.each { |task| Rake::Task[task].invoke }
  end

  desc 'Reset application database'
  task reset: :environment do
    def confirm_reset?
      print '[ATENÇÃO] essa rake irá APAGAR O BANCO DE DADOS, tem certeza? (yes para continuar): '
      STDOUT.flush
      input = STDIN.gets.chomp

      input.downcase === 'yes'
    end

    exit unless confirm_reset?

    # tasks

    tasks = [
      'db:drop',
      'db:create',
      'db:migrate',
      'application:setup'
    ]

    tasks.each { |task| Rake::Task[task].invoke }
  end
end
