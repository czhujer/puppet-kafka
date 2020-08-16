# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include kafka
class kafka (
  $manage_java   = true,
  $package_name  = undef,
  $version       = '2.5.1',
  $scala_version = '2.13',
  $install_url   = 'https://downloads.apache.org/kafka',
  $user          = 'kafka',
  $group         = 'kafka',
  $package_dir   = '/var/tmp/kafka',
  $config_dir    = '/opt/kafka/config',
  $log_dir       = '/var/log/kafka',
) {
  validate_bool($manage_java)

  contain ::kafka::install
}
