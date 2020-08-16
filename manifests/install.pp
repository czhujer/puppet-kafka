# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include kafka::install
class kafka::install (
  $manage_java   = $kafka::manage_java,
  $package_name  = $kafka::package_name,
  $version       = $kafka::version,
  $scala_version = $kafka::scala_version,
  $install_url   = $kafka::install_url,
  $user          = $kafka::user,
  $group         = $kafka::group,
  $package_dir   = $kafka::package_dir,
  $config_dir    = $kafka::config_dir,
  $log_dir       = $kafka::log_dir,
) {

  if $manage_java {
    class { 'java':
      distribution => 'jdk',
    }
  }

  group { $group:
    ensure => present,
  }

  user { $user:
    ensure  => present,
    shell   => '/bin/bash',
    require => Group[$group],
  }

  file { $config_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  file { $log_dir:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    require => [
      Group[$group],
      User[$user],
    ],
  }

  if $package_name == undef {

    include archive

    $basefilename = "kafka_${scala_version}-${version}.tgz"
    $package_url = "${install_url}/${version}/${basefilename}"

    $install_directory = "/opt/kafka-${scala_version}-${version}"

    file { $package_dir:
      ensure  => directory,
      owner   => $user,
      group   => $group,
      require => [
        Group[$group],
        User[$user],
      ],
    }

    file { $install_directory:
      ensure  => directory,
      owner   => $user,
      group   => $group,
      require => [
        Group[$group],
        User[$user],
      ],
    }

    file { '/opt/kafka':
      ensure  => link,
      target  => $install_directory,
      require => File[$install_directory],
    }

    archive { "${package_dir}/${basefilename}":
      ensure          => present,
      extract         => true,
      extract_command => 'tar xfz %s --strip-components=1',
      extract_path    => $install_directory,
      source          => $package_url,
      creates         => "${install_directory}/config",
      cleanup         => true,
      user            => $user,
      group           => $group,
      require         => [
        File[$package_dir],
        File[$install_directory],
        Group[$group],
        User[$user],
      ],
      before          => File[$config_dir],
    }

  } else {

    package { $package_name:
      ensure => $package_ensure,
      before => File[$config_dir],
    }

  }
}
