Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }

group { 'www-data':
    ensure => 'present',    
}

user { ['apache', 'nginx', 'httpd', 'www-data']:
  shell  => '/bin/bash',
  ensure => present,
  groups => 'www-data',
  require => Group['www-data']
}


Yumrepo <| |> -> Package <| |>

#yumrepo { "epel-repo":
#        baseurl => "http://download.fedoraproject.org/pub/epel/6/\$basearch",
#        descr => "Epel Repo",
#        enabled => 1,
#        gpgcheck => 0,
#}

yumrepo   { "remi-repo":
        baseurl => "http://rpms.famillecollet.com/enterprise/6/remi/\$basearch/",
        descr => "remi repo",
        enabled => 1,
        gpgcheck => 0,
}

yumrepo   { "remi-php55":
        baseurl => "http://rpms.famillecollet.com/enterprise/6/php55/\$basearch/",
        descr => "remi php55 repo",
        enabled => 1,
        gpgcheck => 0,
}

#insall apache 
class { 'apache': }

apache::module { 'rewrite': }

#install php
class { 'php':
    service_autorestart => true,
    service => 'httpd',
    version => 'latest'
}



 # php.ini
php::augeas { 'php-memorylimit':
  entry  => 'PHP/memory_limit',
  value  => '128M',
  require => Class['php'],
  notify => Service['httpd']
}

php::augeas { 'php-date_timezone':
  entry  => 'Date/date.timezone',
  value  => 'Europe/Minsk',
  require => Class['php'],
  notify => Service['httpd']
}

php::augeas { 'max_execution_time':
  entry  => 'PHP/max_execution_time',
  value  => '240',
  require => Class['php'],
  notify => Service['httpd']
}

php::augeas { 'upload_max_filesize':
  entry  => 'PHP/upload_max_filesize',
  value  => '10M',
  require => Class['php'],
  notify => Service['httpd']
}

php::augeas { 'post_max_size':
  entry  => 'PHP/post_max_size',
  value  => '10M',
  require => Class['php'],
  notify => Service['httpd']
}


#instll php-modules

php::module { "gd": }
php::module { "soap": }
php::module { "mysqlnd": }

#install mysql

class { 'mysql':
    root_password => ''
}

#install typo3
$site_name = 'typo3.loc'

class { 'typo3' : 
    site_name => $site_name 
}

apache::vhost { "${site_name}" :
    docroot => "/var/www/${site_name}",
    directory => "/var/www/${site_name}",
    directory_allow_override   => 'All'
}
