namespace :prod_users do
  task create_or_update: :environment do

    users_data = [
      # template
      # {
      #   "name": "Luciana Freire Castelo Branco",
      #   "document_type": "cpf",
      #   "document": "484.363.213-91",
      #   "gender": "female",
      #   "server": true,
      #   "city": City.find_by(name: "Fortaleza"),
      #   "organ": Organ.find_by(acronym: "ADAGRI"),
      #   "email": "luciana.castelobranco@adagri.ce.gov.br",
      #   "email_confirmation": "luciana.castelobranco@adagri.ce.gov.br",
      #   "user_type": "operator",
      #   "operator_type": "sou_sectoral",
      #   "denunciation_tracking": ""
      # }
    ]

    users_data.each_with_index do |user_attrs, index|
      user_email = user_attrs[:email]

      user = User.find_or_initialize_by(email: user_email)
      user.attributes = user_attrs
      user.assign_secure_random_password
      user.save!
      puts "Success line #{index} - name: #{user_attrs[:name]}"
    end
  end
end
