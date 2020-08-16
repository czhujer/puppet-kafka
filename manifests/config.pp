# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include kafka::config
class kafka::config (
  $service_install = $kafka::service_install,
  $service_restart = $kafka::service_restart,
  $service_name    = $kafka::service_name,
  $group           = $kafka::group,
  $config_dir      = $kafka::config_dir,
  $config          = $kafka::config,
) {

  if ($service_install and $service_restart) {
    $config_notify = Service[$service_name]
  } else {
    $config_notify = undef
  }

  file { "${config_dir}/server.properties":
    ensure  => present,
    owner   => 'root',
    group   => $group,
    content => template('kafka/properties.erb'),
    notify  => $config_notify,
    require => File[$config_dir],
  }
}
