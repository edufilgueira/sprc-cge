#
# Rake extrair o dump mais atual e dar restore local ou em dev
# OBS: Rodar a rake localmente
#      Para fazer o dump temos que ligar a VPN
#
namespace :ops do

  # rake ops:local:dump_restore
  namespace :local do
    task dump_restore: :environment do

      path_output_sql = dump_local

      puts "Reiniciando sua base local..."
      system "DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rake db:drop && rake db:create"
      puts "Base local zerada!"

      puts "\n---\n"

      puts "Iniciando o restore..."
      system "psql -U postgres development_sprc < #{path_output_sql}"
      puts "Restore concluído"

      puts "\n---\n"

      puts "Atualizando emails e senhas..."
      system "rake ops:update_emails_passwords"

      puts "Criando outros usuários para testes..."
      system "rake users:create_or_update"
      system "rake jobs:clear"
      puts "DONE!!!"
    end
  end

  # rake ops:dev:dump_restore
  namespace :dev do
    task dump_restore: :environment do
      path_output_sql = dump_local

      puts "Movendo dump (#{path_output_sql}) para dev (/home/sprc/dump_cge/)..."
      system "scp #{path_output_sql} sprc@internal-app-01.caiena.net:~/dump_cge"

      system "ssh sprc@internal-app-01.caiena.net 'cd /app/sprc/dev/current/ && RAILS_ENV=production bin/rake ops:dev:restore_last_dump && exit'"
    end

    task only_restore_last_dump: :environment do
      system "ssh sprc@internal-app-01.caiena.net 'cd /app/sprc/dev/current/ && RAILS_ENV=production bin/rake ops:dev:restore_last_dump && exit'"
    end

    task kill_all_sessions: :environment do
      system "psql -h db-01 --username=caiena dev_sprc -c \"SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE pid <> pg_backend_pid() AND datname = 'dev_sprc';\""

      puts 'Todas as sessões finalizadas!'
    end

    task restore_last_dump: :environment do

      Rake::Task["ops:dev:kill_all_sessions"].invoke

      # Temos que dropar todas as sessões penduradas ao banco. Para visualizar os usuários ativos:
      # SELECT pid, usename, application_name FROM pg_stat_activity WHERE datname='dev_sprc';

      puts "\nIniciando restore... (Se houver sessões ativas no banco o restore não vai acontecer)\n"
      system "RAILS_ENV=production bundle exec rake db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
      system "RAILS_ENV=production bundle exec rake db:create"

      puts "\nRestaurando arquivo #{last_modified_file}\n"

      system "psql -h db-01 --username=caiena dev_sprc < #{last_modified_file}"

      system "Atualizando e-mails e senhas existentes! Veja no próximo log se todos foram atualizados para não enviar e-mails aos usuários"
      system "RAILS_ENV=production bin/rake ops:update_emails_passwords"
      system "\nAdicionando novos usuários...\n"
      system "RAILS_ENV=production bin/rake users:create_or_update"
      system "RAILS_ENV=production bin/rake jobs:clear"
      system "\nDONE!"
    end
  end


  task update_emails_passwords: :environment do

    local = ENV['STAGE'] == 'dev'

    update_email_and_password_by_resource(User, local, true)
    update_email_and_password_by_resource(PPA::Administrator, local, false)

    update_email_by_resource(Ticket)
    update_email_by_resource(Extension)
    update_email_by_resource(TicketDepartmentEmail)
    update_email_by_resource(TicketSubscription)
  end

  def last_modified_file
    Dir["/home/sprc/dump_cge/*"].sort_by { |p| File.mtime(p) }.last
  end

  def update_email_and_password_by_resource(resource_klass, password, email_confirmation)
    update_email_by_resource(resource_klass)
    confirm_email_by_resource(resource_klass) if email_confirmation
    update_password_by_resource(resource_klass) if password
  end


  def confirm_email_by_resource(resource_klass)
    resource_klass.where(confirmed_at: nil).update_all(confirmed_at: Time.now)
  end

  def update_password_by_resource(resource_klass)
    encrypted_password = User.new(password: 'creative400').encrypted_password
    resource_klass.update_all encrypted_password: encrypted_password
  end

  def update_email_by_resource(resource_klass)
    query = "UPDATE #{resource_klass.table_name} SET email = regexp_replace(email, '(.+)@.+', CAST(id as text) || '_' || '\\1@example.com');"

    result = ActiveRecord::Base.connection.execute query

    print "Foram atualizados #{result.cmd_tuples} emails de #{resource_klass.to_s}!\n"

    not_updated = resource_klass.where.not(email: '').where.not("email like ?", "%@example.com")
    if not_updated.count > 0
      print "Os emails dos ids #{not_updated.pluck(:id)} não foram alterados. Verificar a validação do de #{resource_klass.to_s}!\n"
    end
  end

  def dump_local
    puts "\n\n"
    puts "IMPORTANTE: Antes de começar ligue a VPN desconecte todas as aplicações penduradas ao banco"
    puts "\n---\n"
    puts "Escolha um diretório EXISTENTE para o DUMP (ex: '../../Downloads/', default: '/tmp/'): "

    STDOUT.flush
    dir_dump_input = STDIN.gets.chomp

    dir_dump = dir_dump_input.present? && system("[ -d #{dir_dump_input} ]") ? dir_dump_input : '/tmp/'

    dump_gz_filename = "sprc-#{Time.now.strftime('%Y%m%d%H%M%S')}.sql.gz"
    path_output_gz = dir_dump + dump_gz_filename
    path_output_sql = path_output_gz.gsub('.gz', '')

    puts "Iniciando DUMP..."
    system "ssh root@172.27.36.9 'pg_dump sprc -U sprc -W | gzip' > #{path_output_gz}"
    puts "Dump completo: #{path_output_gz}"

    puts "\n---\n"

    puts "Iniciando descompactação..."
    system "gunzip #{path_output_gz} #{dir_dump}"
    puts "Arquivo descompactado: #{path_output_sql}"

    puts "\n---\n"

    path_output_sql
  end

end
