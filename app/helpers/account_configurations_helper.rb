module AccountConfigurationsHelper
  def account_configurations_for_select
    sorted_account_configurations.map {|acc| [acc.title, acc.id]}
  end

  private

  def sorted_account_configurations
    Integration::Revenues::AccountConfiguration.sorted
  end
end
