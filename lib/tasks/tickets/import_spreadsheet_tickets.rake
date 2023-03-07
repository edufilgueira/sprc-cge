require "#{Rails.root}/app/helpers/tickets_helper.rb"
require "#{Rails.root}/app/helpers/organs_helper.rb"

include TicketsHelper, OrgansHelper

# Rake para importar os municípios
namespace :tickets do

  MESSAGES = {
    param: 'Erro na passagem de parametros. Informe o caminho da planilha.',
    file: 'Verifique o caminho da planilha. Arquivo não encontrado'
  }

  BOOLEAN_VALUE = {
    'SIM': true,
    'NÃO': false
  }


  desc 'Importar Planilha de Atendimentos Itinerantes'  
  task :import_spreadsheet_tickets, [:spreadsheet_path] => :environment do |t, args|
    
    if !args.spreadsheet_path.present? 
      raise MESSAGES[:param]
    elsif !File.exist?(args.spreadsheet_path)
      raise MESSAGES[:file]
    end    

    xlsx =  Roo::Spreadsheet.open(args.spreadsheet_path)

    
    rows_count = 2  # 1 é cabeçalho | 0 é nulo

    while rows_count <= xlsx.sheet(0).count
      row = xlsx.sheet(0).row(rows_count)
      ticket = { ticket: set_ticket_params(row) }

      uri = set_uri

      http = Net::HTTP.new(uri.host, uri.port)

      response = http.post(
        uri,
        ticket.to_json,
        {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
      )

      puts ":::::::::::::::: Informações do Post (Protocolo #{ticket[:ticket][:protocol]}) ::::::::::::::::"

      if response.code == '302'
        puts "Status: Salvo com Sucesso"
      else
        puts "Status: NÃO Salvo"
        puts "Código da Resposta do Post: #{response.code} | Menssagem: #{response.message}"

        puts "Resposta do Post:"
        puts " #{response.body}"
      end

      rows_count += 1

    end #/ while rows_count
  end #/ task import_spreadsheet_tickets

  def set_ticket_params(row)
    {
      anonymous: boolean_value(row[11]),
      answer_address_city_name: row[31],
      answer_address_neighborhood: row[30],
      answer_address_number: row[48],
      answer_address_street: row[47],
      answer_address_zipcode: row[49],
      answer_cell_phone: try_phone(row[43]),
      answer_phone: try_phone(row[42]),
      answer_type: Ticket.answer_types[ticket_answer_type(row[33])],
      city_id: search_city_by_name(row[31]),
      #confirmed_at: Time.current, #possui default
      created_by_id: User.find_by_name(row[10]), # criar metodo para trazes apenas um usuário
      #deadline: CURRENT_DEADLINE,
      #deadline_ends_at: ENTRY_DATE + Holiday.next_weekday(INITIAL_DEADLINE, ENTRY_DATE),
      description: row[12],
      document: row[45],
      document_type: row[46] ? Ticket.document_types[row[46].downcase] : nil,
      email: row[41],
      # internal_status: ticket_internal_status(row[15]),
      name: row[39],
      organ_id: organ_by_acronym(row[3]),
      password: row[9],
      plain_password: row[9],
      protocol: row[8],
      sou_type: Ticket.sou_types[sou_type_enum(row[0])],
      status: Ticket.statuses[:confirmed],
      unknown_organ: organ_by_acronym(row[3]).nil?,
      unknown_subnet: true, # para os orgãos SESA e SEDUC e de acordo com as regras de validação do model devemos implementar para pegar o value dinâmico, na importação de Aracati não caiu nesta condição.
      used_input: Ticket.used_inputs[:presential]
    }

  end

  def sou_type_enum(value)
    sou_types_for_select.to_h.transform_keys{ |key| key.to_s.upcase }["#{value}"]
  end

  def ticket_answer_type(value)
    ticket_answer_types_for_select.to_h.transform_keys{ |key| key.to_s.upcase }["#{value}"]
  end

  def organ_by_acronym(acronym)
    if acronym
      organs_for_select.select{|i| i[0].split(' - ')[0] == acronym}[0][1]
    end
  end

  def boolean_value(value)
    BOOLEAN_VALUE[value.to_sym]
  end

  def try_phone(value = nil)
    if value
      value.to_s.gsub(".0", '')
    end
  end

  def ticket_internal_status(value)
    ticket_all_internal_status.to_h.transform_keys{ |key| key.to_s.upcase }["#{value}"]
  end

  def search_city_by_name(city_name)
    city_name = city_name.capitalize if !city_name.nil?
    city = City.where(name: city_name, state_id: State.find_by_acronym('CE').id)
    if !city.empty?
      return city.first.id
    end
  end

  def set_uri
    URI.parse("http://localhost#{port}/operator/tickets/importers")
  end

  def port
    if Rails.env.development?
      ':3000'
    end
  end

end #/ namespace :tickets