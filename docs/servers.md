# Servers

## Sistema Operacional (CentOS ou similar)

### 0. Habilitar portas no iptables

- libere as portas do servidor de acordo com o uso. Servidores para uso interno, podem ser liberados para toda a rede, independente de porta. Servidores externos, devem ser liberados apenas as portas do serviço (http: 80, https: 443) e para a subrede do servidor (10.0.0.0/8, por exemplo).

### 1. configurar hosts caso seja servidor externo (Rackspace, por exemplo)

 Para servidores do Rackspace, por exemplo, todos os servidores que formarão a aplicação (aplicação, database, storage, cache, etc.) devem estar mapeados. Há formas muito melhores de mapeá-los, como um DNS server. Mas, no mínimo, todas os servers devem estar mapeados em ```/etc/hosts``` com seus respectivos ip internos. Dessa forma, a configuração de um database.yml, por exemplo, apontaria para 'seuprojeto-db-01' e não para um ip específico.

 - editar ```/etc/hosts``` e inserir o alias para os outros servers (Ex:  ```10.208.129.19 seuprojeto-db-01```).

 ### 2. Locale e timezone

 Verifique se o _timezone_ e _locale_ estão configurados como esperado

 Para _locale_, no CentoOS
 - `sed -i 's/UTF-8/utf8/g' /etc/sysconfig/i18n && echo "LC_CTYPE=\"pt_BR.utf8\"" >> /etc/sysconfig/i18n`
 Caso ocorra algum erro de arquivo não encontrado, utilizar o comando abaixo:
 `sed -i 's/UTF-8/utf8/g' /etc/locale.conf && echo "LC_CTYPE=\"pt_BR.utf8\"" >> /etc/locale.conf`
 No CentOS 7, o "/etc/sysconfig/i18n" foi substituído por "/etc/locale.conf".

Para _timezone_, no CentoOS
- `rm -f /etc/localtime && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime`


## App

As configurações são feitas de acordo com a plataforma utilizada.

### 0. RVM

RVM é o gerenciador de versões do ruby. Para instalar:

`gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3`

* Apenas RVM: `\curl -sSL https://get.rvm.io | bash`

* RVM + Ruby: `\curl -sSL https://get.rvm.io | bash -s stable --ruby`

Passo a passo com mais detalhes em https://rvm.io/rvm/install

Para o projeto, deve-se instalar o ruby versão *2.4.9*

`rvm install 2.4.9`


### 1. Usuário + Chave de sua aplicação

* Crie o usuário e um chave para a aplicação:
```bash
_APP_USERNAME=<NOME DO USUÁRIO DE SUA APLICAÇÃO>; adduser $_APP_USERNAME; mkdir /home/$_APP_USERNAME/.ssh && chmod 0700 /home/$_APP_USERNAME/.ssh && ssh-keygen -t rsa -N "" -C $_APP_USERNAME -f /home/$_APP_USERNAME/.ssh/id_rsa && chown -R $_APP_USERNAME.$_APP_USERNAME /home/$_APP_USERNAME && cat /home/$_APP_USERNAME/.ssh/id_rsa.pub
```

* Será exibido o conteúdo da chave pública (/home/nome_do_usuario/.ssh/id_rsa.pub). Adicione no repositório da aplicação (GitHub -> Repositório -> Settings -> Deploy Keys)

* Faça o teste:
```bash
 su - <nome_do_usuario>
 ssh git@github.com
```

Deve ser possível conectar, mas o GitHub informará que não provê um shell.

* Adicione o usuário da aplicação ao grupo rvm:
```bash
  usermod -a -G rvm <USUÁRIO_DA_APLICAÇÃO>
```

### 2. Estrutura básica da aplicação

* O nome do usuário e do local aplicação devem seguir o mesmo padrão.

```bash
_APP_USERNAME=<NOME DA APLICAÇAO>; mkdir -p /app/$_APP_USERNAME/production/shared/config && chown -R $_APP_USERNAME.$_APP_USERNAME /app/$_APP_USERNAME
```

* Configure o database da aplicação:
```bash
vi /app/<NOME_DA_APPLICACAO>/production/shared/config/database.yml
```
E insira:

[postgresql]
```yaml

production:
  adapter: postgresql
  database: <DATABASE> # nome da aplcação, geralmente
  username: <USERNAME> # nome da aplcação, geralmente. não esqueça de criar o role e habilitar no pg_hba.conf
  template: <TEMPLATE> # template0, geralmente
  pool: 5
  encoding: utf8
  collate: pt_BR.utf8
  ctype: pt_BR.utf8
  timeout: 5000
  host: <HOST> # si-db-01, db-01, locahost, ....
```

* Configure outras informações da aplicação (application.yml, secrets.yml, skylight.yml, sidekiq.yml.. e outros):


---

Configure o secrets.yml da sua aplicação:

```bash
vi /app/<NOME_DA_APPLICACAO>/production/shared/config/secrets.yml
```

Ex:

```yaml
production:
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
```

---

* Crie o database:

[postgres]

* Crie o role para a conexão da aplicação. Na máquina de database:


```bash
psql --username=postgres -c "create role <USER_CONFIGURADO_EM_DATABASE_YML> createdb noinherit login;"
```

* Edite o pg_hba.conf para permitir a conexão:

[centos]
```bash
 vi /var/lib/pgsql/9.6/data/pg_hba.conf
```

Ex:
`host    all             <USERNAME>       10.208.105.31/3         trust`

---



### 3. Passenger + Apache

* ```yum install -y curl-devel httpd-devel apr-devel apr-util-devel```

* ```rvm use 2.4.9@<SEU_PROJETO>```

* ```gem install passenger```

* executar: ```passenger-install-apache2-module```

* confome instruções do passenger, editar: ```/etc/httpd/conf.d/passanger.conf``` e adicionar a configuração que for exibida, algo como:

```conf
LoadModule passenger_module /usr/local/rvm/gems/ruby-2.4.9@<SEU_PROJETO>/gems/passenger-4.0.37/buildout/apache2/mod_passenger.so
<IfModule mod_passenger.c>
 PassengerRoot /usr/local/rvm/gems/ruby-2.4.9@<SEU_PROJETO>/gems/passenger-4.0.37
 PassengerDefaultRuby /usr/local/rvm/gems/ruby-2.1.0@<SEU_PROJETO>/wrappers/ruby
</IfModule>
```

* editar: ```/etc/httpd/conf.d/<SEU_PROJETO>.conf``` e adicionar:

```conf
<VirtualHost *:443>
  ServerName <URL_DO_SISTEMA>
  ServerAlias www.<URL_DO_SISTEMA>

  # using capistrano deploy path
  DocumentRoot /app/<SEU_PROJETO>/production/current/public

  # specific ruby version, other than PassengerDefaultRuby
  PassengerRuby /usr/local/rvm/wrappers/ruby-2.4.9@<SEU_PROJETO>/ruby
  PassengerAppEnv production
  PassengerAppRoot "/app/<SEU_PROJETO>/production/current"
  # PassengerHighPerformance on

  XSendFile On
  XSendFilePath /app/<SEU_PROJETO>/production/releases

  # gzip compression and expires header (cache)
  SetOutputFilter DEFLATE
  ExpiresActive on

  <Directory /app/<SEU_PROJETO>/production/current>
    # gzip mime-types
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE text/csv
    AddOutputFilterByType DEFLATE application/rss+xml
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE application/x-javascript
    AddOutputFilterByType DEFLATE application/vnd.oasis.opendocument.spreadsheet
    AddOutputFilterByType DEFLATE application/xls
    AddOutputFilterByType DEFLATE application/json

    Allow from all
    Options -MultiViews
    # For Apache >= 2.4, uncomment the line below
    Require all granted
  </Directory>

  # Compactação e expire-header por extensão
  <FilesMatch "\.(js|css|gif|png|jpg|ico|ttf|otf|woff|woff2|eot|svg)$">
    ExpiresDefault "access plus 1 week"
    SetOutputFilter Deflate
  </FilesMatch>

</VirtualHost>
```


* Reiniciar e salvar apache: ```service httpd start && chkconfig httpd on```

### 4. SSL (Let's encrypt)

Atualizar o virtual host (porta e certificado)

- `vim /etc/httpd/conf.d/<SEU_PROJETO>.conf`

```conf
<VirtualHost *:443>

  ...

  # SSL
  SSLEngine on
  SSLCertificateFile /etc/pki/tls/certs/localhost.crt
  SSLCertificateKeyFile /etc/pkii/tls/private/localhost.key

</VirtualHost>
```

Redirecionar chamados http para https

- `vim /etc/httpd/conf.d/<SEU_PROJETO>https-only.conf`

```conf
<VirtualHost *:80>
  ServerName <URL_DO_SISTEMA>
  ServerAlias www.<URL_DO_SISTEMA>

  RedirectMatch 302 ^(.*)$ http://<URL_DO_SISTEMA>$1
  RewriteEngine on
  RewriteCond %{SERVER_NAME} =<URL_DO_SISTEMA> [OR]
  RewriteCond %{SERVER_NAME} =www.<URL_DO_SISTEMA>
  RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,QSA,R=permanent]
</VirtualHost>
```

- IMPORTANT: É necessário ser DNS A Record
- `yum install -y epel-release`
- `yum install -y httpd mod_ssl python-certbot-apache`
- `certbot --apache -d qa.sprc.caiena.net`

Se você precisa adicionar dominios extras (ex: demo.sprc.caiena.net), use:
- `certbot --apache -d sprc.caiena.net,qa.sprc.caiena.net,demo.sprc.caiena.net --expand`

Referências (Let's Encrypt SSL Certificate)

- https://certbot.eff.org/docs/using.html#certbot-command-line-options
- https://www.digitalocean.com/community/tutorials/how-to-secure-apache-with-let-s-encrypt-on-centos-7

-  https://www.digitalocean.com/community/tutorials/how-to-set-up-let-s-encrypt-certificates-for-multiple-apache-virtual-hosts-on-ubuntu-16-04



## PostgreSQL no CentOS

> Para essa página é usado o PostgreSQL 9.5 e CentOS 6.7. Quando for instalar, verifique se existe uma versão mais recente.



### 0. Configurar repositorio YUM

Localize e edite o arquivo `/etc/yum.repos.d/CentOS-Base.repo`, seções [base] e [updates].
Nas seções indicadas, é necessário acrescentar a seguinte linha (caso contrário as dependências podem não ser encontrados pelo repositório [base]):
```
exclude=postgresql*
```



### 1. Instalar _PGDG RPM file_

O _PGDG file_ varia para cada combinação de distribuição/arquitetura/versão do banco de dados.
Busque em [http://yum.postgresql.org](http://yum.postgresql.org) a versão correta. Por exemplo, para instalar PostgreSQL 9.5 no CentOS 6 64-bit:
```
yum localinstall https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-6-x86_64/pgdg-centos95-9.5-2.noarch.rpm
```



### 2. Instalar o PostgreSQL

Para listar os pacotes disponíveis:
```
yum list postgres*
```
Por exemplo, para instalar o _PostgreSQL 9.5 server_:
```
yum install postgresql95-server
```



### 3. Configuração inicial

O primeiro comando (precisa ser executado somente uma vez) é inicializar o banco de dados _PGDATA_.
```service postgresql-9.5 initdb```



### 4. Executar

Para iniciar o banco de dados, use:
```
sudo service postgresql-9.5 start
```
Outros comandos disponíveis são: `start`, `stop`, `restart`, `reload`



### 5. Liberar acesso remoto

- Se ainda não estiver, Editar `/etc/sysconfig/iptables`
  - Insira a seguinte regra no local adequado: `-A INPUT -m state --state NEW -m tcp -p tcp --dport 5432 -j ACCEPT`
- Recarregue as regras: `sudo service iptables restart`
- Entre com o usuário `postgres`: `sudo su - postgres`
- No arquivo `vim /var/lib/pgsql/9.5/data/postgresql.conf` adicione no local adequado a linha `listen_addresses = '*'` (Se necessário, troque o '*' pelos ips que terão acesso)
- No arquivo `vim /var/lib/pgsql/9.5/data/pg_hba.conf` adicione no local adequado a linha `host    all             all             0.0.0.0/0               md5`
- Reinicie o PostgreSQL: `sudo service postgresql-9.5 restart`

> Se o servidor de aplicação (por ex. Tomcat) estiver instalado na mesma máquina, o acesso será por `localhost`, então será necessário também trocar o método de autenticação para `md5` (o _default_ é `ident`).
Ex.: Trocar `host    all             all             127.0.0.1/32            ident` por `host    all             all             127.0.0.1/32            md5`



### 6. Inicialização automática

Para iniciar o PostgreSQL automaticamente quando o OS inicia:
```
chkconfig postgresql-9.5 on
```

## Deploy local

### 1. Instalar RVM

```bash
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable
```

### 2. Instalar o ruby

```bash
rvm install 2.4.9
```

### 3. Clonar o repositório e entrar no diretório

```bash
git clone git@github.com:caiena/sprc
cd sprc
```

### 4. Instalar gems

```bash
gem install bundler
bundle install
```

### 5. Fazer o deploy no ambiente desejado

- Edite o endereço do servidor em `config/deploy/production.rb` e faça o deploy:

```bash
cap [dev|qa|production] deploy
```


## File

- Explicar a importância de centralizar o servidor de arquivos em um cenário com mais de um servidor de aplicação;
TODO

## Services


### Sidekiq

O Sidekiq  é o serviço escolhido para executar tarefas em background.

Antes de configurar o sidekiq, precisa ter instalado o redis:

- Instalar o repositório EPEL

```bash
wget -r --no-parent -A 'epel-release-*.rpm' http://dl.fedoraproject.org/pub/epel/7/x86_64/e/

rpm -Uvh dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-*.rpm

```
- Instala o redis e inicia o serviço:

```
yum install redis
systemctl start redis.service
chkconfig redis on

```

- Para testar, execute: `redis-cli ping`, a resposta deve ser `PONG`

Após instalar o redis, devemos configurar o sidekiq para que seja executado, basta adicionar a configuraço em `/etc/systemd/system/<SEU_PROJETO>.sidekiq.service`:

```
# systemd unit file for CentOS 7
#
# Customize this file based on your bundler location, app directory, etc.
# Put this in /etc/systemd/system/
# Run:
#   - systemctl enable sidekiq
#   - systemctl {start,stop,restart} sidekiq
#
# This file corresponds to a single Sidekiq process.  Add multiple copies
# to run multiple processes (sidekiq-1, sidekiq-2, etc).
#
# See Inspeqtor's Systemd wiki page for more detail about Systemd:
# https://github.com/mperham/inspeqtor/wiki/Systemd
#
[Unit]
Description=sidekiq
# start us only once the network and logging subsystems are available,
# consider adding redis-server.service if Redis is local and systemd-managed.
After=syslog.target network.target

# See these pages for lots of options:
# http://0pointer.de/public/systemd-man/systemd.service.html
# http://0pointer.de/public/systemd-man/systemd.exec.html
[Service]
Type=simple
WorkingDirectory=/app/<SEU_PROJETO>/production/current
ExecStart=/bin/bash -lc 'bundle exec sidekiq -e production'
User=<SEU_PROJETO>
Group=app
UMask=0002

# if we crash, restart
RestartSec=1
Restart=on-failure

# output goes to /var/log/syslog
StandardOutput=syslog
StandardError=syslog

# This will default to "bundler" if we don't specify it
SyslogIdentifier=sidekiq

[Install]
WantedBy=multi-user.target
```

Iniciar o sidekiq:

```
systemctl enable <SEU_PROJETO>.sidekiq.service
systemctl start <SEU_PROJETO>.sidekiq.service
```

E por fim permitir que o usuário da aplicação possa dar `sudo` no service:

Adicionar em `/etc/sudoers`:

```
# systemd - <SEU_PROJETO> sidekiq
<SEU_PROJETO>   ALL=NOPASSWD: /bin/systemctl start <SEU_PROJETO>.sidekiq.service
<SEU_PROJETO>   ALL=NOPASSWD: /bin/systemctl stop <SEU_PROJETO>.sidekiq.service
<SEU_PROJETO>   ALL=NOPASSWD: /bin/systemctl restart <SEU_PROJETO>.sidekiq.service
<SEU_PROJETO>   ALL=NOPASSWD: /bin/systemctl status <SEU_PROJETO>.sidekiq.service

# sysv fallback - <SEU_PROJETO> sidekiq
<SEU_PROJETO>   ALL=NOPASSWD: /usr/sbin/service <SEU_PROJETO>.sidekiq start
<SEU_PROJETO>   ALL=NOPASSWD: /usr/sbin/service <SEU_PROJETO>.sidekiq stop
<SEU_PROJETO>   ALL=NOPASSWD: /usr/sbin/service <SEU_PROJETO>.sidekiq restart
<SEU_PROJETO>   ALL=NOPASSWD: /usr/sbin/service <SEU_PROJETO>.sidekiq status
```
