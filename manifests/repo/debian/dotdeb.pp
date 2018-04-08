class php::repo::debian::dotdeb(
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

}
