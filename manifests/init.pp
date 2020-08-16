# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include kafka
class kafka (
  $manage_java     = true,
  $package_name    = undef,
  $version         = '2.5.1',
  $scala_version   = '2.13',
  $install_url     = 'https://downloads.apache.org/kafka',
  $user            = 'kafka',
  $group           = 'kafka',
  $package_dir     = '/var/tmp/kafka',
  $config_dir      = '/opt/kafka/config',
  $log_dir         = '/var/log/kafka',
  $service_name    = 'kafka',
  $service_install = true,
  $service_ensure  = 'running',
  $service_restart = true,
  $env             = {},
  $config          = {
    'broker.id'         => '0',
    'zookeeper.connect' => 'localhost:2181'
  },
  $heap_opts       = '-Xmx1G -Xms1G',
  $jmx_opts        = '-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false \
  -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.port=9990',
  $log4j_opts      = "-Dlog4j.configuration=file:/opt/kafka/config/log4j.properties",
  $opts            = '',
  $bin_dir         = '/opt/kafka/bin',
  $daemon_start    = false,
  $restart_package_change = true,
) {
  validate_bool($manage_java)
  validate_bool($service_install)
  validate_bool($service_restart)

  contain ::kafka::install
  contain ::kafka::config
  contain ::kafka::service

  Class['kafka::install']
  -> Class['kafka::config']
  -> Class['kafka::service']

}
