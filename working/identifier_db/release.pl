#!/bin/perl
#
# get the source file
# read the database
sub print_types;

my $database_file="raw_ids.db";
glob %types = ();
glob %database_name = ();
glob %database_number = ();
glob %database_disposition = ();
glob %types_max = ();
glob %types_bits = ();
my %source_types = ();
my $source_type_order = "";
my %source_max_len = ();
my %conflict_names = ();
my %conflict_old_number = ();
my %conflict_new_number = ();

open(my $database, "<", $database_file) or die "Can't open $database_file: $!";
while (<$database>){
    chomp;
    @db = split(",");
    $name = $db[0];
    $number_string = $db[1];
    $type = $db[2];
    $disposition = $db[3];
    $number=hex($number_string);
    #if ($number eq 0) die "invalid db entry\n >> $_";
    $index=$type."_".$number;
    $types{$type}=$types{$type}." ".$number;
    if ($types_max{$type} < $number) {
	$types_max{$type} = $number;
    }
    $types_bits{$type} |= $number;
    $database_name{$index} = $name;
    $database_disposition{$index} = $disposition;
    if ($disposition eq "proposed") {
        printf "warning proposed identifier: $name 0x%08xUL ($type)\n", $number;
    } 
    if ($disposition eq "approved") {
        printf "moving $name 0x%08xUL ($type) from approved->spec\n", $number;
        $database_disposition{$index} = "spec";
    }
}
close($database);

#output the new database
open(my $database, ">", $database_file) or die "Can't write $database_file: $!";
for $type (sort keys %types) {
     for (sort split(" ",$types{$type}) ) {
	$index=$type."_".$_;
	printf $database "$database_name{$index},0x%08x,$type,$database_disposition{$index}\n",$_;
      }
}
close($database);
