class php::repo::debian::sury(
  $location     = 'http://packages.dotdeb.org',
  # $release      = 'wheezy-php56',
  $release      = "%{facts.os.distro.codename}",
  $repos        = 'all',
  $include_src  = false,
  $key          = {
    'id'     => '6572BBEF1B5FF28B28B706837E3F070089DF5277',
    'source' => 'http://www.dotdeb.org/dotdeb.gpg',
  },
  $dotdeb       = false,
  $sury         = true,
) {
  # Required packages for PHP 7.1 repository
  ensure_packages(['lsb-release', 'ca-certificates'], {'ensure' => 'present'})

  # Add PHP 7.1 key + repository
  apt::key { 'php::repo::debian-php71':
    id     => 'DF3D585DB8F0EB658690A554AC0E47584A7A714D',
    source => 'https://packages.sury.org/php/apt.gpg',
  }

  ::apt::source { 'source_php_71':
    location => 'https://packages.sury.org/php/',
    release  => $facts['os']['distro']['codename'],
    repos    => 'main',
    include  => {
      'src' => $include_src,
      'deb' => true,
    },
    require  => [
      Apt::Key['php::repo::debian-php71'],
      Package['apt-transport-https', 'lsb-release', 'ca-certificates']
    ],
  }
}
