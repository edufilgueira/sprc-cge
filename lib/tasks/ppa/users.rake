namespace :ppa do
  namespace :users do
    desc 'Creates a PPA Administrator user account'
    task create_or_update: :environment do

      # PPA::Administrator.find_or_create_by(email: 'ppa.admin@example.com') do |ppa_admin|
      #   ppa_admin.attributes = {
      #     name: 'PPA Admin',
      #     cpf: CPF.generate(true),
      #     password: '123456',
      #     password_confirmation: '123456'
      #   }
      #   ppa_admin.skip_confirmation!
      # end

    end
  end
end
