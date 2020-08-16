# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include kafka::service
class kafka::service (
  $service_install = $kafka::service_install,
  $service_restart = $kafka::service_restart,
  $service_ensure  = $kafka::service_ensure,
  $service_name    = $kafka::service_name,
  $log_dir         = $kafka::log_dir,
  $env             = $kafka::env,
  $heap_opts       = $kafka::heap_opts,
  $jmx_opts        = $kafka::jmx_opts,
  $log4j_opts      = $kafka::log4j_opts,
  $opts            = $kafka::opts,
  $bin_dir         = $kafka::bin_dir,
  $daemon_start    = $kafka::daemon_start,
  $config_dir      = $kafka::config_dir,
  $user            = $kafka::user,
  $group           = $kafka::group,
) {

  if $service_install {
    $env_defaults = {
      'KAFKA_HEAP_OPTS'  => $heap_opts,
      'KAFKA_JMX_OPTS'   => $jmx_opts,
      'KAFKA_LOG4J_OPTS' => $log4j_opts,
      'KAFKA_OPTS'       => $opts,
      'LOG_DIR'          => $log_dir,
    }
    $environment = deep_merge($env_defaults, $env)

    include systemd

    file { "/etc/systemd/system/${service_name}.service":
      ensure  => file,
      mode    => '0644',
      content => template('kafka/unit.erb'),
    }

    File["/etc/systemd/system/${service_name}.service"]
    ~> Exec['systemctl-daemon-reload']
    -> Service[$service_name]

    service { $service_name:
      ensure     => $service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
