#!/bin/perl
#
# get the source file
# read the database
sub print_types;
sub isflag;

my $database_file="raw_ids.db";
my $alias_file="aliases.db";
my $default_header = "../3-00-wd-01/pkcs11t.h";
glob %types = ();
glob %database_name = ();
glob %database_number = ();
glob %database_disposition = ();
glob %header_number = ();
glob %header_found = ();
glob %header_present = ();
glob %aliases= ();
glob %types_max = ();
glob %types_bits = ();
glob $verifyHeaderFull=0;


if ($ARGV[0] eq "help") {
   print "usage: verify.pl [dump|types|{type}|{disposition}|header [full] {path}|help]\n";
   print "  no args: look for inconsistances within the database\n";
   print "  dump: dump the full database as #defines\n";
   print "  types: list all the current types in the database\n";
   print "  {type}: supply a type value. All entries of type {type} are printed\n";
   print "  {disposition}: supply a disposition value. All entries of disposition\n";
   print "                {disposition} are printed\n";
   print "  header: verify the header against the database.\n";
   print "          If full is specified, then expect proposed entries to be\n";
   print "           the database. If it's not specified then proposed entries\n";
   print "           are not expected to be in the database.\n";
   print "          If {path} is not suppled, $default_header will be read.\n";
   exit 0;
}

if ($ARGV[0] eq "header") {
    my $header_file = $ARGV[1];

    if ($header_file eq "full") {
	$header_file = $ARGV[2];
        $verifyHeaderFull = 1;
    }
    if ($header_file eq "") {
	$header_file =  $default_header;
    }
    
    # read the source
    open(my $header, "<", $header_file) or die "Can't open $header_file: $!";
    while (<$header>) {
	chomp;   # clear out new line 
	next if /^$/; # skip blank line 
	@db = split(" ");
	if ($db[0] ne "#define") { # only interested in #define lines
	    next;
	}
	$name=$db[1];
	$number=hex($db[2]);
        # Some attributes have the CKF_ARRAY_ATTRIBUTE flag
	if (($number == 0) and (substr($db[2],1,19) eq "CKF_ARRAY_ATTRIBUTE")) {
	    $number=hex(substr($db[2],21));
	}
        # handle a substitution 
	if (($number == 0xc) and (substr($db[2],0,2) eq "CK")) {
	    $number = $header_number{$db[2]};
	}
	$header_number{$name} = $number;
	$header_found{$name} = 0;
	$header_present{$name} = 1;
        $header_line{$name} = $_;
	# give VENDER_DEFINED a pass 
	if (($number == 0x80000000) && (substr($name,4) eq "VENDOR_DEFINED")) {
	    $header_found{$name} = 1;
	}
    }
    close ($header);

    #read in aliases
    open(my $alias, "<", $alias_file);
    while (<$alias>) {
	chomp;   # clear out new line 
	next if /^$/; # skip blank line 
	@db = split(" ");
	$aliases{$db[0]} = $db[1];
    }
    close($alias);
    print "Defines missing from header or mismatched\n";
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
    if ($ARGV[0] eq "header") {
	$flag_missing = 0;
        if (($verifyHeaderFull == 1) or ($disposition ne "proposed")) {
	    $flag_missing = 1;
        }
        if ($header_present{$name} == 1) {
	    $header_found{$name} = 1;
        }

	if (($flag_missing == 1) and ($header_present{$name} == 0)) {
	    
	    printf " missing: #define %-20s 0x%08xUL /*$type - $disposition*/\n",
	      $name, $number;
	    next;
        }
	if ($flag_missing == 0) {
	    if ($header_present{$name} == 1) {
		printf " proposed in header: $header_line{$name}\n";
		printf "  #define %-20s 0x%08xUL /*$type - $disposition*/\n",
		  $name, $number;
	    }
	    next;
        }
        if ($header_number{$name} != $number) {
	    printf " mismatch: $name, header: $header_line{$name}\n";
            printf "  #define %-20s 0x%08xUL /* $type - $disposition db */\n",
	           $name, $number;
        }
        next;
    }
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

if ($ARGV[0] eq "header") {
    print_not_tracked();
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

sub print_not_tracked
{
   print "Defines not tracked in the database:\n";
   for $name (sort keys %header_found) {
	if ($header_found{$name} == 0 ) {
	    if ($header_found{$aliases{$name}} == 1) {
		next;
	    }
	    printf(" $header_line{$name}\n");
	    #printf(" #define %-20s 0x%08xUL\n",$name,$header_number{$name});
        }
   }
}
