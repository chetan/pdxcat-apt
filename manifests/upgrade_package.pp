##
# Apt Module upgrade_package.pp
#
# Source: lelutin's puppet-apt module
# https://github.com/lelutin/puppet-apt.git
#
# Computer Action Team
# Maseeh College of Engineering & Computer Science
# Portland State University
#

# Class: apt::upgrade_package
#
# Ensures that a specific package, if installed, is upgraded either to the
# latest available version or to the version specified.
#
# One example use for this class is to ensure that packages affected by 
# security vulnerabilities are updated, where they would otherwise not be
# ensure => latest.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#  apt::upgrade_package { 
#    "mailman",
#  }
#
#
define apt::upgrade_package ($version = "") {
  include apt

  $version_suffix = $version ? {
    ""       => ""
    "latest" => ""
    default  => "=${version}",
  }

  if !defined(Package["apt-show-versions"]) {
    package { "apt-show-versions":
      ensure => installed,
      require => undef,
    }
  }

  if !defined(Package["dctrl-tools"]) {
    package { "dctrl-tools":
      ensure => installed,
      require => undef,
    }
  }

  exec { "aptitude -y install ${name}${version_suffix}":
    path    => "/usr/bin:/usr/sbin:/bin:/sbin",
    onlyif  => [ 
      "grep-status -F Status installed -a -P $name -q",
      "apt-show-versions -u $name | grep -q upgradeable",
    ],
    require => [
      Exec["apt-update"],
      Package["apt-show-versions", "dctrl-tools"],
    ],
  }

}
