#
# Classe responsável pela busca global relacionada ao model ServerSalary.
#
class GlobalSearcher::ServerSalarySearcher < GlobalSearcher::Base

  # a busca é no servers, mas exibimos server salary
  # é preciso trazer mais para garantir que pelo menos 5 possuem salário
  # existem servers sem registration e servers salary

  SEARCH_LIMIT = 15

  RESULT_LIMIT = 5

  REGISTRATION_COLUMNS = %q{
    integration_servers_registrations.dsc_cpf
  }.freeze

  private

  def model_klass
    Integration::Servers::Server
  end

  def model_server_salary
    Integration::Servers::ServerSalary
  end

  def search_result(result)
    description = "#{result.role_name} (#{result.registration.organ.sigla})"

    {
      title: result.server_name,
      description: description,
      link: transparency_server_salary_path(result, locale_params)
    }
  end

  def show_more_url
    transparency_server_salaries_path(show_more_url_params)
  end

  def limited_results
    # Devemos retornar apenas o último registro de salário do servidor, para
    # evitar resultados repetidos.

    results = []

    registrations_from_results(super).each do |cpf|

      server_salary = server_salary_from_registration(cpf)
      results << server_salary if server_salary.present?

      break if results.size == RESULT_LIMIT
    end

    results
  end

  def registrations_from_results(results)
    results.distinct.pluck(:dsc_cpf)
  end

  def server_salary_from_registration(cpf)
    model_server_salary
      .includes(registration: :organ)
      .includes(:role)
      .references(registration: :organ)
      .references(:role)
      .where('integration_servers_registrations.dsc_cpf' => cpf)
      .order('date DESC').first
  end
end





