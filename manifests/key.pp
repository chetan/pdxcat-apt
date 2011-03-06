##
# Apt Module init.pp
#
# Computer Action Team
# Maseeh College of Engineering & Computer Science
# Portland State University
#

# Class: apt::key
#
# Imports an apt repository key
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
# 
#  apt::key {
#    "cat":
#      keyid => "1EE15D43",
#      ensure => present;
#    "dropbox":
#      keyid => "5044912E",
#      ensure => present;
#  }
#
define apt::key (
  $keyid,
  $ensure,
  $source = "pgp.mit.edu",
  $method = "server"
) {
  include apt

  case $ensure {
    present: {
      exec { "Import $keyid to apt keystore":
        path      => "/bin:/usr/bin",
        command   => $method ? {
          server  => "gpg --keyserver $source --recv-keys $keyid && gpg --export --armor $keyid | apt-key add -",
          wget    => "wget -q $source -O- | apt-key add -",
        },
        user      => "root",
        group     => "root",
        unless    => "apt-key list | grep $keyid",
        logoutput => true,
      }
    }
    absent:  {
      exec { "Remove $keyid from apt keystore":
        path    => "/bin:/usr/bin",
        command => "apt-key del $keyid",
        user    => "root",
        group   => "root",
        onlyif  => "apt-key list | grep $keyid",
      }
    }
    default: {
      fail "Invalid 'ensure' value '$ensure' for aptkey"
    }
  }
}
