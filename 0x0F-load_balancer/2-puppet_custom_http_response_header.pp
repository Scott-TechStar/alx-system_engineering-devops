#!/usr/bin/env bash
# Installs Nginx with the following configurations:
#+    Listens on port 80.
#+    Returns a page containing "Hellow World!" when queried
#+     at the root with a curl GET request.
# Configures /redirect_me as a "301 Moved Permanently".
package { 'nginx':
  ensure => installed,
}

file { '/etc/nginx/html':
  ensure => directory,
  owner  => 'root',
  group  => 'root',
  mode   => '0755',
}

file { '/etc/nginx/html/index.html':
  ensure  => file,
  content => 'Hello World!',
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
}

file { '/etc/nginx/sites-available/default':
  ensure  => file,
  content => "server {
    listen 80;
    listen [::]:80 default_server;
    add_header X-Served-By $hostname;
    root   /etc/nginx/html;
    index  index.html index.htm;

    location /redirect_me {
        return 301 https://scott-techstar.github.io/;
    }
    error_page 404 /404.html;
      location /404 {
        root /etc/nginx/html;
        internal;
      }
}",
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
}

service { 'nginx':
  ensure  => running,
  enable  => true,
  require => [
    Package['nginx'],
    File['/etc/nginx/html'],
    File['/etc/nginx/html/index.html'],
    File['/etc/nginx/sites-available/default'],
  ],
}
