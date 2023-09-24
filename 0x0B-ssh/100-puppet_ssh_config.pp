#!/usr/bin/env bash
# Using puppet to make configuration changes to my server

file{ 'etc/ssh/ssh_config':
      ensure => present,

      content =>"
      	      # SSH client Configurations
	      Host 34.227.91.107
	      	   PasswordAuthentication no
		   IdentityFile ~/.ssh/school
		   BatchMode yes
		   SendEnv LANG LC_*
		   HashKnownHosts yes
		   GSSAPIAuthentication yes
		   GSSAPIDelegateCredentials no
     		",
}
