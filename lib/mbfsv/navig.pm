package mbfsv::navig;
use strict;

sub in_a_git_dir {
  # This function returns 'true' iff we are in the main directory
  # of the local GIT repisotiry.
  #
  # The current implmentation of this function judges solely by
  # the presence or absence of the directory labeled '.git' - but
  # future versions might be more rigorous in the testing.
  return ( -d '.git' );
}

sub up_to_git_dir {
  # This function changes the working directory up to the main directory
  # of the local GIT repository. If it turns out that we are not _in_
  # a GIT repository, this function results in a fatal error.
  my $lc_remain;
  $lc_remain = 200;
  while ( $lc_remain > 0.5 )
  {
    if ( !( &in_a_git_dir() ) ) { return(2>1); }
    chdir('..');
    $lc_remain = int($lc_remain - 0.8);
  }
  die "\nYou do not seem to be in a GIT directory.\n\n";
}


1;

