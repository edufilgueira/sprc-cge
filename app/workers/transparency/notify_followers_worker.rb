class Transparency::NotifyFollowersWorker
  include Sidekiq::Worker
  sidekiq_options queue: :low

  def perform
    #
    # Da forma que está os serviços são executados dentro da mesma thread!
    # Para otimizar podemos separa os workers para processamento paralelo
    #
    [
      'Contracts::Contract',
      'Contracts::Convenant',
      'Contracts::ManagementContract',
      'Constructions::Dae',
      'Constructions::Der'
    ].each do |integration_model_name|
        model = "Integration::#{integration_model_name}".constantize
        service = "Transparency::Notifications::Integration::#{integration_model_name}Follow".constantize

        send('notify_followers', model, service)
    end
  end

  def notify_followers(model, service)
    resourceable_type = model.model_name.name

    followers = Transparency::Follower.where(resourceable_type: resourceable_type, unsubscribed_at: nil)

    followers.find_each { |f| service.call(f.resourceable_id) }
  end
end
