#!/bin/perl
#
# get the source file
# read the database
sub print_types;
sub isflag;

my $database_file="raw_ids.db";
glob %types = ();
glob %database_name = ();
glob %database_number = ();
glob %database_disposition = ();
glob %types_max = ();
glob %types_bits = ();

open(my $database, "<", $database_file) or die "Can't open $database_file: $!";
while (<$database>){
    chomp;
    @db = split(",");
    $name = $db[0];
    $number_string = $db[1];
    $type = $db[2];
    $disposition = $db[3];
    $number=hex($number_string);
#   if ($number eq 0) {
#	printf "invalid db entry: number is zero\n >> $_\n";
#	next;
#   }
    if (isflag($type)) {
	if ($type_bits{$type} & $number) {
	    printf("invalid db entry: overlapping flags: $name, 0x%08x\n >>$_\n",$number);
	    next;
	}
    }
    my $index=$type."_".$number;
    if (exists $database_name{$index}) {
	printf "invalid db entry: duplicate value for\n";
	printf "$database_name{$index} and $name\n >>$_\n";
	next;
    }
    if (exists $database_number{$name}) {
	printf "invalid db entry: duplicate name: $name \n";
	printf "0x%08x and 0x%08x\n >>$_\n",$databas_number{$name},$number;
	next;
    }
    $types{$type}=$types{$type}." ".$number;
    if ($types_max{$type} < $number) {
	$types_max{$type} = $number;
    }
    $types_bits{$type} |= $number;
    $database_name{$index} = $name;
    $database_disposition{$index} = $disposition;
    $datase_number{$name} = $number;
    if ($ARGV[0] eq "dump") {
        printf "#define %-20s 0x%08xUL /* $type - $disposition */\n", $name,$number;
    }
    if ($ARGV[0] eq $disposition) {
        printf "#define %-20s 0x%08xUL /* $type */\n", $name,$number;
    }
    if ($ARGV[0] eq $type) {
        printf "#define %-20s 0x%08xUL /* $disposition */\n", $name, $number;
    }
}
close($database);

# output results
#
if ($ARGV[0] eq "dump" or $ARGV[0] eq "types") {
    print_types();
}

sub print_types
{
   print "Valid Type:\n";
   for $type (sort keys %types) {
	print "  $type";
	if (isflag($type)) {
	    printf " flagBits=0x%08x open=0x%08x\n",$types_bits{$type},
				(~$types_bits{$type} & 0xffffffff);
	} else {
	    printf " nextValue=0x%08x\n",$types_max{$type}+1;
	}
    }
}

sub isflag
{
  my ($type) = @_;
  return substr($type,-6) eq "_flags";
}


