# Configure debian apt repo
#
# === Parameters
#
# [*location*]
#   Location of the apt repository
#
# [*release*]
#   Release of the apt repository
#
# [*repos*]
#   Apt repository names
#
# [*include_src*]
#   Add source source repository
#
# [*key*]
#   Public key in apt::key format
#
# [*dotdeb*]
#   Enable special dotdeb handling
#
# [*sury*]
#   Enable special sury handling
#
class php::repo::debian(
  $location     = 'http://packages.dotdeb.org',
  # $release      = 'wheezy-php56',
  $release      = "%{facts.os.distro.codename}",
  $repos        = 'all',
  $include_src  = false,
  $key          = {
    'id'     => '6572BBEF1B5FF28B28B706837E3F070089DF5277',
    'source' => 'http://www.dotdeb.org/dotdeb.gpg',
  },
  Enum['auto', 'native', 'sury', 'dotdeb', 'custom' ] $repo_management =  'auto',
) {

  if $caller_module_name != $module_name {
    warning('php::repo::debian is private')
  }

  include '::apt'

  create_resources(::apt::key, { 'php::repo::debian' => {
    id     => $key['id'],
    source => $key['source'],
  }})

  ::apt::source { "source_php_${release}":
    location => $location,
    release  => $release,
    repos    => $repos,
    include  => {
      'src' => $include_src,
      'deb' => true,
    },
    require  => Apt::Key['php::repo::debian'],
  }

  if ($dotdeb) {
    # both repositories are required to work correctly
    # See: http://www.dotdeb.org/instructions/
    if $release == 'wheezy-php56' {
      ::apt::source { 'dotdeb-wheezy-php56':
        location => 'http://packages.dotdeb.org',
        release  => 'wheezy-php56',
        repos    => 'all',
        include  => {
          'src' => $include_src,
          'deb' => true,
        },
      }
    }
  }


  if (repo_management == 'sury') {
    class { 'php::repo::debian::sury': }
  }
}
