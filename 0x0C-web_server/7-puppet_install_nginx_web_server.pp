#!/usr/bin/env bash
# Installs Nginx with the following configurations:
#+    Listens on port 80.
#+    Returns a page containing "Hellow World!" when queried
#+     at the root with a curl GET request.
# Configures /redirect_me as a "301 Moved Permanently".

package { 'nginx':
  ensure => installed,
}

service { 'nginx':
  ensure  => running,
  enable  => true,
  require => Package['nginx'],
}

file { '/etc/nginx/sites-available/default':
  ensure  => file,
  content => template('nginx/default.erb'),
  notify  => Service['nginx'],
}

file { '/etc/nginx/sites-available/default.erb':
  ensure => file,
  content => template('nginx/default.erb'),
  require => Package['nginx'],
}

file { '/etc/nginx/sites-available/default':
  ensure  => present,
  replace => true,
}

file { '/var/www/html/index.html':
  ensure  => present,
  content => 'Hello World!',
  require => Package['nginx'],
}

file { '/etc/nginx/sites-available/redirect_me':
  ensure  => file,
  content => template('nginx/redirect_me.erb'),
  require => Package['nginx'],
}

file { '/etc/nginx/sites-available/redirect_me.erb':
  ensure => file,
  content => template('nginx/redirect_me.erb'),
  require => Package['nginx'],
}

file { '/etc/nginx/sites-available/redirect_me':
  ensure  => present,
  replace => true,
}

file { '/etc/nginx/sites-enabled/redirect_me':
  ensure => link,
  target => '/etc/nginx/sites-available/redirect_me',
  require => File['/etc/nginx/sites-available/redirect_me'],
}
exec { 'nginx-reload':
  command     => '/usr/sbin/nginx -s reload',
  refreshonly => true,
  subscribe   => [File['/etc/nginx/sites-available/default'], File['/etc/nginx/sites-available/redirect_me']],
}

Service['nginx'] ~> Exec['nginx-reload']
