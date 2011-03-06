##
# Apt Module repo/managed.pp
#
# Computer Action Team
# Maseeh College of Engineering & Computer Science
# Portland State University
#

# Class: apt::repo::purge
#
# Purges the apt sources.list file, thus requiring all repositories to be
# defined using files in the sources.list.d directory. This is the means by
# which the apt::repo class defines repositories.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# include apt::repo::purge
#

class apt::repo::purge {
  include apt

  file {
    "${apt::sources_dir}":
      ensure   => directory,
      owner    => root,
      group    => root,
      mode     => 0755,
      purge    => true,
      recurse  => true,
      force    => true;
    "${apt::apt_dir}/sources.list":
      ensure   => file,
      content  => "# Repos managed by puppet. See the sources.list.d dir\n";
  }

}
