#!/bin/perl
#
# get the source file
# read the database
sub print_types;

my $database_file="raw_ids.db";
my $source_file=$ARGV[0];
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

if ($source_file eq "" ) {
    die "usage: approve.pl <source_file> <dest_file>";
}

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
    #printf "#define $name 0x%08xUL /* $type - $disposition */\n", $number;
}
close($database);

# read the source
open(my $source, "<", $source_file) or die "Can't open $source_file: $!";
$type="";
$proposal="";
$skip=0;
while (<$source>) {
    chomp;   # clear out new line 
    next if /^$/; # skip blank line 
    if ($skip < 2 ) { # skip the first 2 lines
	$skip = $skip + 1;
	next;
    }
    @db = split(" ");
    if ($db[0] eq "This") { # end of defines result
	last;
    }
    if ($db[0] ne "#define") { # lines without a #define are a new type 
	my $proposed_type=lc $_;
	$proposed_type =~ s/ /_/g;
	$proposed_type =~ s/:$//;
	if (!exists $types{$proposed_type} ) {
	    printf "unknown type: $db[0]\n";
	    print_types();
	    die "unknown type: $db[0]\n";
	}
	$type = $proposed_type;
        $source_type_order=$source_type_order." ".$type;
	printf "    Type = $type\n";
	next;
    }
    if ($type eq "") { # if we haven't set a type, then error 
	die "No type specified";
    }
    $name=$db[1];
    $number=hex($db[2]);
    printf "        processing $name = 0x%08x (%d) (type=$type)",$number,$number;
    # see if the proposed number conflicts. If it does pick a new one
    $index=$type."_".$number;
    #if ($number == 0) {
    #	printf "\n";
    #	die "invalid result file, no allocated number";
    #}
    if (!exists $database_name{$index}) {
	printf "\n";
	die "proposal has not been allocated";
    }
    if ($database_name{$index} ne $name) {
	printf "\n";
	die "$name != $database_name{$index} inconsistent database/proposal result";
    }
    if ($database_disposition{$index} ne "proposed") {
	printf "\n";
	die " entry is not in proposed state (disposition = $database_disposition{$index})";
    }
    printf " proposed -> approved\n";
    $database_disposition{$index} = "approved";
}

#output the new database
open(my $database, ">", $database_file) or die "Can't write $database_file: $!";
for $type (sort keys %types) {
     for (sort split(" ",$types{$type}) ) {
	$index=$type."_".$_;
	printf $database "$database_name{$index},0x%08x,$type,$database_disposition{$index}\n",$_;
      }
}
close($database);

sub print_types
{
   print "Valid Type:\n";
   for $type (sort keys %types) {
	print "  $type\n";
   }
}

