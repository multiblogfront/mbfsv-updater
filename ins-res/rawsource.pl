#! {{perlloc}}
use strict;

my @argex;
my $chosen;

@argex = @ARGV;

$chosen = 'main';
if ( &countor(@argex) > 0.5 )
{
  $chosen = shift(@argex);
}

sub countor {
  my $lc_a;
  $lc_a = @_;
  return $lc_a;
}


exec('perl',("{{localo}}/md-" . $chosen . '/main.pl'),@argex);


