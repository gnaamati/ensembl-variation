use lib 't';

use strict;
use warnings;

BEGIN { $| = 1;
	use Test;
	plan tests => 3;
}


use TestUtils qw ( debug test_getter_setter count_rows);


use MultiTestDB;
use Bio::EnsEMBL::Variation::VariationFeature;
use Data::Dumper;

our $verbose = 1;

my $multi = MultiTestDB->new();

my $vdb = $multi->get_DBAdaptor('variation');
my $db = $multi->get_DBAdaptor('core');

$vdb->dnadb($db);

my $ldfca = $vdb->get_LDFeatureContainerAdaptor();
my $ldContainer;

ok($ldfca && $ldfca->isa('Bio::EnsEMBL::Variation::DBSQL::LDFeatureContainerAdaptor'));

my $sa = $db->get_SliceAdaptor();

my $slice = $sa->fetch_by_region('chromosome','7');

$ldContainer = $ldfca->fetch_by_Slice($slice);

my $ld_values;
print_container($ldContainer);
$ld_values = count_ld_values($ldContainer);
ok($ld_values == 2);

my $vfa = $vdb->get_VariationFeatureAdaptor();

my $vf = $vfa->fetch_by_dbID(153);

$ldContainer = $ldfca->fetch_by_VariationFeature($vf);
print_container($ldContainer);
$ld_values = count_ld_values($ldContainer);
ok($ld_values == 2);

sub count_ld_values{
    my $container = shift;
    my $ld_values = 0;
    foreach my $key (keys %{$container->{'ldContainer'}}) {
	$ld_values += keys %{$container->{'ldContainer'}->{$key}};
    }
   
    return $ld_values;
}

sub print_container {
  my $container = shift;
  return if(!$verbose);
 
  print STDERR "\nContainer name: ", $container->{'name'},"\n";
  foreach my $key (keys %{$container->{'ldContainer'}}) {
      my ($key1,$key2) = split /-/,$key;
      print STDERR "LD values for ", $container->{'variationFeatures'}->{$key1}->variation_name, " and ",$container->{'variationFeatures'}->{$key2}->variation_name;
      foreach my $population (keys %{$container->{'ldContainer'}->{$key}}){
	  print STDERR " in population $population:\n Dprime - ",$container->{'ldContainer'}->{$key}->{$population}->{'Dprime'}, "\n r2: ", $container->{'ldContainer'}->{$key}->{$population}->{'r2'}, "\n snp_distance: ",$container->{'ldContainer'}->{$key}->{$population}->{'snp_distance_count'}, " \nsample count ",$container->{'ldContainer'}->{$key}->{$population}->{'sample_count'},"\n";
      }
  }

}
