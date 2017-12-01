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
my @rmnargs = ();

# Identify the branch:
my $brnc_set = 0;
my $brnc_at;

# Identify the repo
my $repo_set = 0;
my $repo_at;

my $my_tmp_dir_lc;
my $my_tmp_dir_gl;

# ################################# #
# ##  END VARIABLE DECLARATIONS  ## #
# ################################# #

$hme = $ENV{'HOME'};
$tmpdir = ( $hme . '/tmp' );
system('mkdir','-p',$tmpdir);

sub goodry {
  my $lc_a;
  $lc_a = @_;
  return ( $lc_a > 0.5 );
}

sub getargo {
  my $lc_a;
  $lc_a = '';
  if ( &goodry(@rmnargs) ) { $lc_a = shift(@rmnargs); }
  return $lc_a;
}

@rmnargs = @ARGV;
while ( &goodry(@rmnargs) ) { &eacharg(); }
sub eacharg {
  my $lc_opto;
  $lc_opto = &getargo();

  if ( $lc_opto = '-brnc' )
  {
    $brnc_at = &getargo();
    if ( $brnc_at ne '' ) { $brnc_set = 10; }
    return;
  }

  if ( $lc_opto eq '-repo' )
  {
    $repo_at = &getargo();
    if ( $repo_at ne '' ) { $repo_set = 10; }
    return;
  }

  die ("\nNO SUCH OPTION: " . $lc_opto . ":\n\n");
}


# Now we identify the repo if the command-line hasnt:
if ( $repo_set < 5 )
{
  $repo_at = `git remote get-url origin`;
  chomp($repo_at);
  if ( $repo_at ne '' ) { $repo_set = 10; }
}


# Now we identify the branch if the command-line hasnt:
if ( $brnc_set < 5 )
{
  $brnc_at = `git rev-parse --abbrev-ref HEAD`;
  chomp($brnc_at);
  if ( $brnc_at ne '' ) { $brnc_set = 10; }
}


# Do not proceed any further if any of the required
# parameters wasn't set:
if ( $repo_set < 5 ) { die "\nNo remote repository URL identified.\n\n"; }
if ( $brnc_set < 5 ) { die "\nNo rempository branch identified.\n\n"; }

# Output the parameter info
print('info:repo:' . &aline($repo_at) . "\n");
print('info:brnc:' . &aline($brnc_at) . "\n");

sub aline {
  # Currently this function just returns it's one argument - but
  # eventually, it will be re-implemented to break that argument
  # into a form that is guaranteed to fit neatly into the line
  # structure of the output.
  return $_[0];
}


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
# Basically, any temporary program left over six hours
# by a script like this one.
#   This part is to be referred to as the "retero
# cleanup".
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
      if ( ( $lc_e[1] + ( 6 * 60 * 60 ) ) < time() )
      {
        system('rm','-rf',($tmpdir . '/' . $lc_d));
      }
    }
  }
}

$my_tmp_dir_lc = $tmpprefix . '-' . time() . '-' . $$;
$my_tmp_dir_gl = $tmpdir . '/' . $my_tmp_dir_lc;


# Now we do the cloning.
{
  my $lc_cm;
  $lc_cm = 'git clone ' . &bsc($repo_at) . ' ' . &bsc($my_tmp_dir_gl);
  $lc_cm .= ' --depth 1';
  $lc_cm .= ' -b ' . &bsc($brnc_at);

  # Now we make sure that there will be no clone directory if
  # the operation fails.
  $lc_cm .= ' || rm -rf ' . &bsc($my_tmp_dir_gl);

  # Now we redirect the raw output so as to not confuse things:
  $lc_cm = '( ' . $lc_cm . ' )';
  $lc_cm .= ' > /dev/null 2> /dev/null';

  system($lc_cm);
  #system('echo',("\n" . $lc_cm . "\n"));
}

# We exit the program if the cloning operation failed.
if ( ! ( -d $my_tmp_dir_gl ) )
{
  die '\nCould not obtain the current Special Versions list.\n\n';
}

# Now we do the catting.
{
  my $lc_cm;
  my $lc_raw;
  my @lc_list;
  my $lc_each;
  $lc_cm = 'cat ' . &bsc($my_tmp_dir_gl . '/special-versions.dat');
  $lc_cm .= ' 2> /dev/null';

  $lc_raw = `$lc_cm`;
  @lc_list = split(/\n/,$lc_raw);
  foreach $lc_each (@lc_list)
  {
    if ( $lc_each ne '' ) { print('rcd:' . $lc_each . "\n"); }
  }
  #system('echo',("\n" . $lc_cm . "\n"));
}

# And finally - we identify the current Revision ID of the remote repo.
{
  my $lc_cm;
  my $lc_ret;
  $lc_cm = 'cd ' . &bsc($my_tmp_dir_gl);
  $lc_cm .= ' && git rev-parse HEAD';
  $lc_ret = `$lc_cm`; chomp($lc_ret);
  print('current:' . $lc_ret . "\n");
}

# And now we clean-up. (The retero-cleaning is a plan B, not a plan A.)
print "done:\n";
system('rm','-rf',$my_tmp_dir_gl);


