#!/usr/bin/env bash
# Installs Nginx with the following configurations:
#+    Listens on port 80.
#+    Returns a page containing "Hellow World!" when queried
#+     at the root with a curl GET request.
# Configures /redirect_me as a "301 Moved Permanently".

# Install Nginx package
package { 'nginx':
  ensure => installed,
}

# Ensure Nginx service is running and enabled
service { 'nginx':
  ensure  => running,
  enable  => true,
  require => Package['nginx'],
}

# Configure Nginx server block
file { '/etc/nginx/sites-available/default':
  ensure  => file,
  content => template('nginx/default.erb'),
  notify  => Service['nginx'],
}

# Define the default server block template
file { '/etc/nginx/sites-available/default.erb':
  ensure => file,
  content => template('nginx/default.erb'),
  require => Package['nginx'],
}

# Ensure Nginx is listening on port 80
file { '/etc/nginx/sites-available/default':
  ensure  => present,
  replace => true,
}

# Create the HTML file for the root path
file { '/var/www/html/index.html':
  ensure  => present,
  content => 'Hello World!',
  require => Package['nginx'],
}

# Create a location block for the redirect
file { '/etc/nginx/sites-available/redirect_me':
  ensure  => file,
  content => template('nginx/redirect_me.erb'),
  require => Package['nginx'],
}

# Define the redirect location block template
file { '/etc/nginx/sites-available/redirect_me.erb':
  ensure => file,
  content => template('nginx/redirect_me.erb'),
  require => Package['nginx'],
}

# Ensure Nginx is listening on port 80
file { '/etc/nginx/sites-available/redirect_me':
  ensure  => present,
  replace => true,
}

# Create a symbolic link to enable the redirect site
file { '/etc/nginx/sites-enabled/redirect_me':
  ensure => link,
  target => '/etc/nginx/sites-available/redirect_me',
  require => File['/etc/nginx/sites-available/redirect_me'],
}

# Ensure Nginx is reloaded whenever the configuration changes
exec { 'nginx-reload':
  command     => '/usr/sbin/nginx -s reload',
  refreshonly => true,
  subscribe   => [File['/etc/nginx/sites-available/default'], File['/etc/nginx/sites-available/redirect_me']],
}

# Notify the Nginx service whenever configuration changes
Service['nginx'] ~> Exec['nginx-reload']
