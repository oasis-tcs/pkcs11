#!/bin/perl
#
# get the source file
# read the database
use File::Basename;
sub find_number;
sub print_types;

my $database_file="raw_ids.db";
my $source_file=$ARGV[0];
my $dest_file=$ARGV[1];
glob %types = ();
glob %database_name = ();
glob %database_index = ();
glob %database_number = ();
glob %database_type = ();
glob %database_disposition = ();
glob %types_max = ();
glob %types_bits = ();
my %source_types = ();
my $source_type_order = "";
my %source_max_len = ();
my %conflict_names = ();
my %conflict_old_number = ();
my %conflict_new_number = ();

if ($source_file eq "") {
    die "usage: process_proposal.pl <source_file> [<dest_file>]";
}

if ($dest_file eq "") {
    $dest_file = basename($source_file,".prop").".result";
}
print "source=$source_file dest=$dest_file\n";

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
    $database_index{$name} = $index;
    $database_number{$index} = $number;
    $database_type{$index} = $type;
    $database_disposition{$index} = $disposition;
    #printf "#define $name 0x%08xUL /* $type - $disposition */\n", $number;
}
close($database);

# read the source
open(my $source, "<", $source_file) or die "Can't open $source_file: $!";
$type="";
$proposal="";
while (<$source>) {
    chomp;   # clear out new line 
    next if /^$/; # skip blank line 
    if ($proposal eq "") { # first line is the proposal name 
	$proposal = $_;
	print "Proposal is \"$proposal\"\n";
	next;
    }
    @db = split(" ");
    if ($db[0] ne "#define") { # lines without a #define are a new type 
        my $new = 0;
	my $proposed_type=lc $_;

        if ( lc $db[0] eq "new") {
	    $proposed_type =~ s/new //;
	    $new = 1;
 	}
	$proposed_type =~ s/ /_/g;
	$proposed_type =~ s/:$//;
	if (!$new && !exists $types{$proposed_type} ) {
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
    printf "        processing $name = 0x%08x (%d) (type=$type)\n",$number,$number;
    # first see if the name already exists in the database.
    if (exists $database_index{$name}) {
	$index = $database_index{$name};
	# if the types mismatch blow up.
	if ($type ne $database_type{$index}) {
		printf "		$type doesn't match type for $name\n";
		die "Type missmatch $type, $datbase_type{$index} for $name\n";
	}
	#if the numbers mismatch, treat it as a conflict or 'new' allocation
	if ($number == $database_number{$index}) {
	    printf "		$name already defined\n";
	} else {
	    printf "		$name already defined, using old value 0x%08x\n"		,$database_number{$index};
	    $conflict_name{$type} = $conflict_name{$type}." ".$name;
	    $conflict_old_number{$name} = $number;
	    $number = $database_number{$index};
	    $conflict_new_number{$name} = $number;
	}
	$source_types{$type}=$source_types{$type}." ".$number;
	$source_name{$index} = $name;
	if ($source_max_len{$type} < length $name) {
	    $source_max_len{$type} = length $name;
	}
	next;
    }
    # see if the proposed number conflicts. If it does pick a new one
    $index=$type."_".$number;
    if (exists $database_name{$index} or $number == 0) {
	$conflict_name{$type}=$conflict_name{$type}." ".$name;
	$conflict_old_number{$name}=$number;
    	$number = find_number($type);
	$conflict_new_number{$name}=$number;
	if ($conflict_old_number{$name} == 0) {
     	    printf "            allocating new value is 0x%08x\n",$number;
	} else {
     	    printf "            conflicts with $database_name{$index}, new value is 0x%08x\n",$number;
	}
    }
    $index=$type."_".$number;
    $source_types{$type}=$source_types{$type}." ".$number;
    $source_name{$index} = $name;
    if ($source_max_len{$type} < length $name) {
	$source_max_len{$type} = length $name;
    }
    $types{$type}=$types{$type}." ".$number;
    $database_name{$index} = $name;
    $database_disposition{$index} = "proposed";
}

# output results
# first the message to the user.
open(my $DEST, ">", $dest_file) or die "Can't write $dest_file: $!";
printf $DEST "In accordance to our standing rules, the following identifiers have been\nallocated for your proposal \"$proposal\".\n";

for $type (split(" ",$source_type_order)) {
     my $print_type =ucfirst($type);
     $print_type =~ s/_/ /g;
     printf $DEST "\n%s:\n\n", $print_type;
     for (split(" ",$source_types{$type}) ) {
	$index=$type."_".$_;
	$len = $source_max_len{$type} - length $source_name{$index};
	printf $DEST " #define %*s 0x%08xUL\n",-$source_max_len{$type},
		$source_name{$index},$_;
      }
}

if (keys %conflict_name eq () ) {
    printf $DEST "\nThis represents the same values from your original proposal.\n";
} else {
    printf $DEST "\nThis represents the following changes to your original proposal:\n";
    for $type (keys %conflict_name) {
    	for (split(" ",$conflict_name{$type}) ) {
	    $old_number = $conflict_old_number{$_};
	    $new_number = $conflict_new_number{$_};
	    $index=$type."_".$old_number;
	    if ($old_number == 0) {
		printf $DEST "    $_ was allocated 0x%x because no number was proposed\n", $new_number;
	    } else {
		printf $DEST "    $_ was changed to 0x%x because the proposed 0x%x\n", $new_number, $old_number;
		printf $DEST "     conflicted with $database_name{$index}\n";
	    }
	}
	printf $DEST "\nPlease update your spec before sending it to ballot.\n";
    }
} 
close($DEST);

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

sub isflag
{
  my ($type) = @_;
  return substr($type,-6) eq "_flags";
}

sub find_number
{
  my ($type) = @_;
  if (!isflag($type)) {
      $types_max{$type}++;
      return $types_max{$type};
  }
  for ($i=1; $i < 32; $i++) {
     $bit = 1 << $i;
     next if ($types_bits{$type} & $bit);
     $types_bits{$type} |= $bit;
     return $bit;
  }
  die "No flags left in type $type";
}

