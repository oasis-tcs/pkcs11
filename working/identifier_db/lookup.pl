#!/bin/perl
#
# get the source file
# read the database
sub find_number;
sub print_types;

my $database_file="raw_ids.db";
glob %type_list = ();
glob %disposition_list = ();
glob %database_index = ();
glob %database_name = ();
glob %database_number = ();
glob %database_disposition = ();
glob %database_type = ();

glob $search_name=$ARGV[0];

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
    $database_index{$name} = ${index};
    $database_name{$index} = $name;
    $database_disposition{$index} = $disposition;
    $database_type{$index} = ${type};
    $database_number{$index} = ${number};
    $disposition_list{$disposition}=$disposition_list{$disposition}." ".$index;
    $type_list{$type}=$type_list{$type}." ".$index;
    #printf "#define $name 0x%08xUL /* $type - $disposition */\n", $number;
}
close($database);

my $found=0;
if (exists $database_index{$search_name}) {
    print_entry($database_index{$search_name});
    $found=1;
}
if (exists $type_list{$search_name}) {
    for $index ( sort split(" ",$type_list{$search_name}) ) {
	print_entry($index);
    }
    $found=1;
}
if (exists $disposition_list{$search_name}) {
    for $index ( sort split(" ",$disposition_list{$search_name}) ) {
	print_entry($index);
    }
    $found=1;
}

# lookup names by value
$val=hex($search_name);
$test=$search_name;
if (($val != 0) or ($test =~ /^\s*(0x)?0+\s*$/)) {
    for $i (keys %type_list) {
        $index=$i."_".$val;
        if (exists $database_name{$index}) {
            print_entry($index);
            $found=1;
        }
    }
}

if ($search_name eq "") {
    print "./lookup.pl identifier\n";
    print "  idenifier could be a \n";
    print "   PKCS #11 identifier\n";
    print "   a number (hex value)\n";
    print "   disposition:";
    for $i (keys %disposition_list) {
        print " $i";
    }
    print "\n";
    print "   or a type:";
    for $i (keys %type_list) {
        print " $i";
    }
    print "\n";
    exit 1;
} 

if ($found == 0) {
    print "Identifer '$search_name' not found\n";
    exit 1;
}
exit 0;

sub print_entry
{
   my ($index) = @_;
   printf "#define %-20s 0x%08xUL /* %s - %s */\n", 
        $database_name{$index}, $database_number{$index}, $database_type{$index}
, $database_disposition{$index};
}


