# USAGE:
#   perl <this-script> <repo> <branch>
# FUNCTION:
#   Retrieves the laest version of "special-versions.dat" from the repo.
#   All other files (if any) in the same directory as this script are
#   tools used by this script.
use strict;
my $hme;
my $tmpdir;
my $tmpprefix = 'tmp_shallow_git';

$hme = $ENV{'HOME'};
$tmpdir = ( $hme . '/tmp' );
system('mkdir','-p',$tmpdir);



sub bsc {
  my $lc_ret;
  my $lc_src;
  my $lc_chr;
  $lc_src = scalar reverse $_[0];
  $lc_ret = "\'";
  while ( $lc_src ne "" )
  {
    $lc_chr = chop($lc_src);
    if ( $lc_chr eq "\'" ) { $lc_chr = "\'\"\'\"\'"; }
    $lc_ret .= $lc_chr;
  }
  $lc_ret .= "\'";
  return $lc_ret;
}

# Now we clean out any gunk that shouldn't be there.
# Basically, any temporary program left over an hour
# by a script like this one.
{
  my $lc_a;
  my $lc_b;
  my @lc_c;
  my $lc_d;
  my @lc_e;
  $lc_a = '( cd ' . &bsc($tmpdir) . ' && ls -1d ' . &bsc($tmpprefix) . '-* )';
  $lc_a .= ' 2> /dev/null';
  $lc_b = `$lc_a`;
  @lc_c = split(/\n/,$lc_b);
  foreach $lc_d (@lc_c)
  {
    @lc_e = split(quotemeta('-'),$lc_d);
    if ( $lc_e[0] eq $tmpprefix )
    {
      if ( ( $lc_e[1] + ( 60 * 60 ) ) < time() )
      {
        system('rm','-rf',($tmpprefix . '/' . $lc_d));
      }
    }
  }
}



