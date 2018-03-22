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

if (exists $database_index{$search_name}) {
    print_entry($database_index{$search_name});
}
if (exists $type_list{$search_name}) {
    for $index ( sort split(" ",$type_list{$search_name}) ) {
	print_entry($index);
    }
}
if (exists $disposition_list{$search_name}) {
    for $index ( sort split(" ",$disposition_list{$search_name}) ) {
	print_entry($index);
    }
}

sub print_entry
{
   my ($index) = @_;
   printf "#define %-20s 0x%08xUL /* %s - %s */\n", 
        $database_name{$index}, $database_number{$index}, $database_type{$index}
, $database_disposition{$index};
}


