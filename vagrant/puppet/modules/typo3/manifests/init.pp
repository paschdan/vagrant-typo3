# downloads typo3
class typo3
(
$version = params_lookup( 'version' ),
$download_dir = params_lookup ( 'download_dir' ),
$download_url = params_lookup ( 'download_url' ),
$site_name = params_lookup ( 'site_name' )
) inherits typo3::params
{
    Exec['tar_gz'] ~> Exec['extract']
    
    exec { 'tar_gz':
        command   => "/usr/bin/curl -o ${download_dir}/typo3_src-${version}.tar.gz ${download_url}/typo3_src-${version}.tar.gz?download --location",
        logoutput => true,
        timeout   => 300, 
        unless    => "ls ${download_dir}/typo3_src-${version}.tar.gz",
    }
    
    exec { 'extract':
         cwd => "${download_dir}",
         command   => "tar xvzf ${download_dir}/typo3_src-${version}.tar.gz",
         logoutput => true,
         timeout   => 300,
         creates => "${download_dir}/typo3_src-${version}"
    }
    
    file { "site_name" : 
        path => "/var/www/${site_name}",
        ensure => 'directory'
    }
    
    file { "/var/www/${site_name}/typo3_src" : 
        ensure => 'link',
        target => "${download_dir}/typo3_src-${version}",
        require => Exec['extract']
    }
    
    file { "/var/www/${site_name}/index.php" :
        ensure => 'link',
        target => "typo3_src/index.php",
        require => File["/var/www/${site_name}/typo3_src"]
    }
    
    file { "/var/www/${site_name}/typo3" :
        ensure => 'link',
        target => "typo3_src/typo3",
        require => File["/var/www/${site_name}/typo3_src"]
    }
    
    apache::vhost { "${site_name}" :
        docroot => "/var/www/${site_name}",
        directory => "/var/www/${site_name}",
        directory_allow_override   => 'All'
    }

}