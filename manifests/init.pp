##
# Apt Module init.pp
#
# Computer Action Team
# Maseeh College of Engineering & Computer Science
#

import "key.pp"
import "repo.pp"
import "upgrade_package.pp"

# Class: apt
#
# Defines base resources used by apt::repo and apt::key.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class apt {

  $apt_dir = $operatingsystem ? {
    debian => "/root/etc/apt",
    ubuntu => "/etc/apt",
  }

  $sources_dir = "${apt_dir}/sources.list.d"

  exec { 
    "apt-update":
      path        => "/usr/bin:/usr/sbin:/bin:/sbin",
      command     => "apt-get update",
      refreshonly => true;
  }

  cron { 
    "apt-update":
      command => "/usr/bin/apt-get update 1>/dev/null 2>/dev/null",
      user    => root,
      hour    => 22,
      minute  => fqdn_rand(60);
  }

}
