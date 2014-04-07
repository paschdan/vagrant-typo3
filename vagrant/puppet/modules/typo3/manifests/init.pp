# downloads typo3
class typo3
(
$version = params_lookup( 'version' ),
$download_dir = params_lookup ( 'download_dir' ),
$download_url = params_lookup ( 'download_url' ),
$site_name = params_lookup ( 'site_name' ),
$site_type = params_lookup ( 'site_type' )
) inherits typo3::params
{
    Exec['tar_gz'] ~> Exec['extract']
    
    exec { 'tar_gz':
        command   => "/usr/bin/curl -o ${download_dir}/${site_type}-${version}.tar.gz ${download_url}/${site_type}-${version}.tar.gz?download --location",
        logoutput => true,
        timeout   => 300, 
        unless    => "ls ${download_dir}/${site_type}-${version}.tar.gz",
    }
    
    exec { 'extract':
         cwd => "${download_dir}",
         command   => "tar xvzf ${download_dir}/${site_type}-${version}.tar.gz",
         logoutput => true,
         timeout   => 300,
         creates => "${download_dir}/${site_type}-${version}"
    }
    
    file { "site_name" : 
        path => "/var/www/${site_name}",
        ensure => 'directory'
    }
    
    file { "/var/www/${site_name}/typo3_src" : 
        ensure => 'link',
        target => "${download_dir}/${site_type}-${version}",
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
    
    if versioncmp($version, '6.2.0') < 0 {
        file { "/var/www/${site_name}/t3lib":
            ensure => 'link',
            target => "typo3_src/t3lib",
            require => File["/var/www/${site_name}/typo3_src"]
        }
        
        file {"/var/www/${site_name}/typo3conf":
            ensure => 'directory',
            require => File['site_name']
            }
            
        file {"/var/www/${site_name}/.htaccess" : 
            ensure => 'present',
            source => "${download_dir}/${site_type}-${version}/.htaccess",
            owner => 'apache',
            group => 'games'
        }
        
        if ($site_type != 'typo3_src') {
            #copy user files
            exec { 'copy_fileadmin':
                command => "cp -R ${download_dir}/${site_type}-${version}/fileadmin /var/www/${site_name}/",
                unless => "ls /var/www/${site_name}/fileadmin",
                require => Exec['extract']
            }
            
            exec { 'copy_typo3conf':
                command => "cp -R ${download_dir}/${site_type}-${version}/typo3conf /var/www/${site_name}/",
                unless => "ls /var/www/${site_name}/typo3conf/index.html",
                require => Exec['extract']
            }
            
            exec { 'copy_uploads':
                command => "cp -R ${download_dir}/${site_type}-${version}/uploads /var/www/${site_name}/",
                unless => "ls /var/www/${site_name}/uploads",
                require => Exec['extract']
            }
            
        }
            
    }
    
    apache::vhost { "${site_name}" :
        docroot => "/var/www/${site_name}",
        directory => "/var/www/${site_name}",
        directory_allow_override   => 'All'
    }

}