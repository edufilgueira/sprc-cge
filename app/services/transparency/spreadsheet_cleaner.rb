#
# Rotina de limpeza dos registros de exportação dos dados de transparência (registro da tabela e planilhas vinculadas)
# Deverá ser executado diariamente invocando pelo crontab do sistema registrado em 'config/schedule.rb'
#
class Transparency::SpreadsheetCleaner

  def self.call
    new.call
  end


  def call
    clear_expired_and_not_started
  end


  private

  def clear_expired_and_not_started
    # Todos as planilhas vinculadas ao model são removidas no callback do model
    # Todas as exportações que já foram processadas com sucesso e já expiraram
    Transparency::Export.where(status: :success, expiration: Date.today).destroy_all
  end
end
