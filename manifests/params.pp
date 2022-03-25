class chrony::params {
  $commandkey       = 0
  $keys             = []
  $package_ensure   = 'present'
  $service_enable   = true
  $service_ensure   = 'running'
  $service_manage   = true
  $chrony_password  = 'xyzzy'
  $queryhosts       = []
  $port             = 0
  $makestep         = '0.5 3'
  $stratumweight    = '0'
  $local_stratum    = '10'
  $config_keys_manage = true

  case $::osfamily {
    'Archlinux' : {
      $config = '/etc/chrony.conf'
      $config_template = 'chrony/chrony.conf.archlinux.erb'
      $config_keys = '/etc/chrony.keys'
      $config_keys_template = 'chrony/chrony.keys.archlinux.erb'
      $config_keys_owner = 0
      $config_keys_group = 0
      $config_keys_mode  = '0644'
      $package_name = 'chrony'
      $service_name = 'chrony'
      $servers = {
        '0.pool.ntp.org' => ['iburst'],
        '1.pool.ntp.org' => ['iburst'],
        '2.pool.ntp.org' => ['iburst'],
      }
    }
    'RedHat' : {
      $config = '/etc/chrony.conf'
      $config_template = 'chrony/chrony.conf.redhat.erb'
      $config_keys = '/etc/chrony.keys'
      $config_keys_template = 'chrony/chrony.keys.redhat.erb'
      $config_keys_owner = 0
      $config_keys_group = chrony
      $config_keys_mode  = '0640'
      $package_name = 'chrony'
      $service_name = 'chronyd'
      $servers = {
        '0.pool.ntp.org' => ['iburst'],
        '1.pool.ntp.org' => ['iburst'],
        '2.pool.ntp.org' => ['iburst'],
      }
    }

    'Debian' : {
      $config = '/etc/chrony/chrony.conf'
      $config_template = 'chrony/chrony.conf.debian.erb'
      $config_keys = '/etc/chrony/chrony.keys'
      $config_keys_template = 'chrony/chrony.keys.debian.erb'
      $config_keys_owner = 0
      $config_keys_group = root
      $config_keys_mode  = '0640'
      $package_name = 'chrony'
      $service_name = 'chrony'
      $servers = {
        '0.pool.ntp.org' => ['iburst'],
        '1.pool.ntp.org' => ['iburst'],
        '2.pool.ntp.org' => ['iburst'],
      }
    }
    default     : {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
