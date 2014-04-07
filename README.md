#TYPO3 Vagrant on CentOs

A Vagrant Box installing Typo3 6.2 on Top of CentOs with PHP 5.5

## Requirements

1. Oracle VirtualBox
2. Vagrant 1.3.0+

## Setup
1. Clone this repository recursive:     
    `git clone --recursive https://github.com/paschdan/vagrant-typo3.git`
    
2. Edit your hosts-file and add 192.168.33.10 as typo3.loc:     
    `echo 192.168.33.10 typo3.loc | sudo tee -a /etc/hosts`
    
3. `vagrant up`

    After Vagrant booted the Vagrant-Machine you should see "typo3.loc" in the www-directory.
    
    This is a Synced folder with your typo3 project. Here you can add files and edit configuration.

4. Add a file `FIRST_INSTALL` to the `www/typo3.loc`:     
    `touch www/typo3.loc/FIRST_INSTALL`

5. Go to [http://typo3.loc](http://typo3.loc)

6. Follow the Installation-Tool instructions. Database-User is "root" with no password.

7. You are Ready with a fresh install of TYPO3 CMS.

### Additional information about TYPO3 6.2.0 and the introduction package

Due to a bug in the core, some pictures are not copied during installation of the introduction package. (see [Typo3 Bug#57312](http://forge.typo3.org/issues/57312) )
This will be fixed in 6.2.1 but until then you have to copy the missing pictures manually:

   `cp -R www/typo3.loc/typo3conf/ext/introduction/Initialisation/Files/images/theme www/typo3.loc/fileadmin/introduction/images/theme 

## Using TYPO3 < 6.2.0

if you want to use older Typo3 versions, you have to edit the file `vagrant/puppet/manifests/init.pp`.
Scroll to the button where it is installing typo3 and change it to the following:
   ```
   #install typo3 6.1.7
    class { 'typo3' : 
        site_name => 'typo3.loc',
        version => '6.1.7',
        site_type => 'introductionpackage'
    }
    ```
## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `feature_x`)
3. Write your chang
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github
