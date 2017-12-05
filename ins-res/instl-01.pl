use strict;
use Cwd 'abs_path';


my $projdir;
my $perlloc;
my $thecont;
my @contmulti;
my $conteach;
my $hme;
my $destdir;


$hme = $ENV{'HOME'};
$destdir = $hme . '/bin';



$projdir = abs_path('.');

system("echo","Our Dir: " . $projdir);

$perlloc = `which perl`; chomp($perlloc);

system('mkdir -p mbfsv-build');
system('rm -rf mbfsv-build/tmp');
system('mkdir -p mbfsv-build/tmp');



$thecont = `cat ins-res/rawsource.pl`;
$thecont = 'xx}}' . $thecont;
@contmulti = split(quotemeta('{{'),$thecont);


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


open TAK, "| cat > mbfsv-build/tmp/mbfsv-updater";
foreach $conteach (@contmulti)
{
  my $lc_pre;
  my $lc_post;
  ($lc_pre,$lc_post) = split(quotemeta('}}'),$conteach,2);
  &zango($lc_pre);
  print TAK $lc_post;
}
close TAK;
#system("echo","\n"); system('cat mbfsv-build/tmp/mbfsv-updater'); system("echo","\n");
system('perl -c mbfsv-build/tmp/mbfsv-updater');

sub dqprinto {
  print TAK $_[0];
}

sub zango {
  my $lc_pre;
  $lc_pre = $_[0];

  if ( $lc_pre eq 'xx' ) { return; }

  if ( $lc_pre eq 'perlloc' )
  {
    print TAK $perlloc;
    return;
  }

  if ( $lc_pre eq 'localo' )
  {
    &dqprinto($projdir);
    return;
  }

  die "\nNO SUCH ITEM: $lc_pre:\n\n";
}


# Now we continue only if there be a difference between
# the new wrapper script and the old one:
{
  my $lc_cm;
  my $lc_df;
  $lc_df = 'xx';
  $lc_cm = 'diff ' . &bsc($destdir . '/mbfsv-updater') . ' mbfsv-build/tmp/mbfsv-updater';
  if ( -f ($destdir . '/mbfsv-updater') ) { $lc_df = `$lc_cm`; }
  if ( $lc_df eq '' )
  {
    system('echo','Wrapper Script Installation Unnecessary - already installed:');
    exit(0);
  }
}


system('echo','WRAPPER SCRIPT READY TO INSTALL:');
system('cp','mbfsv-build/tmp/mbfsv-updater',($destdir . '/.'));
system('chmod','755',($destdir . '/mbfsv-updater'));





