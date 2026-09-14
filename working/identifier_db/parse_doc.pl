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
glob $silence_doc_errors=0;
glob $has_historical=0;
glob $has_profile=0;
glob $is_skipping=0;
glob $next_deprecated=0;
glob $next_historical=0;
glob $next_profile=0;

glob $table_number=0;
glob $table_total_count=0;
glob $table_index="";
glob $current_row_count=0;
glob $current_column_count=0;
glob $row_found=0;
glob $return_value_count=0;
glob $naked_return_count=0;
glob $line_continue=0;
glob $in_table=0;
glob $in_table_2=0;
glob $in_return_value=0;
glob $in_multiline=0;
glob $in_struct=0;
glob $expect_struct=0;
glob $in_table_header=0;
glob $typedef_count=0;
glob $header_typedef_count=0;
glob %typedef_struct_name = ();
glob %typedef_struct_count = ();
glob %typedef_present=();
glob %struct_value = ();
glob %table_entry = ();
glob %table_col_count = ();
glob %table_name = ();
glob %table_doc = ();
glob %table_row_count = ();
glob %header_typedef_struct_name = ();
glob %header_typedef_struct_count = ();
glob %header_struct_value = ();
glob %header_typedef_present = ();
glob @table_indices = ();
glob @typedef_names = ();
glob @naked_return_values = ();
glob @naked_return_doc = ();
glob @naked_return_line = ();
glob @return_doc = ();
glob @return_values = ();
glob @return_doc = ();
glob @return_line = ();
glob @header_typedef_names = ();
glob $idspec="[a-zA-Z]\\w*";
glob $number="\\d+";
# future read these two from a file
# special identifiers not match the normal matching rules, but are expected to be defined in the document
# note CKR_VENDOR_DEFINED is handled separately so we can detect improper use in the function Return value lists.
glob @special_identifiers = ( "CK_FALSE", "CK_TRUE", "CK_INVALID_HANDLE", "CK_EFFECTIVELY_INFINITE", "CK_UNAVAILABLE_INFORMATION", "CKA_VENDOR_DEFINED", "CKM_VENDOR_DEFINED", "TRUE", "FALSE" );
# header specific are defines that are part of the header machinery and not meantioned in the document
glob @header_specific = ( "CRYPTOKI_VERSION_AMENDMENT", "CRYPTOKI_VERSION_MAJOR", "CRYPTOKI_VERSION_MINOR", "_PKCS11T_H_" );
#

glob $doc_file="";
glob $doc_dir="";
glob $header_file="";
glob $Command="./parse_doc.pl";  # get from the evironment?
glob $BASE="..";

foreach (@ARGV) {
    $arg=$_;
    if ($arg eq "help") {
        usage();
        exit;
    }
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
    if ($arg eq "no_doc_erros") {
        $silence_doc_errors=1;
        next;
    }
    if ($arg =~ /^base=(.*)$/) {
       $BASE=$base;
    }
    if ($header_file eq "") {
        $header_file=$arg;
        next;
    }
    if ($doc_file eq "") {
        $doc_file=$arg;
        next;
    }
    $doc_file="$doc_file $arg";
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


if ($need_doc==1 && $need_header==0 && $header_file ne "") {
    $doc_file="$header_file $doc_file"
}

if ($need_doc==1 && $doc_file eq "") {
    $doc_file="spec";
}

if ($need_header==1 &&  $header_file eq "") {
    $header_file="${BASE}/headers/pkcs11t.h";
}

if ($need_header==1) {
    my ($header_name, $header_path) = fileparse($header_file);
    my @dirs = File::Spec->splitdir($header_path);
    if ($header_name eq "") {
        $header_name=File::Spec->catfile(@dirs, "pkcs11t.h");
    }
    $function_header_file=File::Spec->catfile(@dirs, "pkcs11.h");
}

$test=$doc_file;
if ( $test =~ /hist/ ) {
    $has_historical=1;
}
$test=$doc_file;
if ( $test =~ /profiles/ ) {
    $has_profile=1;
}

if ($verbose == 1) {
    print "doc_file=$doc_file header_file=$header_file function_header_file=$function_header_file\n";
    print " \$has_historical=$has_historical\n";
    print " \$has_profile=$has_profile\n";
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
my $short_doc="";
if ($doc_file ne "") {
  @tx=split(' ', $doc_file);
  foreach (@tx) {
   $doc_dir=$_;
   # verify the list exists
   $current_dir="$BASE/doc/$doc_dir";
   $listfile="$current_dir/files.txt";
   # sigh files file in the spec directory is named differently
   if ($doc_dir eq "spec") {
       $listfile="$current_dir/spec_files.txt";
   }
   if ($verbose == 1) {
       print "--- parsing directory=\"$doc_dir\" using $listfile\n";
   }
   $table_number=0; # reset set the table counter for every separate spec
   open(my $doc_list, "<", "$listfile") or die "Can't open $listfile: $!";
   while (<$doc_list>) {
    $line=0;
    if ($in_table == 1 || $in_table_2 == 1) {
        # we can use lc here because the two files we are comparing against have no unicode characters
        # so if lc chokes on unicode in $short_doc, it's fine because it shouldn't match in that case anyway
        $short_case= lc($short_doc);
        if (($short_case ne "acknowledgements.md") && ($short_case ne "revsion_history.md")) {
            printf(" ERROR uncompleted table in $current_doc!\n");
        }
        $in_table=0;
        $in_table_2=0;
        $table_name{$table_index}="unknown".$table_index;
        $table_row_count{$table_index}=$current_row_count;
    }
    if ($in_struct == 1) {
        printf(" ERROR uncompleted struct in $current_doc!\n");
        $in_struct=0;
    }
    if ($in_return_value == 1) {
        # this is not an error, several files have the Return Value: block as the
        # last thing in the file, so just close it out here.
        #printf(" ERROR uncompleted Return Value: block in $current_doc!\n");
        $in_return_value=0;
    }
    chomp;
    $short_doc=$_;
    $current_doc="$current_dir/$short_doc";
    if ($verbose == 1) {
        print "     parsing file=\"$short_doc\" ($current_doc)\n";
    }
    open(my $doc, "<", "$current_doc") or die "Can't open $current_doc: $!";
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
        $test=lc($entry);
        if ( $test =~ /deprecated/ ) {
            # if we have a deprecated statement on the line,
            # don't include any identfiers in the scan
            next;
        }
        if ($expect_struct == 1) {
            $expect_struct=0;
            if ($entry eq "\{" ) {
                $in_struct == 1;
                next;
            }
            printf "%s line %d: missing \{ in struct (%s) skipping\n", $current_doc, $line, $struct_name;
            # fall through and see if something else comes up
        }
        if ($in_return_value == 1) {
            $test=$entry;
            if ($test =~ /^CKR_/) {
                $return_values[$return_value_count] = $entry;
                $return_doc[$return_value_count] = $current_doc;
                $return_line[$return_value_count] = $line;
                $return_value_count++;
                next;
            }
            # fall through
            $in_return_value=0;
        }
        if ($in_multiline == 1) {
            $test=$entry;
            if ($test =~ /^$/) {
                if ($verbose == 1) {
                    printf "%s line %d: missing ';' in typedef '%s'\n",
                           $current_doc, $line, $typedef_names[$typedef_count];
                }
                $typedef_names[$typedef_count]=$typedef_names[$typedef_count].";";
                $in_multiline=0;
                $typedef_count++;
                next;
            }
            $typedef_names[$typedef_count]=$typedef_names[$typedef_count]." ".$entry;
            if ($entry =~ ".*;" ) {
                $in_multiline=0;
                $typedef_count++;
            }
            next;
        }
        if ($in_struct == 1) {
            $entry_index=$struct_name."_".$current_row_count;
            $test=$_;
            if ($test =~ /\}\s+($idspec)/) {
                $typedef_struct_name{$struct_name}=$1;
                $typedef_struct_count{$struct_name}=$current_row_count;
                $in_struct=0;
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
        if ($in_table == 1) {
            my $has_line_continue=0;
            $entry_row=$table_index."_".$current_row_count;
            $test=$_;
            if ( $test =~ /\\$/ ) {
                $has_line_continue=1;
            }
            if ($line_continue == 1) {
                $line_continue = $has_line_continue;
                next;
            }
            $line_continue = $has_line_continue;
#."_".$current_column_count;
    #printf " handling %d, current_row_count=%d current_column_count=%d entry=%s\n", $table_number, $current_row_count, $current_column_count, $entry;
            if ($in_table_header == 1) {
                $test=$_;
                if ($test =~ /^\+=/) {
                    $in_table_header=0;
                    $row_found=0;
                }
                next;
            }
            $test=$_;
            if ($test =-/^\|/) {
                if ($row_found == 1) {
#Function table #1 generates lots of noise here, so silence this
#                    if ($verbose == 1) {
#                        printf "%s line %d: bad table entry, too many rows in row %d table %d\n",
#                            $current_doc, $line, $current_row_count,$table_number;
#                    }
                    next;
                }
                @table_columns=split('\|', $_);
                $current_column_count=0;
                foreach (@table_columns) {
                    strip;
                    $test=$_;
                    if ($test =~ /^$/) {
                        next;
                    }
                    $table_entry{$entry_row."_".$current_column_count}=$_;
                    $current_column_count++;
                }
                $row_found=1;
                next;
            }
            $test=$_;
            if ($test =~ /^\+-/) {
                    $current_row_count++;
                    $row_found=0;
                    next;
            }
            $test=$_;
            if ($test =~ /^table: (.*)/) {
                $in_table=0;
                $table_name{$table_index}=$1;
                $table_row_count{$table_index}=$current_row_count;
                next;
            }
            if ($test =~ /^table ($number): (.*)/) {
                $in_table=0;
                if ($1 != $table_number) {
                    printf "%s line %d: explicit table number (%d) does not match table in order (%d).\n",
                           $current_doc, $line, $1, $table_number ;
                }
                $table_name{$table_index}=$2;
                $table_row_count{$table_index}=$current_row_count;
                next;
            }
            # error no table label
            printf "%s line %d: missing table label in table %d\n",
                        $current_doc, $line, $table_number;
            $table_name{$table_index}="unknown".$table_index;
            $table_row_count{$table_index}=$current_row_count;
            next;
        }
        if ($in_table_2 == 1) {
            my $has_line_continue=0;
            $entry_row=$table_index."_".$current_row_count;
            $test=$_;
            if ( $test =~ /\\$/ ) {
                $has_line_continue=1;
            }
            if ($line_continue == 1) {
                $line_continue = $has_line_continue;
                next;
            }
            $line_continue = $has_line_continue;
            if ($in_table_header == 1) {
                $test=$_;
                if ($test =~ /^\|-/) {
                    $in_table_header=0;
                }
                next;
            }
            $test=$_;
            if ($test =-/^\|/) {
                @table_columns=split('\|', $_);
                $current_column_count=0;
                foreach (@table_columns) {
                    strip;
                    $test=$_;
                    if ($test =~ /^$/) {
                        next;
                    }
                    $table_entry{$entry_row."_".$current_column_count}=$_;
                    $current_column_count++;
                }
                $current_row_count++;
                next;
            }
            $test=$_;
            if ($test =~ /^table: (.*)/) {
                $in_table_2=0;
                $table_name{$table_index}=$1;
                $table_row_count{$table_index}=$current_row_count;
                next;
            }
            if ($test =~ /^table ($number): (.*)/) {
                $in_table_2=0;
                if ($1 != $table_number) {
                    printf "%s line %d: explicit table number (%d) does not match table in order (%d).\n",
                           $current_doc, $line, $1, $table_number ;
                }
                $table_name{$table_index}=$2;
                $table_row_count{$table_index}=$current_row_count;
                next;
            }
            $in_table_2=0;
            # error no table label
            printf "%s line %d: missing table label in table %d\n",
                           $current_doc, $line, $table_number;
            $table_name{$table_index}="unknown".$table_index;
            $table_row_count{$table_index}=$current_row_count;
            next;
        }
        $test=$entry;
        if ($test =~ /^Return [Vv]alues: (.*)$/) {
            $return_values[$return_value_count] = $1;
            $return_doc[$return_value_count] = $current_doc;
            $return_line[$return_value_count] = $line;
            $return_value_count++;
            $in_return_value=1;
            next;
        }
        $test=$_;
        if ($test =~ /^\+-/) {
            # table name gets assigned at the end where the table label is.
            #$table_name{$table_index}=$2;
            $table_number=$table_number + 1;
            $table_total_count=$table_total_count + 1;
            $table_index=$doc_dir."_".$table_number;
            $table_doc{$table_index}=$current_doc;
            $table_row_count{$table_index}=0;
            $table_indices[$table_total_count]=$table_index;
            $current_row_count=0;
            $row_found=0;
            $current_column_count=0;
            $in_table=1;
            $in_table_header=1;
            next;
        }
        if ($test =~ /^\|/) {
            # table name gets assigned at the end where the table label is.
            #$table_name{$table_index}=$2;
            $table_number=$table_number + 1;
            $table_total_count=$table_total_count + 1;
            $table_index=$doc_dir."_".$table_number;
            $table_doc{$table_index}=$current_doc;
            $table_row_count{$table_index}=0;
            $table_indices[$table_total_count]=$table_index;
            $current_row_count=0;
            $row_found=0;
            $current_column_count=0;
            $in_table_2=1;
            $in_table_header=1;
            next;
        }
        $test=$_;
        if ($test =~ /typedef struct ($idspec) \{/) {
            # A PKCS #11 C typedef structure
    #print "in typedefs with \{ entry=$entry, name=$1\n"
            $struct_name=$1;
            $current_row_count=0;
            $in_struct=1;
            next;
        }
        $test=$_;
        if ($test =~ /typedef struct ($idspec)/) {
            # Same as above except the  brackets start on the next line, go find it
            $struct_name=$1;
            $current_row_count=0;
            $expect_struct=1;
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
            $in_multiline=1;
            next;
        }
        $test=$_;
        if (($short_doc eq "function_return_values.md") && ($test =~/^\* (CKR_$idspec):/)) {
            $name=$1;
            $doc_found{$name}=0;
            $doc_present{$name}=1;
            $doc_number{$name}=0;
            next;
        }
        # handle naked return codes to make sure they are defined in their proper places.
        $test=$_;
        if ($test =~ /(CKR_$idspec)/) {
            $name=$1;
            $naked_return_values[$naked_return_count]=$1;
            $naked_return_doc[$naked_return_count]=$current_doc;
            $naked_return_line[$naked_return_count]=$line;
            $naked_return_count++;
            # continue processing
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
            $in_multiline=1;
            next;
        }
        $test=$_;
         # the following defines are just in the text, not in tables,
         # just scower them out.
         # first process the bold versions, so we don't put spurious
         # version of this id with an extra '_'
        if ($test =~ /_(CK[CDFGHNOSTUV]_$idspec)_/) {
            $name=$1;
            $doc_found{$name}=0;
            $doc_present{$name}=1;
            $doc_number{$name}=0;
            next;
        }
        # now process the rest.
        if ($test =~ /(CK[CDFGHNOSTUV]_$idspec)/) {
            $name=$1;
            $doc_found{$name}=0;
            $doc_present{$name}=1;
            $doc_number{$name}=0;
            next;
        }
        $test=$_;
        if ($test =~/^CK_KEY_TYPE/) {
             # for keytypes, skip C code examples, make sure we have the
             # definition in the text
            next;
        }
        $test=$_;
        if ($test =~ /(CKK_$idspec)/) {
            $name=$1;
            if (exists $doc_present{$name}) {
                next;
            }
            $doc_found{$name}=0;
            $doc_present{$name}=1;
            $doc_number{$name}=0;
            next;
        }
        $test=$_;
        if ($test =~/^PARAM_SET_TYPE/) {
             # for keytypes, skip C code examples, make sure we have the
             # definition in the text
            next;
        }
        $test=$_;
        if ($test =~ /(CKP_$idspec)/) {
            $name=$1;
            $doc_found{$name}=0;
            $doc_present{$name}=1;
            $doc_number{$name}=0;
            next;
        }
        $test=$_;
        $test=$_;
        if ($test =~ /(CK_CERTIFICATE_CATEGORY_$idspec)/) {
            $name=$1;
            if (($verbose == 1) && (!exists $doc_present{$name})) {
                    printf "%s line %d: %s in unlabelled table.\n",
                           $current_doc, $line, $name;
            }
            $doc_found{$name}=0;
            $doc_present{$name}=1;
            $doc_number{$name}=0;
            next;
        }
        $test=$_;
        if ($test =~ /(CK_SECURITY_DOMAIN_$idspec)/) {
            $name=$1;
            if (($verbose == 1) && (!exists $doc_present{$name})) {
                    printf "%s line %d: %s in unlabelled table.\n",
                           $current_doc, $line, $name;
            }
            $doc_found{$name}=0;
            $doc_present{$name}=1;
            $doc_number{$name}=0;
            next;
        }
        $name=has_identifier($_,@special_identifiers);
        if ($name) {
            $doc_found{$name}=0;
            $doc_present{$name}=1;
            $doc_number{$name}=0;
            next;
        }
    }
    close($doc);
   }
  }
}

# read the same stuff out of the header file
if ($header_file ne "") {
    process_header($header_file, 0);
}

# extract the defines from the tables
foreach (@table_indices) {
    $index=$_;
    $is_OTP=0;
    for my $i (0..($table_row_count{$index}-1)) {
        $entry1=$index."_".$i."_"."0";
        $entry2=$index."_".$i."_"."1";
        $entry3=$index."_".$i."_"."2";
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
                    printf("%s: identifier %s has inconsistant values 0x%08xUL (Table %s) and 0x%08xUL (Table %s)\n",
                            $table_doc{$index}, $name, $header_number{$name},
                            $doc_table_number{$name}, $number, $index);
                }
            }
            $test=$name;
            if ($test =~ /CKA_OTP_/) {
                $is_OTP=1;
            }
            next;
        }
        $name=get_name($table_entry{$entry2});
        if ($name ne "" ) {
            if (!exists $doc_present{$name}) {
                $doc_number{$name}= 0;
            }
            $doc_found{$name}=0;
            $doc_present{$name}=1;
        } else {
            # handle the case where ther is more than one
            # basically CKK_DES3 will never be found without this.
            my $names=$table_entry{$entry2};
            while ($names =~ /(CK[A-Z]_$idspec)(.*)$/) {
                $name=$1;
                $names=$2;
                if (!exists $doc_present{$name}) {
                    $doc_number{$name}= 0;
                }
                $doc_found{$name}=0;
                $doc_present{$name}=1;
            }
        }
        if ($is_OTP) {
            $test=$table_entry{$entry3};
            if ($test =~ /(CK_OTP_$idspec) =/) {
                $name=$1;
                if (!exists $doc_present{$name}) {
                    $doc_number{$name}= 0;
                }
                $doc_found{$name}=0;
                $doc_present{$name}=1;
            }
        }
    }
}



# process the return values
# return values should be defined in in function_return_values.md
# find those cases where we have a return value defined in
# a function return list but not in function_return_values.md
# We output an error and then add the table to the list of
# expected defines to make sure that they are in the header.
my %missing_return_doc= ();
for my $i (0..($return_value_count-1)) {
    foreach (fetch_return($return_values[$i])) {
        $value=$_;
        if (!exists $doc_present{$value}) {
            my $doc_spec= "$return_doc[$i]:$return_line[$i]";
            if ($missing_return_doc{$value}) {
                $missing_return_doc{$value}=$missing_return_doc{$value}.",$doc_spec";
            } else {
                $missing_return_doc{$value}=$doc_spec;
            }
        }
    }
}
# print and load the up at the end... this allows us
# to output all the places that the entry could fall into
if (%missing_return_doc) {
    print "The following return codes were used in function retun blocks, but\n";
    print " not define in 'function_return_values.md' return code section:\n";
}
foreach (sort keys %missing_return_doc) {
    $name=$_;
    print "    $name define in $missing_return_doc{$name}\n";
    # add it to the defines expected in the headers.
    $doc_number{$name}= 0;
    $doc_found{$name}=0;
    $doc_present{$name}=1;
}

# now preload CKR_VENDOR_DEFINED. It should not appear in the function return
# lists, but it's meantioned legitmately in general_data_type.md, we don't
# want it to show up in these list, but we do want it in the header file
$name="CKR_VENDOR_DEFINED";
$doc_number{$name}=0;
$doc_found{$name}=0;
$doc_present{$name}=1;

# now handle naked return codes we find in the text proper
my $need_print_header=1;
for my $i (0..($naked_return_count-1)) {
    $value=$naked_return_values[$i];
    if (!exists $doc_present{$value}) {
        if ($need_print_header) {
            print "The following return codes were used in the spec but defined in neither\n";
            print " function return blocks nor in 'function_return_values.md':\n";
            $need_print_header=0;
        }
        print "    $value defined in $naked_return_doc[$i] line $naked_return_line[$i]\n";
    }
}

# we do the loop again so we can catch muliple occurances of the naked return value
for my $i (0..($naked_return_count-1)) {
    $value=$naked_return_values[$i];
    if (!exists $doc_present{$value}) {
        $doc_number{$value}= 0;
        $doc_found{$value}=0;
        $doc_present{$value}=1;
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
    my %is_specific = map { $_ => 1 } @header_specific;
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
        $is_skipping=$next_deprecated || $next_historical || $next_profile;
        $test=$_;
        if ( $test =~ /^[\s\/]\* Deprecated/ ) {
            $next_deprecated=1;
        } else {
            $next_deprecated=0;
        }
        $test=$_;
        if ($has_historical == 0 && $test =~ /^[\s\/]\* Historical/ ) {
            $next_historical=1;
        } else {
            $next_historical=0;
        }
        $test=$_;
        if ($has_profile == 0 && $test =~ /^[\s\/]\* Profile Only/ ) {
            $next_profile=1;
        } else {
            $next_profile=0;
        }
        next if /^$/; # skip blank line
        if ($l_verbose != 0) {
            print "processing \$entry=<$entry> \$in_multiline=$in_multiline \$expect_struct=$expect_struct \$in_struct=$in_struct\n";
        }
        if ($in_multiline == 1) {
            $entry=~s/\\$//;
            $entry=~s/^\s+|\s+$//;
            $header_typedef_names[$header_typedef_count]=$header_typedef_names[$header_typedef_count]." ".$entry;
            if ($entry =~ ".*;" ) {
                $in_multiline=0;
                $header_typedef_count++;
            }
            next;
        }
        if ($expect_struct == 1) {
            $expect_struct=0;
            if ($entry eq "\{" ) {
                $in_struct == 1;
                next;
            }
            printf "%s: missing \{ in struct (%s) skipping\n", $l_header_file, $struct_name;
            # fall through and see if something else comes up
        }
        if ($in_struct == 1) {
            $entry_index=$struct_name."_".$current_row_count;
            $test=$_;
            if ($test =~ /\}\s+($idspec)/) {
                $header_typedef_struct_name{$struct_name}=$1;
                $header_typedef_struct_count{$struct_name}=$current_row_count;
                $in_struct=0;
                $current_row_count=0;
                next;
            }
            # normalize
            $entry=~s/^\s+|\s+$//;
            $header_struct_value{$entry_index}=$entry;
            $current_row_count++;
            next;
        }
        # if we have a deprecated, historical or profile comment, just skip parsing the next line
        if ($is_skipping) {
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
            if ($has_historical == 0 && $comment eq "Historical") {
                if ($l_verbose != 0) { print "    Historical ID\n"; }
                next; # skip historical defines, they are documented in
                      # the historical algorithms spec.
            }
            if ($has_profile == 0 && $comment eq "Profile") {
                if ($l_verbose != 0) { print "    Profile ID\n"; }
                next; # skip profile ID, they are documented
                      # profile spec.
            }
            if ( exists $is_specific{$name} ) {
                if ($l_verbose !=0)  { print "    Header Specific\n"; }
                next; # skip header specific defines
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
                        $in_multiline=1;
                        next;
                    }
                    $header_typedef_count++;
                    next;
                }
                $name=$db[2];
                $in_struct=1;
                $expect_struct=0;
                if ($name =~ /($idspec)\{/ ) {
                    $name=$1
                } else {
                    if ($db[3] ne "\{") {
                         #print "no '\{' on line entry=$entry, name=$name, db[2]=$db[2] db[3]=$db[3]\n";
                        $expect_struct=1;
                        $in_struct=0;
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
                $in_multiline=1;
                next;
            }
            $header_typedef_names[$header_typedef_count]=$entry;
            $header_typedef_count++;
            next;
        }
    }
    close ($header);
}

sub fetch_return
{
    my ($line)=@_;
    my $test;
    my @returns = ();

    $test=$line;
    while ($test =~ /(CKR_$idspec)(.*)$/) {
        $test=$2;
        push(@returns,$1);
    }
    return @returns;
}

sub get_name
{
    my ($candidate)=@_;
    my $test;
    #print " getname('$candidate')=";
    # strip leading and trailing spaces
    $candidate=~s/^\s+|\s+$//g;
    #strip the obvious notes
    $candidate=~s/\,\d\d?//g;
    $candidate=~s/ \^\d+\^$//g;
    $candidate=~s/\^\d+\^$//g;
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
    #print "\"\" (candidate='$candidate')\n";
    return "";
}

sub get_value
{
    my ($value)=@_;

    # strip leading and trailing spaces
    $value=~s/^\s+|\s+$//g;
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

sub has_identifier
{
    my ($value, @array)=@_;

    if ($value eq "") {
        return "";
    }

    foreach (@array) {
        my $test=$value;
        if ($test =~ /$_/ ) {
            return $_;
        }
    }
    return "";
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
    foreach (@table_indices) {
        $index=$_;
        if ($index eq "") {
            next;
        }
        printf " Table %s, %s\n", $index, $table_name{$index};
        printf " -----------------------------------------------------------------------------------\n";
        for my $i (0..($table_row_count{$index}-1)) {
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
        if (!exists $doc_present{$name}) {
            if ($silence_doc_errors == 0) {
                printf "#define %-40s 0x%08xUL missing from doc '%s' (may not be and error)\n",
                       $name, $header_number{$name}, $doc_file;
            } else {
                $missing_in_doc++;
            }
        }
    }
    if (($silence_doc_errors == 1) && ($missing_in_doc != 0)) {
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
            if ($silence_doc_errors == 0) {
                printf "struct '%s' missing in doc %s\n", $index, $doc_file;
            } else {
                $missing_structs++;
            }
        }
    }
    if (($silence_doc_errors == 1) and ($missing_structs !=0)) {
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
            if ($test =~ /typedef struct CK_FUNCTION_LIST\w* CK_FUNCTION_LIST\w*;/) {
                my @names=split(/[ ;]/,$name);
                if ($names[2] ne $names[3]) {
                    printf "%s: inconsistent function list declaration:\n $name\n $names[2] ne $names[3]\n", $header_file;
                    next;
                }
                if ($typedef_struct_name{$names[2]} ne "" ) {
                    next;
                }
            }
            $test=$name;
            if (($test =~ /typedef.*\sCK_PTR\s.*_PTR;$/) and $verbose2 == 0 ) {
                $ckptr_count++;
            } else {
                printf "typedef (%s) missing from doc '%s'\n", $name, $doc_file;
            }
        }
    }
    if (($verbose2 == 0) && ($ckptr_count != 0)) {
        printf(" %d occurances of (typedef {ID} CK_PTR {ID}_PTR;) missing from %s\n", $ckptr_count, $doc_file);
    }
}

sub usage
{
    printf "Usage: %s [commands...] [header_file] [doc_directories ... ]\n", Command;
    print " parse one or more markdown documents and/or a header file and output\n";
    print " according to the command:\n";
    print "    base={base_dir}:  location of the root of the working tree, default is ../\n";
    print "    verbose:  output inconsistancies in the document\n";
    print "    verbose2:  output objects in the header_file that are not in the doc_file\n";
    print "    no_doc_errors:  only print a summary of missing document values\n";
    print "    table:  the first two columns of every table in the document(s)\n";
    print "    defines:  all the defines in both the document(s)and header_file\n";
    print "    typedefs: all the typedefs in both the document(s) and header_file\n";
    print "    structs:  all the structs in both the documents(s) and header_file\n";
    print "    doc_defines:     all the defines in the document(s)\n";
    print "    doc_typedefs:    all the typedefs in the document(s)\n";
    print "    doc_structs:     all the structs in the document(s)\n";
    print "    doc_all:         all the parsed values in the document(s)\n";
    print "    header_defines:  all the defines in the header_file\n";
    print "    header_typedefs: all the typedefs in the header_file\n";
    print "    header_structs:  all the structs in the header_file\n";
    print "    header_all:      all the parsed values in the document(s)\n";
    print "    diff_defines:  the differences betweeen the defines in the document(s) and the header_file\n";
    print "    diff_typedefs: the differences between the typedefs in document(s) and header_file\n";
    print "    diff_structs:  the differences between the structs in document(s) and the header_file\n";
    print "    diff_all:  all the diffs\n";
    print "1. documents are specified by the directory. files.txt or \n";
    print "   spec_files.txt are read to find the individual files of the doc.\n";
    print "2. if more than one document directory is specified all directories\n";
    print "   are read and treated as one combined document. Adding profile and\n";
    print "   historical directories will turn on scanning of those defines\n";
    print "   in the header.\n";
    print "3. if documents and the header is required, the header_file must be first.\n";
    print "4. if no commands are supplied, then diff_all is assumed.\n";
}
