# Configura o local de armazenamento dos anexos para a pasta _uploads_
# Padrão: tmp/uploads

uploads_path = Rails.root.join('public', 'files', 'uploads').to_s

Refile.store = Refile::Backend::FileSystem.new("#{uploads_path}/store")
Refile.cache = Refile::Backend::FileSystem.new("#{uploads_path}/cache", max_size: 50.megabytes)
