#!/usr/bin/env bash
# Installs Nginx with the following configurations:
#+    Listens on port 80.
#+    Returns a page containing "Hellow World!" when queried
#+     at the root with a curl GET request.
# Configures /redirect_me as a "301 Moved Permanently".

# Define the nginx class
class { 'nginx':
  listen_port => 80,
}

# Create a virtual host configuration for the default server
nginx::resource::vhost { 'default':
  ensure   => present,
  www_root => '/var/www/html',
}

# Define a location block for the root directory
nginx::resource::location { 'root':
  location   => '/',
  ensure     => present,
  vhost      => 'default',
  content    => 'Hello World!',
}

# Define a location block for the /redirect_me URL
nginx::resource::location { 'redirect_me':
  location   => '/redirect_me',
  ensure     => present,
  vhost      => 'default',
  content    => '',
  rewrite    => 'permanent',
  rewrite_to => '/',
}
