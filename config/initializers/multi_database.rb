#
# Initializer para configuração dos diferentes bancos de dados entre a
# aplicação principal (SPRC) e aplicação específica (SPRC Data)
#

database_config_file = File.open(Rails.root.join('config','database.yml'))
database_config = YAML::load(database_config_file)
data_database_config = database_config['data']

if data_database_config.blank?
  puts '[ERRO] É preciso configurar o banco de dados de data em database.yml.'
  exit
else
  # constante global para config do database data
  DATA_DATABASE_CONFIG = data_database_config[Rails.env]
end
