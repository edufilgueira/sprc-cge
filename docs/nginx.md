Configuração padrão para o Loadbalancer:

```conf

fastcgi.conf.default    koi-win                 nginx.conf.default      uwsgi_params.default
[root@srv8-nuvem ~]# vi /etc/nginx/conf.d/sprc.conf

# redirect HTTP to HTTPS
server {
    # SAMPLE: certbot redirect http->https conf
    # --
    #if ($host = www.cearatransparente.ce.gov.br) {
    #    return 301 https://$host$request_uri;
    #} # managed by Certbot
    #
    #
    #if ($host = cearatransparente.ce.gov.br) {
    #    return 301 https://$host$request_uri;
    #} # managed by Certbot

    listen 80;
    listen [::]:80;
    server_name cearatransparente.ce.gov.br www.cearatransparente.ce.gov.br;
    return 301 https://$server_name$request_uri;
}

# Settings for a TLS enabled server.
server {
    listen       443 ssl http2;
    listen       [::]:443 ssl http2;
    server_name cearatransparente.ce.gov.br www.cearatransparente.ce.gov.br;
    root         /usr/share/nginx/html;

    # Load configuration files for the default server block.
    include /etc/nginx/default.d/*.conf;

    client_max_body_size 50M;

    location / {
        # Set proxy headers
        proxy_set_header        Host $host;
        proxy_set_header        X-Real-IP $remote_addr;
        proxy_set_header        X-Forwarded-For
        $proxy_add_x_forwarded_for;

        proxy_pass http://sprc;
    }

    location /SOU/ {
      proxy_pass      http://172.27.40.63/SOU/;
      proxy_read_timeout   600;
    }

    error_page 404 /404.html;
        location = /40x.html {
    }

    error_page 500 502 503 504 /50x.html;
        location = /50x.html {
    }

    ssl_certificate /etc/letsencrypt/live/cearatransparente.ce.gov.br/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/cearatransparente.ce.gov.br/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
}

upstream sprc {
    # XXX: nao usar ip_hash! A infra tunela todos os acessos
    # em um unico IP!
    # Ainda, nao precisamos de "sticky sessions" pois as sessoes
    # sao armazenadas em cookies e a app tem o mesmo secret em
    # todos os nos!
    #ip_hash; # "sticky sessions"

    # mandic/nuvem
    server 172.27.36.10;
    server 172.27.36.13;

    # colocation/cge
    #server 172.27.40.101;
    #server 172.27.40.102;
}

```