##
# Apt Module repo.pp
#
# Computer Action Team
# Maseeh College of Engineering & Computer Science
# Portland State University
#

# Class: apt::repo
#
# Configures repositories to use with apt.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#  apt::repo {
#    "ubuntu.canonical.partner.deb":
#      source_type  => "deb",
#      uri          => "http://archive.canonical.com/ubuntu",
#      component    => "partner";
#    "ubuntu.canonical.partner.src":
#      source_type  => "deb-src",
#      uri          => "http://archive.canonical.com/ubuntu",
#      component    => "partner";
#  }
#
define apt::repo (
  $apt_dir      = "${apt::apt_dir}",
  $sources_dir  = "${apt::sources_dir}",
  $source_type  = "deb",
  $uri          = "http://mirrors.cat.pdx.edu/${lsbdistid}/",
  $distribution = "${lsbdistcodename}",
  $component    = "main",
  $ensure       = "present"
) {
  include apt

  file {
    "${sources_dir}/${name}.list":
      content => "${source_type} ${uri} ${distribution} ${component}\n",
      owner   => root,
      group   => root,
      mode    => 0644,
      ensure  => $ensure,
      notify  => Exec["apt-update"];
  }
}
