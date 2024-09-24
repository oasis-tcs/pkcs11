#!/bin/perl
#
# get the source file
# read the database
use File::Basename;
use File::Spec;
sub process_header;

glob $print_doc_tables=0;
glob $print_doc_defines=0;
glob $print_doc_structs=0;
glob $print_doc_typedefs=0;
glob $print_header_defines=0;
glob $print_header_structs=0;
glob $print_header_typedefs=0;
glob $print_diff_defines=0;
glob $print_diff_typedefs=0;
glob $print_diff_struct=0;
glob $verbose=0;
glob $verbose2=0;

glob $table_number=0;
glob $current_row_count=0;
glob $current_column_count=0;
glob $inTable=0;
glob $inMultiline=0;
glob $inStruct=0;
glob $expectStruct=0;
glob $tableHeaderNotStarted=0;
glob $typedef_count=0;
glob $header_typedef_count=0;
glob %typedef_struct_name = ();
glob %typedef_struct_count = ();
glob %typedef_present=();
glob %struct_value = ();
glob %table_entry = ();
glob %table_col_count = ();
glob %header_typedef_struct_name = ();
glob %header_typedef_struct_count = ();
glob %header_struct_value = ();
glob %header_typedef_present = ();
glob @table_name = ();
glob @table_count = ();
glob @table_index = ();
glob @typedef_names = ();
glob @header_typedef_names = ();
glob $idspec="[a-zA-Z]\\w*";

glob $doc_file="";
glob $header_file="";
glob $Command="./parse_doc.pl";  # get from the evironment?

foreach (@ARGV) {
    $arg=$_;
    if ($arg eq "table") {
        $print_doc_tables=1;
        next;
    }
    if ($arg eq "defines") {
        $print_doc_defines=1;
        $print_header_defines=1;
        next;
    } 
    if ($arg eq "structs") {
        $print_doc_structs=1;
        $print_header_structs=1;
        next;
    } 
    if ($arg eq "typedefs") {
        $print_doc_typedefs=1;
        $print_header_typedefs=1;
        next;
    } 
    if ($arg eq "doc_defines") {
        $print_doc_defines=1;
        next;
    } 
    if ($arg eq "doc_structs") {
        $print_doc_structs=1;
        next;
    } 
    if ($arg eq "doc_typedefs") {
        $print_doc_typedefs=1;
        next;
    } 
    if ($arg eq "header_defines") {
        $print_header_defines=1;
        next;
    } 
    if ($arg eq "header_structs") {
        $print_header_structs=1;
        next;
    } 
    if ($arg eq "header_typedefs") {
        $print_header_typedefs=1;
        next;
    } 
    if ($arg eq "diff_defines") {
        $print_diff_defines=1;
        printf("diff_defines, setting print_diff_defines=$print_diff_defines\n");
        next;
    } 
    if ($arg eq "diff_structs") {
        $print_diff_structs=1;
        next;
    } 
    if ($arg eq "diff_typedefs") {
        $print_diff_typedefs=1;
        next;
    } 
    if ($arg eq "doc_all") {
        $print_doc_tables=1;
        $print_doc_defines=1;
        $print_doc_structs=1;
        $print_doc_typedefs=1;
        next;
    }
    if ($arg eq "header_all") {
        $print_header_defines=1;
        $print_header_structs=1;
        $print_header_typedefs=1;
        next;
    }
    if ($arg eq "diff_all") {
        $print_diff_defines=1;
        $print_diff_typedefs=1;
        $print_diff_struct=1;
        next;
    }
    if ($arg eq "all") {
        $print_doc_tables=1;
        $print_doc_defines=1;
        $print_doc_structs=1;
        $print_doc_typedefs=1;
        $print_header_defines=1;
        $print_header_structs=1;
        $print_header_typedefs=1;
        $print_diff_defines=1;
        $print_diff_typedefs=1;
        $print_diff_struct=1;
        next;
    }
    if ($arg eq "verbose") {
        $verbose=1;
        next;
    }
    if ($arg eq "verbose2") {
        $verbose=1;
        $verbose2=1;
        next;
    }
    if ($doc_file eq "")  {
        $doc_file=$arg;
        next;
    }
    if ($header_file eq "") {
        $header_file=$arg;
        next;
    }
    printf "-- unknown command %s doc_file=%s header_file=%s\n", $arg, $doc_file, $header_file;
    usage();
    exit;
}

# default to diff_all
if (($print_doc_defines == 0) &&
    ($print_doc_structs == 0) &&
    ($print_doc_typedefs == 0) &&
    ($print_doc_tables == 0) &&
    ($print_header_defines == 0) &&
    ($print_header_structs == 0) &&
    ($print_header_typedefs == 0) &&
    ($print_diff_defines == 0) &&
    ($print_diff_typedefs == 0) &&
    ($print_diff_struct == 0)) {
        $print_diff_defines=1;
        $print_diff_typedefs=1;
        $print_diff_struct=1;
}

$need_header=0;
$need_doc=0;
if (($print_doc_defines == 1) ||
    ($print_doc_structs == 1) ||
    ($print_doc_typedefs == 1) ||
    ($print_doc_tables == 1) ||
    ($print_diff_defines == 1) ||
    ($print_diff_typedefs == 1) ||
    ($print_diff_struct == 1)) {
    $need_doc=1;
}

if (($print_header_defines == 1) ||
    ($print_header_structs == 1) ||
    ($print_header_typedefs == 1) ||
    ($print_diff_defines == 1) ||
    ($print_diff_typedefs == 1) ||
    ($print_diff_struct == 1)) {
    $need_header=1;
}


if ($need_doc==0 && $need_header==1 &&  $header_file eq "") {
    $header_file=$doc_file;
    $doc_file="";
}

if ($need_doc==1 && $doc_file eq "") {
    foreach $file (<./pkcs11-spec-v*.txt>) {
        if ($doc_file eq "") {
            $doc_file=$file;
        } else {
            if ($doc_file lt $file) {
                $doc_file=$file;
            }
        }
    }
    if ($doc_file eq "") {
        print "No pkcs11-spec-v*.txt file found, and no doc file supplied on command line\n";
        usage();
        exit;
    }
}

if ($need_header==1 &&  $header_file eq "") {
    $header_file="../headers/pkcs11t.h";
}

if ($need_header==1) {
    my ($header_name, $header_path) = fileparse($header_file);
    my @dirs = File::Spec->splitdir($header_path);
    if ($header_name eq "") {
        $header_name=File::Spec->catfile(@dirs, "pkcs11t.h");
    }
    $function_header_file=File::Spec->catfile(@dirs, "pkcs11.h");
}

if ($verbose == 1) {
    print  "doc_file=$doc_file header_file=$header_file function_header_file=$function_header_file\n";
    print " \$print_doc_defines=$print_doc_defines\n";
    print " \$print_doc_structs=$print_doc_structs\n";
    print " \$print_doc_typedefs=$print_doc_typedefs\n";
    print " \$print_doc_tables= $print_doc_tables\n";
    print " \$print_header_defines=$print_header_defines\n";
    print " \$print_header_structs=$print_header_structs\n";
    print " \$print_header_typedefs=$print_header_typedefs\n";
    print " \$print_diff_defines=$print_diff_defines\n";
    print " \$print_diff_typedefs=$print_diff_typedefs\n";
    print " \$print_diff_struct=$print_diff_struct\n";
}

# read the interesting stuff out of the text document
my $line=0;
if ($doc_file ne "") {
    open(my $doc, "<", $doc_file) or die "Can't open $doc_file: $!";
    while (<$doc>){
        $entry=$_;
        chomp $entry;
        $entry=~s/^\s+|\s+$//;
        # normalize spacing to just one space to aid comparisons
        $entry=~s/\s+/ /g;
        $entry=~s/&gt;/</g;
        $entry=~s/&lt;/>/g;
        $entry=~s/&nbsp;/ /g;
        $entry=~s/&amp;/&/g;
        $line++;
        if ($expectStruct == 1) {
            $expectStruct=0;
            if ($entry eq "\{" ) {
                $inStruct == 1;
                next;
            }
            printf "%s line %d: missing \{ in struct (%s) skipping\n", $doc_file, $line, $struct_name;
            # fall through and see if something else comes up
        }
        if ($inMultiline == 1) {
            $test=$entry;
            if ($entry =~ /^$/) {
                if ($verbose == 1) {
                    printf "%s line %d: missing ';' in typedef '%s'\n",
                           $doc_file, $line, $typedef_names[$typedef_count];
                }
                $typedef_names[$typedef_count]=$typedef_names[$typedef_count].";";
                $inMultiline=0;
                $typedef_count++;
                next;
            }
            $typedef_names[$typedef_count]=$typedef_names[$typedef_count]." ".$entry;
            if ($entry =~ ".*;" ) {
                $inMultiline=0;
                $typedef_count++;
            }
            next;
        }
        if ($inStruct == 1) {
            $entry_index=$struct_name."_".$current_row_count;
            $test=$_;
            if ($test =~ /\}\s+($idspec)/) {
                $typedef_struct_name{$struct_name}=$1;
                $typedef_struct_count{$struct_name}=$current_row_count;
                $inStruct=0;
                $current_row_count=0;
                next;
            }
            # normalize
            $entry=~s/\s+/ /;
            $entry=~s/\/\*.*\*\///g;
            $entry=~s/^\s+|\s+$//;
            $struct_value{$entry_index}=$entry;
            $current_row_count++;
            next;
        }
        if ($inTable == 1) {
            $entry_index=$table_number."_".$current_row_count."_".$current_column_count;
    #printf " handling %d, current_row_count=%d current_column_count=%d entry=%s\n", $table_number, $current_row_count, $current_column_count, $entry;
            $test=$_;
            if ($test =~ /^\S/) {
                # entries with no space at the beginning are continuations of
                # the last entry, unless we are at the start of a new row
                if ($tableHeaderNotStarted == 1) {
                    # continue the table name
                    $table_name[$table_number]=$table_name[$table_number].$entry;
                    next;
                }
                if ($current_column_count != 0) {
                    # continue the last entry
                    $table_entry{$entry_index}=$table_entry{$entry_index}.$entry;
                    next;
                }
    #printf "end table /$_/\n";
                # we are at the end of the table, this is the prose for the next
                # section
                $inTable=0;
                $table_row_count[$table_number]=$current_row_count;
                goto MoreParsing;
            }
            $test=$_;
            if ($test =~ /^\sRefer/) {
                if ($verbose == 1) {
                    printf "%s line %d: inconsistent footnote reference '%s', whould be '- Refer...' after table %d\n",
                           $doc_file, $line, $_, $table_number;
                }
                # Table ends with footnotes...
                $inTable=0;
                $table_row_count[$table_number]=$current_row_count;
                goto MoreParsing;
            }
            $tableHeaderNotStarted=0;
            $test=$_;
            # a black line separates rows
            if ($test =- /^$/) {
    #printf "end row /$_/\n";
                if ($current_column_count != 0) {
                    # there may be multiple blank lines (particularly at the end,
                    # only record the first
                    $current_row_count++;
                    $table_col_count{$table_number."_".$current_row_count}=$current_column_count;
                    $current_column_count=0;
                }
                next;
            }
            $table_entry{$entry_index}=$entry;
    #        printf "index=%s entry=%s\n", $entry_index, $entry;
            $current_column_count++;
            next;
        }
MoreParsing:
        $test=$_;
        if ($test =~ /^\s*Table\s+(\d+)[,:]\s*(.*)/) {
            $table_number=$1;
            $table_name[$table_number]=$2;
            $table_count[$table_number]=0;
            $table_index[$table_number]=$table_number;
            $current_row_count=0;
            $current_column_count=0;
            $inTable=1;
            $tableHeaderNotStarted=1;
            if ($verbose == 1) {
                $test=$_;
                if ($test =~ /^\s*Table\s+(\d+):\s*(.*)/) {
                    printf "%s line %d: inconsistent Table Title(%s) in table %d. Should have a comma rather than a colon\n",
                           $doc_file, $line, $entry, $table_number;
                }
            }
            next;
        }
        $test=$_;
        if ($test =~ /typedef struct ($idspec) \{/) {
            # A PKCS #11 C typedef structure
    #print "in typedefs with \{ entry=$entry, name=$1\n"
            $struct_name=$1;
            $current_row_count=0;
            $inStruct=1;
            next;
        }
        $test=$_;
        if ($test =~ /typedef struct ($idspec)/) {
            # Same as above except the  brackets start on the next line, go find it
            $struct_name=$1;
            $current_row_count=0;
            $expectStruct=1;
            next;
        }
        if ($test =~ /typedef CK_CALLBACK_FUNCTION\(CK_RV, myCallbackType\)/) {
            # skip example
            next;
        }
        if ($test =~ /typedef CK_DECLARE_FUNCTION_POINTER/) {
            # skip example
            next;
        }
        if ($test =~ /typedef CK_CALLBACK_FUNCTION\(($idspec), ($idspec)\)\(/) {
            # handle callbacks multiline
            $typedef_names[$typedef_count]=$entry;
            $inMultiline=1;
            next;
        }
        $test=$_;
        if ($test =~/^· (CKR_$idspec):/) {
            $name=$1;
            $doc_found{$name}=0;
            $doc_present{$name}=1;
            $doc_number{$name}=0;
            next;
        }
        $test=$_;
        if ($test =~ /typedef .*;/) {
            # A naked typedef, record it
            $typedef_names[$typedef_count]=$entry;
            $typedef_count++;
            next;
        }
        $test=$_;
        if ($test =~ /typedef .*/) {
            # Same as above, but the semi colon was just missing
            $typedef_names[$typedef_count]=$entry;
            $inMultiline=1;
            next;
        }
        $test=$_;
         # the following defines are just in the text, not in tables,
         # just scower them out.
        if ($test =~ /(CK[CFGHNOSU]_$idspec)/) {
            $name=$1;
            $doc_found{$name}=0;
            $doc_present{$name}=1;
            $doc_number{$name}=0;
            next;
        }
        if ($test =~/^CK_KEY_TYPE/) {
             # for keytypes, skip C code examples, make sure we have the
             # definition in the text
            next;
        }
        $test=$_;
        if ($test =~ /(CKK_$idspec)/) {
            $name=$1;
            $doc_found{$name}=0;
            $doc_present{$name}=1;
            $doc_number{$name}=0;
            next;
        }
        $test=$_;
        if ($test =~ /(CK_CERTIFICATE_CATEGORY_$idspec)/) {
            $name=$1;
            if (($verbose == 1) && ($doc_present{$name} == 0)) {
                    printf "%s line %d: %s in unlabelled table.\n",
                           $doc_file, $line, $name;
            }
            $doc_found{$name}=0;
            $doc_present{$name}=1;
            $doc_number{$name}=0;
            next;
        }
        $test=$_;
        if ($test =~ /(CK_SECURITY_DOMAIN_$idspec)/) {
            $name=$1;
            if (($verbose == 1) && ($doc_present{$name} == 0)) {
                    printf "%s line %d: %s in unlabelled table.\n",
                           $doc_file, $line, $name;
            }
            $doc_found{$name}=0;
            $doc_present{$name}=1;
            $doc_number{$name}=0;
            next;
        }
    }
    close($doc);
}

# read the same stuff out of the header file
if ($header_file ne "") {
    process_header($header_file, 0);
}

# read the same stuff out of the function header file
#if ($function_header_file ne "") {
#    process_header($function_header_file, 1);
#}

# extract the defines from the tables
foreach (@table_index) {
    $index=$_;
    for my $i (1..($table_row_count[$index]-1)) {
        $entry1=$index."_".$i."_"."0";
        $entry2=$index."_".$i."_"."1";
        $name=get_name($table_entry{$entry1});
        if ($name ne "" ) {
            $doc_found{$name}=0;
            $doc_present{$name}=1;
            $number=get_value($table_entry{$entry2});
            if ($doc_number{$name} == 0) {
                $doc_number{$name}=$number;
                $doc_table_number{$name}=$index;
            } else {
                if ($doc_number{$name} != $number) {
                    printf("%s: identifier %s has inconsistant values 0x%08xUL (Table %d) and 0x%08xUL (Table %d)\n",
                            $doc_file, $name, $header_number{$name},
                            $doc_table_number{$name}, $number, $index);
                }
            }
            next;
        }
        $name=get_name($table_entry{$entry2});
        if ($name ne "" ) {
            if ($doc_present{$name} != 0) {
                $doc_number{$name}= 0;
            }
            $doc_found{$name}=0;
            $doc_present{$name}=1;
        }
    }
}

# build the typedef tables
for my $i (0..($typedef_count-1)) {
    $typedef_present{$typedef_names[$i]}=1;
}
for my $i (0..($header_typedef_count-1)) {
    $header_typedef_present{$header_typedef_names[$i]}=1;
}


if ($print_doc_tables) {
    printf "******************** %s tables **********************\n", $doc_file;
    print_table();
    printf "\n";
}
if ($print_doc_defines) {
    printf "******************** %s defines **********************\n", $doc_file;
    print_doc_defines();
    printf "\n";
}
if ($print_doc_structs) {
    printf "******************** %s structs **********************\n", $doc_file;
    print_structs();
    printf "\n";
}
if ($print_doc_typedefs) {
    printf "******************** %s typedefs **********************\n", $doc_file;
    print_typedefs();
    printf "\n";
}
if ($print_header_defines) {
    printf "******************** %s defines **********************\n", $header_file;
    print_header_defines();
    printf "\n";
}
if ($print_header_structs) {
    printf "******************** %s structs **********************\n", $header_file;
    print_header_structs();
    printf "\n";
}
if ($print_header_typedefs) {
    printf "******************** %s typedefs **********************\n", $header_file;
    print_header_typedefs();
    printf "\n";
}
if ($print_diff_defines) {
    print_diff_defines();
    printf "\n";
}
if ($print_diff_typedefs) {
    print_diff_typedefs();
    printf "\n";
}
if ($print_diff_struct) {
    print_diff_struct();
    printf "\n";
}

sub process_header
{
    my ($l_header_file, $l_verbose)=@_;
    print "Processing header $l_header_file...\n";

    open(my $header, "<", $l_header_file) or die "Can't open $l_header_file: $!";
    while (<$header>) {
        chomp;   # clear out new line 
        $entry=$_;
        # remove comments first
        $entry=~s/\/\*.*\*\///g;
        # strip trailing and leading blanks
        $entry=~s/^\s+|\s+$//;
        # normalize spacing to just one space to aid comparisons
        $entry=~s/\s+/ /g;
        next if /^$/; # skip blank line 
        if ($l_verbose != 0) {
            print "processing \$entry=<$entry> \$inMultiline=$inMultiLine \$expectStruct=$expectStruct \$inStruct=$inStruct\n";
        }
        if ($inMultiline == 1) {
            $entry=~s/\\$//;
            $entry=~s/^\s+|\s+$//;
            $header_typedef_names[$header_typedef_count]=$header_typedef_names[$header_typedef_count]." ".$entry;
            if ($entry =~ ".*;" ) {
                $inMultiline=0;
                $header_typedef_count++;
            }
            next;
        }
        if ($expectStruct == 1) {
            $expectStruct=0;
            if ($entry eq "\{" ) {
                $inStruct == 1;
                next;
            }
            printf "%s: missing \{ in struct (%s) skipping\n", $l_header_file, $struct_name;
            # fall through and see if something else comes up
        }
        if ($inStruct == 1) {
            $entry_index=$struct_name."_".$current_row_count;
            $test=$_;
            if ($test =~ /\}\s+($idspec)/) {
                $header_typedef_struct_name{$struct_name}=$1;
                $header_typedef_struct_count{$struct_name}=$current_row_count;
                $inStruct=0;
                $current_row_count=0;
                next;
            }
            # normalize
            $entry=~s/^\s+|\s+$//;
            $header_struct_value{$entry_index}=$entry;
            $current_row_count++;
            next;
        }
        @db = split(" ");
        if ($db[0] eq "#define") { # handle #defines
            if ($l_verbose != 0) { print "    is a define\n"; }
            $name=$db[1];
            $number=hex($db[2]);
            $comment=$db[4];
            if ($comment eq "Deprecated") {
                if ($l_verbose != 0) { print "    Deprecated\n"; }
                next; # skip deprecated defines 
            }
            $test=$number;
            if ($test =~ /^CK$idspec/) {
                if ($l_verbose != 0) { print "    alias\n"; }
                next; # skip aliases
            }
            # Some attributes have the CKF_ARRAY_ATTRIBUTE flag
            if (($number == 0) and (substr($db[2],1,19) eq "CKF_ARRAY_ATTRIBUTE")) {
                $number=hex(substr($db[2],21));
            }
            # handle a substitution 
            if (($number == 0xc) and (substr($db[2],0,2) eq "CK")) {
                if ($l_verbose != 0) { print "    substitution\n"; }
                $number = $header_number{$db[2]};
            }
            $header_number{$name} = $number;
            $header_found{$name} = 0;
            $header_present{$name} = 1;
            $header_line{$name} = $_;
            # give VENDER_DEFINED a pass 
            if (($number == 0x80000000) && (substr($name,4) eq "VENDOR_DEFINED")) {
                if ($l_verbose != 0) { print "    vendor_defined\n"; }
                $header_found{$name} = 1;
            }
            next;
        }
        if ($db[0] eq "typedef") {
            if ($l_verbose != 0) { print "    is a typedef\n"; }
            if ($db[1] eq "struct") {
                if ($l_verbose != 0) { print "    is a struct\n"; }
                if (($db[3] ne "") && ($db[3] ne "\{")) {
                    # skip normal typedefs alias;
                    $header_typedef_names[$header_typedef_count]=$entry;
                    $test=$entry;
                    if ($test !~ /.*;$/) {
                        $entry =~ s/\\$//;
                        $entry=~s/^\s+|\s+$//;
                        $header_typedef_names[$header_typedef_count]=$entry;
                        $inMultiline=1;
                        next;
                    }
                    $header_typedef_count++;
                    next;
                }
                $name=$db[2];
                $inStruct=1;
                $expectStruct=0;
                if ($name =~ /($idspec)\{/ ) {
                    $name=$1
                } else {
                    if ($db[3] ne "\{") {
                         #print "no '\{' on line entry=$entry, name=$name, db[2]=$db[2] db[3]=$db[3]\n";
                        $expectStruct=1;
                        $inStruct=0;
                    }
                }
                $struct_name=$name;
                $current_row_count=0;
                next;
            }
            $test=$entry;
            if ($test !~ /.*\;$/) {
                # handle callbacks multiline
                $entry =~ s/\\$//;
                $entry=~s/^\s+|\s+$//;
                $header_typedef_names[$header_typedef_count]=$entry;
                $inMultiline=1;
                next;
            }
            $header_typedef_names[$header_typedef_count]=$entry;
            $header_typedef_count++;
            next;
        }
    }
    close ($header);
}

sub get_name
{
    my ($candidate)=@_;
    my $test;
    # print " getname($candidate)=";
    # strip leading and trailing spaces
    $candidate=~s/^\s+|\s+$//;
    #strip the obvious notes
    $test=$candidate;
    $candidate=~s/\,\d\d?//g;
    # carefully strip the last note value
    # from the attributes
    $test=$candidate;
    if ($test =~ /^CKA_\w+$/) {
        $test=$candidate;
        # attributes with legitimate ending digits
        if ($test =~ /(^CKA_PRIME_[12])/) {
             #print "$1 (CKA_PRIME)\n";
            return $1;
        }
        if ($test =~ /(^CKA_EXPONENT_[12])/) {
             #print "$1 (CKA_EXPONENT)\n";
            return $1;
        }
        # non of the rest should have trailing digits
        $candidate=~s/\d*$//;
        return $candidate
    }
    $test=$candidate;
    if ($test =~ /^CK[A-Z]_\w+$/) {
          #print "$candidate (CK[A-Z]_*)\n";
        return $candidate;
    }
    $test=$candidate;
    # handle the defines that didn't follow the CKx_ format
    if ($test =~ /^CK_OTP_\w+$/) {
       #if we need to reject CK_OTP_PARAMS*, doit here
          #print "$candidate (CK_OTP_*)\n";
       return $candidate;
    }
    if ($test =~ /^CK_SP800_108_\w+$/) {
         #print "$candidate (CK_SP800_108_*)\n";
       return $candidate;
    }
    if ($test =~ /^CK_CERTIFICATE_CATEGORY_\w+$/) {
         #print "$candidate (CK_CERTIFICATE_CATEGORY_*)\n";
       return $candidate;
    }
    if ($test =~ /^CK_SECURITY_DOMAIN_\w+$/) {
         #print "$candidate (CK_SECURITY_DOMAIN_*)\n";
       return $candidate;
    }
    # do we need CK_TRUE, CK_FALSE, CK_UNAVAILABLE_INFORMATION,
    # or CK_EFFECTIVELY_INFINITE?
      #print "\"\" (candidate=$candidate)\n";
    return "";
}

sub get_value
{
    my ($value)=@_;

    # make sure it's a hex value
    $test=$value;
    if ( $test =~ /^0x[A-Fa-f0-9]*/ ) {
        return hex($value);
    }
    # skip the function cases, where '1' is used as a check_mark
    if ($value == 1) {
        return 0;
    }
    $test=$value;
    if ( $test =~ /^\d+$/ ) {
        return $test;
    }
    return 0;
}

sub print_typedefs
{
    for my $i (0..($typedef_count-1)) {
        printf "%s\n", $typedef_names[$i];
    }
}

sub print_structs
{
    foreach (sort keys %typedef_struct_name)  {
        $index=$_;
        printf " typedef struct %s \{\n", $index;
        for my $i (0..($typedef_struct_count{$index}-1)) {
            $entry_index=$index."_".$i;
            printf "   %s\n", $struct_value{$entry_index};
        }
        printf " \} %s;\n", $typedef_struct_name{$index};
        printf " -----------------------------------------------------------------------------------\n";
    }
}

sub print_table
{
    foreach (@table_index) {
        $index=$_;
        if ($index == 0) {
            next;
        }
        printf " Table %03d, %s\n", $index, $table_name[$index];
        $entry1=$index."_"."0"."_"."0";
        $entry2=$index."_"."0"."_"."1";
        # printf("index1=$entry1 index2=$entry2\n");
        printf " -----------------------------------------------------------------------------------\n";
        printf " |%-40s|%-40s|\n", $table_entry{$entry1}, $table_entry{$entry2};
        printf " -----------------------------------------------------------------------------------\n";
        for my $i (1..($table_row_count[$index]-1)) {
           $entry1=$index."_".$i."_"."0";
           $entry2=$index."_".$i."_"."1";
           #printf("index1=$entry1 index2=$entry2\n");
           printf " |%-40s|%-40s|\n", $table_entry{$entry1}, $table_entry{$entry2};
        }
        printf " -----------------------------------------------------------------------------------\n";
        printf "\n";
   }
}

sub print_header_typedefs
{
    for my $i (0..($header_typedef_count-1)) {
        printf "%s\n", $header_typedef_names[$i];
    }
}

sub print_header_structs
{
    foreach (keys %header_typedef_struct_name)  {
        $index=$_;
        printf " typedef struct %s \{\n", $index;
        for my $i (0..($header_typedef_struct_count{$index}-1)) {
            $entry_index=$index."_".$i;
            printf "   %s\n", $header_struct_value{$entry_index};
        }
        printf " \} %s;\n", $header_typedef_struct_name{$index};
        printf " -----------------------------------------------------------------------------------\n";
    }
}

sub print_header_defines
{
    foreach (sort keys %header_number)  {
        $name=$_;
        printf "#define %-40s 0x%08xUL\n", $name, $header_number{$name};
    }
}

sub print_doc_defines
{
    foreach (sort keys %doc_present)  {
        $name=$_;
        if ($doc_number{$name} == 0) {
            printf "#define %-40s UNDEFINED\n", $name;
        } else {
            printf "#define %-40s 0x%08xUL\n", $name, $doc_number{$name};
        }
    }
}

sub print_diff_defines
{
    my $missing_in_doc=0;
    foreach (sort keys %doc_present)  {
        $name=$_;
        if ($header_present{$name} == 0) {
            if ($doc_number{$name} == 0) {
                printf "#define %-40s UNDEFINED missing from header %s\n",
                       $name, $header_file;
            } else {
                printf "#define %-40s 0x%08xUL missing from header %s\n",
                       $name, $doc_number{$name}, $header_file;
            }
        } else {
            if ($doc_number{$name} != 0) {
                if ($doc_number{$name} != $header_number{$name} ) {
                    printf "#define %-40s mismatched values, %s=0x%08xUL %s=0x%08xUL\n",
                           $name, $doc_file, $doc_number{$name}, $header_file, $header_number{$name};
                }
            }
        }
    }
    foreach (sort keys %header_number)  {
        $name=$_;
        if ($doc_present{$name} == 0) {
            if ($verbose2 == 1) {
                printf "#define %-40s 0x%08xUL missing from doc %s (may not be and error)\n",
                       $name, $header_number{$name}, $doc_file;
            } else {
                $missing_in_doc++;
            }
        }
    }
    if (($verbose2 == 0) && ($missing_in_doc != 0)) {
        printf"%d defines in header (%s) and not in doc (%s)\n",
                $missing_in_doc, $header_file, $doc_file;
    }
}

sub print_diff_struct
{
    my $missing_structs=0;
    foreach (sort keys %typedef_struct_name)  {
        $index=$_;
        if ( $header_typedef_struct_name{$index} eq "" ) {
            $test=$index;
            # the actual struct is in pkcs11.h and pkcs11f.h, if we have the typedef, treat is as fine
            if ($test =~ /^CK_FUNCTION_LIST\w*$/) {
                if ($header_typedef_present{"typedef struct $index $index;"} == 1) {
                    next;
                }
            }
            printf "missing struct '%s' in header %s\n", $index, $header_file;
            next;
        }
        if ( $typedef_struct_name{$index} ne $header_typedef_struct_name{$index}) {
            printf "mismatched struct name %s : header %s=%s doc %s=%s\n",
                   $index, $header_file,
                   $header_typedef_struct_name{$index},
                   $doc_file, $typedef_struct_name{$index};
        }
        for my $i (0..($typedef_struct_count{$index}-1)) {
            $entry_index=$index."_".$i;
            if ( $struct_value{$entry_index} ne $header_struct_value{$entry_index}) {
                printf "mismatched struct entry in struct %s line %d:\n"
                      ."   header '%s' (%s)\n"
                      ."   doc    '%s' (%s)\n",
                       $index, $i, $header_struct_value{$entry_index},
                       $header_file, $struct_value{$entry_index}, $doc_file;
            }
        }
    }
    foreach (sort keys %header_typedef_struct_name)  {
        $index=$_;
        if ( $typedef_struct_name{$index} eq "" ) {
            if ($verbose2 == 1) {
                printf "struct '%s' missing in doc %s\n", $index, $doc_file;
            } else {
                $missing_structs++;
            }
        }
    }
    if (($verbose2 == 0) and ($missing_structs !=0)) {
        printf"%d structs in header (%s) and not in doc (%s)\n",
                $missing_structs, $header_file, $doc_file;
    }
}

sub print_diff_typedefs
{
    print "typedef diffs from doc($doc_file) and header file($header_file)\n";
    my $ckptr_count=0;
    my %typedef_present=();
    my %header_typedef_present=();
    for my $i (0..($typedef_count-1)) {
        $typedef_present{$typedef_names[$i]}=1;
    }
    for my $i (0..($header_typedef_count-1)) {
        $header_typedef_present{$header_typedef_names[$i]}=1;
    }
    foreach (sort keys %typedef_present)  {
        $name=$_;
        if ($header_typedef_present{$name} == 0) {
            printf "missing typedef (%s) from header %s\n", $name, $header_file;
        }
    }
    foreach (sort keys %header_typedef_present)  {
        $name=$_;
        if ($typedef_present{$name} == 0) {
            $test=$name;
            if (($test =~/typedef.*\sCK_PTR\s.*_PTR;$/) and $verbose2 == 0 ) {
                $ckptr_count++;
            } else {
                printf "typedef (%s) missing from doc %s\n", $name, $doc_file;
            }
        }
    }
    if (($verbose2 == 0) && ($ckptr_count != 0)) {
        printf(" %d occurances of (typedef {ID} CK_PTR {ID}_PTR;) missing from %s\n", $ckptr_count, $doc_file);
    }
}

sub usage
{
    printf "Usage: %s [commands...] [doc_file] [header_file]\n", Command;
    print " parse a doc text file and/or a header file and output according\n";
    print " to the command:\n";
    print "    verbose:  output inconsistancies in the doc_file\n";
    print "    verbose2:  output objects in the header_file that are not in the doc_file\n";
    print "    table:  the first two columns of every table in the doc_file\n";
    print "    defines:  all the defines in both the doc_file and header_file\n";
    print "    typedefs:  all the typedefs in both the doc_file and header_file\n";
    print "    structs:  all the structs in both the doc_file and header_file\n";
    print "    doc_defines:  all the defines in the doc_file\n";
    print "    doc_typedefs:  all the typedefs in the doc_file\n";
    print "    doc_structs:  all the structs in the doc_file\n";
    print "    doc_all:  all the parsed values in the doc_file\n";
    print "    header_defines:  all the defines in the header_file\n";
    print "    header_typedefs:  all the typedefs in the header_file\n";
    print "    header_structs:  all the structs in the header_file\n";
    print "    header_all:  all the parsed values in the doc_file\n";
    print "    diff_defines:  the differences betweeen the defines in the doc_file and the header_file\n";
    print "    diff_typedefs: the differences between the typedefs in doc_file and header_file\n";
    print "    diff_structs:  the differences between the structs in doc_file andthe header_file\n";
    print "    diff_all:  all the diffs\n";
    print "if both files are required, the doc_file must be first, if no\n";
    print "commands are supplied, then diff_all is assumed\n";
}
