module CacheHelper


  def self.cache_key_for(prefix, models)
    models = [models] unless models.is_a?(Array)

    result = "#{prefix}"

    if is_server_salary_model?(models)
      result += server_salary_result

    else
      models.each do |model|
        count = model.count
        max_updated_at = max_updated_at(model)

        result += "/#{model.name}-#{count}-#{max_updated_at}"

      end
    end

    result
  end

  def cache_key_for(prefix, model)
    CacheHelper.cache_key_for(prefix, model)
  end

  private

  def self.is_server_salary_model?(models)
    models == [server_salary_model]
  end

  def self.server_salary_result
    "/#{server_salary_model.name}-#{last_update(server_salary_configuration)}"
  end

  def self.server_salary_model
    Integration::Servers::ServerSalary
  end

  def self.last_update(configuration)
    configuration.pluck(:updated_at).first
  end

  def self.server_salary_configuration
    Integration::Servers::Configuration
  end

  def self.max_updated_at(model)
    model.maximum(:updated_at).try(:utc).try(:to_s, :number)
  end
end
