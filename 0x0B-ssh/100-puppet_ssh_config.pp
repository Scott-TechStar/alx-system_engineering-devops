#!/usr/bin/env bash
# Using puppet to make configuration changes to my server

file{ 'etc/ssh/ssh_config':
      ensure => present,
content =>"
      	# SSH client Configurations
	Host*
	PasswordAuthentication no
	IdentityFile ~/.ssh/school
     	",
}
