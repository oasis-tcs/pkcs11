#!/bin/perl
#
# get the source file
# read the database
use File::Basename;
use File::Spec;
sub process_header;
sub usage;

glob $print_header1_tables=0;
glob $print_header1_defines=0;
glob $print_header1_structs=0;
glob $print_header1_typedefs=0;
glob $print_header2_defines=0;
glob $print_header2_structs=0;
glob $print_header2_typedefs=0;
glob $print_diff_defines=0;
glob $print_diff_typedefs=0;
glob $print_diff_structs=0;
glob $verbose=0;
glob $verbose1=0;
glob $verbose2=0;

glob $inMultiline=0;
glob $inStruct=0;
glob $expectStruct=0;
glob $header1_typedef_count=0;
glob $header2_typedef_count=0;
glob %header1_typedef_struct_name = ();
glob %header1_typedef_struct_count = ();
glob %header1_struct_value = ();
glob %header1_typedef_present = ();
glob %header2_typedef_struct_name = ();
glob %header2_typedef_struct_count = ();
glob %header2_struct_value = ();
glob %header2_typedef_present = ();
glob @header1_typedef_names = ();
glob @header2_typedef_names = ();
glob $idspec="[a-zA-Z]\\w*";

glob $Command="./cmp_header.pl";  # get from the evironment?

glob $header1="";
glob $header2="";

foreach (@ARGV) {
    $arg=$_;
    if ($arg eq "help") {
        usage();
        exit;
    }
    if ($arg eq "defines") {
        $print_header1_defines=1;
        $print_header2_defines=1;
        next;
    } 
    if ($arg eq "structs") {
        $print_header1_structs=1;
        $print_header2_structs=1;
        next;
    } 
    if ($arg eq "typedefs") {
        $print_header1_typedefs=1;
        $print_header2_typedefs=1;
        next;
    } 
    if ($arg eq "header1_defines") {
        $print_header1_defines=1;
        next;
    } 
    if ($arg eq "header1_structs") {
        $print_header1_structs=1;
        next;
    } 
    if ($arg eq "header1_typedefs") {
        $print_header1_typedefs=1;
        next;
    } 
    if ($arg eq "header2_defines") {
        $print_header2_defines=1;
        next;
    } 
    if ($arg eq "header2_structs") {
        $print_header2_structs=1;
        next;
    } 
    if ($arg eq "header2_typedefs") {
        $print_header2_typedefs=1;
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
    if ($arg eq "haeder1_all") {
        $print_header1_defines=1;
        $print_header1_structs=1;
        $print_header1_typedefs=1;
        next;
    }
    if ($arg eq "header2_all") {
        $print_header2_defines=1;
        $print_header2_structs=1;
        $print_header2_typedefs=1;
        next;
    }
    if ($arg eq "diff_all") {
        $print_diff_defines=1;
        $print_diff_typedefs=1;
        $print_diff_structs=1;
        next;
    }
    if ($arg eq "all") {
        $print_header1_defines=1;
        $print_header1_structs=1;
        $print_header1_typedefs=1;
        $print_header2_defines=1;
        $print_header2_structs=1;
        $print_header2_typedefs=1;
        $print_diff_defines=1;
        $print_diff_typedefs=1;
        $print_diff_structs=1;
        next;
    }
    if ($arg eq "verbose") {
        $verbose=1;
        next;
    }
    if ($arg eq "verbose1") {
        $verbose1=1;
        next;
    }
    if ($arg eq "verbose2") {
        $verbose2=1;
        next;
    }
    if ($header1 eq "")  {
        $header1=$arg;
        next;
    }
    if ($header2 eq "") {
        $header2=$arg;
        next;
    }
    printf "-- unknown command %s header1=%s header2=%s\n", $arg, $header1, $header2;
    usage();
    exit;
}

# default to diff_all
if (($print_header1_defines == 0) &&
    ($print_header1_structs == 0) &&
    ($print_header1_typedefs == 0) &&
    ($print_header1_tables == 0) &&
    ($print_header2_defines == 0) &&
    ($print_header2_structs == 0) &&
    ($print_header2_typedefs == 0) &&
    ($print_diff_defines == 0) &&
    ($print_diff_typedefs == 0) &&
    ($print_diff_structs == 0)) {
        $print_diff_defines=1;
        $print_diff_typedefs=1;
        $print_diff_structs=1;
}

$need_header=0;
$need_header1=0;
if (($print_header1_defines == 1) ||
    ($print_header1_structs == 1) ||
    ($print_header1_typedefs == 1) ||
    ($print_header1_tables == 1) ||
    ($print_diff_defines == 1) ||
    ($print_diff_typedefs == 1) ||
    ($print_diff_structs == 1)) {
    $need_header1=1;
}

if (($print_header2_defines == 1) ||
    ($print_header2_structs == 1) ||
    ($print_header2_typedefs == 1) ||
    ($print_diff_defines == 1) ||
    ($print_diff_typedefs == 1) ||
    ($print_diff_structs == 1)) {
    $need_header2=1;
}


if ($need_header1==0 && $need_header2==1 &&  $header2 eq "") {
    $header2=$header1;
    $header1="";
}

if ($need_header1==1 && $header1 eq "") {
    $header1="../headers/pkcs11t.h";
}

if ($need_header2==1 &&  $header2 eq "") {
    $header2="pkcs11t.h"
}


if ($verbose == 1) {
    print  "header1=$header1 header2=$header2\n";
    print " \$print_header1_defines=$print_header1_defines\n";
    print " \$print_header1_structs=$print_header1_structs\n";
    print " \$print_header1_typedefs=$print_header1_typedefs\n";
    print " \$print_header2_defines=$print_header2_defines\n";
    print " \$print_header2_structs=$print_header2_structs\n";
    print " \$print_header2_typedefs=$print_header2_typedefs\n";
    print " \$print_diff_defines=$print_diff_defines\n";
    print " \$print_diff_typedefs=$print_diff_typedefs\n";
    print " \$print_diff_structs=$print_diff_structs\n";
}


# read the same stuff out of the header file
if ($header1 ne "") {
    process_header($header1, 1, $verbose1);
}

if ($header2 ne "") {
    process_header($header2, 2, $verbose2);
}
 
# build the typedef tables
for my $i (0..($header1_typedef_count-1)) {
    $typedef_present{$header1_typedef_names[$i]}=1;
}
for my $i (0..($header2_typedef_count-1)) {
    $header_typedef_present{$header2_typedef_names[$i]}=1;
}

if ($print_header_defines) {
    printf "******************** %s defines **********************\n", $header1;
    print_header1_defines(1,0);
    printf "\n";
}
if ($print_header1_structs) {
    printf "******************** %s structs **********************\n", $header1;
    print_header_structs(1, 0);
    printf "\n";
}
if ($print_header1_typedefs) {
    printf "******************** %s typedefs **********************\n", $header1;
    print_header_typedefs(1, 0);
    printf "\n";
}
if ($print_header2_defines) {
    printf "******************** %s defines **********************\n", $header2;
    print_header_defines(2, 0);
    printf "\n";
}
if ($print_header2_structs) {
    printf "******************** %s structs **********************\n", $header2;
    print_header_structs(2, 0);
    printf "\n";
}
if ($print_header2_typedefs) {
    printf "******************** %s typedefs **********************\n", $header2;
    print_header_typedefs(2, 0);
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
if ($print_diff_structs) {
    print_diff_structs();
    printf "\n";
}
  
sub process_header
{
    my ($l_header_file, $l_which, $l_verbose)=@_;
    print "Processing header$l_which = $l_header_file...\n";

    open(my $header, "<", $l_header_file) or die "Can't open $l_header_file: $!";
    $inMultiline=0;
    $inComment=0;
    while (<$header>) {
        chomp;   # clear out new line 
        $entry=$_;
        # remove single line comments first
        $entry=~s/\/\*.*\*\///g;
        if ($l_verbose != 0) {
            print "processing \$entry=<$entry> \$inMultiline=$inMultiline \$expectStruct=$expectStruct \$inStruct=$inStruct \$inComment=$inComment\n" ;
        }
        # now remove all multi-line comments
        if ($inComment == 1) {
            $test = $entry;
            if ($test =~ /.*\*\/(.*)$/) {
                $entry=$1;
                $inComment=0;
                # continue processing the stuff after the comment ended.
            } else {
                next; # still in comment, skip everything
            }
        } else {
            $test = $entry;
            if ($test =~ /(.*)\/\*.*$/) {
                $entry=$1;
                $inComment=1;
                # continue processin the stuff before the comment started.
            }
        }
        # strip trailing and leading blanks
        $entry=~s/^\s+|\s+$//;
        # normalize spacing to just one space to aid comparisons
        $entry=~s/\s+/ /g;
        next if /^$/; # skip blank line 
        if ($entry eq "" ) { next; }
        if ($l_verbose != 0) {
            print " normalized \$entry=<$entry>\n" ;
        }
        if ($inMultiline == 1) {
            $entry=~s/\\$//;
            $entry=~s/^\s+|\s+$//;
            if ($l_which eq 1) {
                $header1_typedef_names[$header1_typedef_count]=$header1_typedef_names[$header1_typedef_count]." ".$entry;
            } else {
                $header2_typedef_names[$header2_typedef_count]=$header2_typedef_names[$header2_typedef_count]." ".$entry;
            }
            if ($entry =~ ".*;" ) {
                if ($l_verbose != 0) {
                    $fulline="";
                    $count=0;
                    if ($l_which eq 1) {
                        $fulline=$header1_typedef_names[$header1_typedef_count];
                        $count=$header1_typedef_count;
                    } else {
                        $fulline=$header2_typedef_names[$header2_typedef_count];
                        $count=$header2_typedef_count;
                    }
                    print "    store multiline typedef \$names[$count]<$fulline>\n";
                }
                $inMultiline=0;
                if ($l_which eq 1) {
                    $header1_typedef_count++;
                } else {
                    $header2_typedef_count++;
                }
            }
            next;
        }
        if ($expectStruct == 1) {
            $expectStruct=0;
            if ($l_verbose != 0) { print "    expect struct<$entry>\n" ; }
            if ($entry eq "\{" ) {
                $inStruct=1;
                if ($l_verbose != 0) { print "    struct found, inStruct=<$inStruct>\n" ; }
                next;
            }
            printf "%s: missing \{ in struct (%s) skipping\n", $l_header_file, $struct_name;
            # fall through and see if something else comes up
        }
        if ($inStruct == 1) {
            $entry_index=$struct_name."_".$current_row_count;
            $test=$_;
            if ($test =~ /\}\s+($idspec)/) {
                if ($l_which eq 1) {
                    $header1_typedef_struct_name{$struct_name}=$1;
                    $header1_typedef_struct_count{$struct_name}=$current_row_count;
                } else {
                    $header2_typedef_struct_name{$struct_name}=$1;
                    $header2_typedef_struct_count{$struct_name}=$current_row_count;
                }
                if ($l_verbose != 0) { print "    typedef struct name<$1> \$struct_name=$struct_name\n"; }
                $inStruct=0;
                $current_row_count=0;
                next;
            }
            # normalize
            $entry=~s/^\s+|\s+$//;
            if ($l_verbose != 0) {
                print "        struct entry<$entry>\n";
            }
            if ($l_which eq 1) {
                $header1_struct_value{$entry_index}=$entry;
            } else {
                $header2_struct_value{$entry_index}=$entry;
            }
            $current_row_count++;
            next;
        }
        @db = split(" ");
        if ($db[0] eq "#define") { # handle #defines
            if ($l_verbose != 0) { print "    is a define\n"; }
            $name=$db[1];
            $number=hex($db[2]);
            $comment=$db[4];
#            if ($comment eq "Deprecated") {
#                if ($l_verbose != 0) { print "    Deprecated\n"; }
#                next; # skip deprecated defines 
#            }
#            if ($comment eq "Historical") {
#                if ($l_verbose != 0) { print "    Historical ID\n"; }
#                next; # skip historical defines, they are documented in
#                      # the historical algorithms spec.
#            } 
#            if ($comment eq "Profile") {
#                if ($l_verbose != 0) { print "    Profile ID\n"; }
#                next; # skip profile ID, they are documented
#                      # profile spec.
#            } 
            $test=$number;
            if ($test =~ /^CK$idspec/) {
                if ($l_verbose != 0) { print "    skipping alias $name=$number\n"; }
                next; # skip aliases
            }
            # Some attributes have the CKF_ARRAY_ATTRIBUTE flag
            $test=$db[2];
            if (($number == 0) and 
                ($test =~ /\(CKF_ARRAY_ATTRIBUTE\|(.*)\)/)) {
                $number=hex($1);
                if ($l_verbose != 0) {
                    print "    $name=CKF_ARRAY_ATTRIBUTE|$1 = $number (no spaces)\n";
                }
            }
            if (($number == 0) and ($db[2] eq "(CKF_ARRAY_ATTRIBUTE")) {
                $test=$_;
                $test =~ /.*\(\s*CKF_ARRAY_ATTRIBUTE\s*\|\s*(.*)\).*/;
                $number=hex($1);
                if ($l_verbose != 0) {
                    print "    $name= CKF_ARRAY_ATTRIBUTE|$1 = $number (with spaces)\n";
                }
            }
            # handle a substitution 
            if (($number == 0xc) and (substr($db[2],0,2) eq "CK")) {
                if ($l_verbose != 0) { print "    substitution\n"; }
                if ($l_which eq 1) {
                    $number = $header1_number{$db[2]};
                } else {
                    $number = $header2_number{$db[2]};
                }
            }
            if ($l_which eq 1) {
                $header1_number{$name} = $number;
                $header1_found{$name} = 0;
                $header1_present{$name} = 1;
                $header1_line{$name} = $_;
            } else {
                $header2_number{$name} = $number;
                $header2_found{$name} = 0;
                $header2_present{$name} = 1;
                $header2_line{$name} = $_;
            }
            if ($l_verbose != 0) {
                printf "    store define %s=0x%x\n", $name, $number;
            }
            # give VENDER_DEFINED a pass 
#            if (($number == 0x80000000) && (substr($name,4) eq "VENDOR_DEFINED")) {
#                if ($l_verbose != 0) { print "    vendor_defined\n"; }
#                $header_found{$name} = 1;
#            }
#            next;
        }
        if ($db[0] eq "typedef") {
            if ($l_verbose != 0) { print "    is a typedef\n"; }
            if ($db[1] eq "struct") {
                if ($l_verbose != 0) { print "    is a struct\n"; }
                if (($db[3] ne "") && ($db[3] ne "\{")) {
                    # skip normal typedefs alias;
                    if ($l_which eq 1) {
                        $header1_typedef_names[$header1_typedef_count]=$entry;
                    } else {
                        $header2_typedef_names[$header2_typedef_count]=$entry;
                    }
                    $test=$entry;
                    if ($test !~ /.*;$/) {
                        $entry =~ s/\\$//;
                        $entry=~s/^\s+|\s+$//;
                        if ($l_which eq 1) {
                            $header1_typedef_names[$header1_typedef_count]=$entry;
                        } else {
                            $header2_typedef_names[$header2_typedef_count]=$entry;
                        }
                        $inMultiline=1;
                        next;
                    }
                    if ($l_which eq 1) {
                        $header1_typedef_count++;
                    } else {
                        $header2_typedef_count++;
                    }
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
                if ($l_which eq 1) {
                    $header1_typedef_names[$header1_typedef_count]=$entry;
                } else {
                    $header2_typedef_names[$header2_typedef_count]=$entry;
                }
                $inMultiline=1;
                next;
            }
            $count=0;
            if ($l_which eq 1) {
                $count=$header1_typedef_count;
            } else {
                $count=$header2_typedef_count;
            }
            if ($l_which eq 1) {
                $header1_typedef_names[$header1_typedef_count]=$entry;
                $header1_typedef_count++;
            } else {
                $header2_typedef_names[$header2_typedef_count]=$entry;
                $header2_typedef_count++;
            }
            if ($l_verbose != 0) {
                $fulline="";
                if ($l_which eq 1) {
                    $fulline=$header1_typedef_names[$count];
                } else {
                    $fulline=$header2_typedef_names[$count];
                }
                print "    store typedef \$names[$count]<$fulline>\n";
            }
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

sub print_header_typedefs
{
    my ($l_which, $l_verbose)=@_;
    my $count=0;
    if ($l_which eq 1) {
        $count=$header1_typedef_count;
    } else {
        $count=$header2_typedef_count;
    }
    for my $i (0..($count-1)) {
        print "[$i]";
        if ($l_which eq 1) {
            printf "%s\n", $header1_typedef_names[$i];
        } else {
            printf "%s\n", $header2_typedef_names[$i];
        }
    }
}

sub print_header_structs
{
    my ($l_which, $l_verbose)=@_;
    my @_keys={};
    if ($l_which eq 1) {
        @_keys=keys %header1_typedef_struct_name;
    } else {
        @_keys=keys %header2_typedef_struct_name;
    }
    foreach (@_keys)  {
        $index=$_;
        printf " typedef struct %s \{\n", $index;
        $count=0;
        if ($l_which eq 1) {
            $count=$header1_typedef_struct_count{$index};
        } else {
            $count=$header2_typedef_struct_count{$index};
        }
        for my $i (0..($count-1)) {
            $entry_index=$index."_".$i;
            if ($l_which eq 1) {
                printf "   %s\n", $header1_struct_value{$entry_index};
            } else {
                printf "   %s\n", $header2_struct_value{$entry_index};
            }
        }
        if ($l_which eq 1) {
            printf " \} %s;\n", $header1_typedef_struct_name{$index};
        } else {
            printf " \} %s;\n", $header2_typedef_struct_name{$index};
        }
        printf " -----------------------------------------------------------------------------------\n";
    }
}

sub print_header_defines
{
    my ($l_which, $l_verbose)=@_;
    my @_keys={};
    if ($l_which eq 1) {
        @_keys=$header1_number;
    } else {
        @_keys=$header2_number;
    }
    foreach (sort @_keys)  {
        $name=$_;
        if ($l_which eq 1) {
            printf "#define %-40s 0x%08xUL\n", $name, $header1_number{$name};
        } else {
            printf "#define %-40s 0x%08xUL\n", $name, $header2_number{$name};
        }
    }
}

sub print_diff_defines
{
    foreach (sort keys %header1_present)  {
        $name=$_;
        if ($header2_present{$name} == 0) {
            printf "#define %-40s 0x%08xUL missing from header2 %s\n",
                   $name, $header1_number{$name}, $header2;
        } else {
            if ($header1_number{$name} != $header2_number{$name} ) {
                printf "#define %-40s mismatched values, %s=0x%08xUL %s=0x%08xUL\n",
                       $name, $header1,  $header1_number{$name}, $header2, $header2_number{$name};
            }
        }
    }
    foreach (sort keys %header2_number)  {
        $name=$_;
        if ($header2_present{$name} == 0) {
            printf "#define %-40s 0x%08xUL missing from header1 %s\n",
                   $name, $header2_number{$name}, $header1;
        }
    }
}

sub print_diff_structs
{
    foreach (sort keys %header1_typedef_struct_name)  {
        $index=$_;
        if ( $header2_typedef_struct_name{$index} eq "" ) {
            $test=$index;
            printf "missing struct '%s' in header2 %s\n", $index, $header2;
            next;
        }
        if ( $header1_typedef_struct_name{$index} ne $header2_typedef_struct_name{$index}) {
            printf "mismatched struct name %s : header2 %s=%s header1 %s=%s\n",
                   $index, $header2,
                   $header2_typedef_struct_name{$index},
                   $header1, $header1_typedef_struct_name{$index};
        }
        $count=$header1_typedef_struct_count{$index};
        $max=$header2_typedef_struct_count{$index};
        $sel=2;
        $header_file=$header2;
        if ($count != $max) {
           printf "mismatched struct entry count in struct %s:\n"
                      ."   header2 %d (%s)\n"
                      ."   header1 %d (%s)\n",
                       $index, $max, $header2, $count, $header1;
           if ($count > $max) {
               $tmp=$count;
               $count=$max;
               $max=$tmp;
               $sel=1;
               $header_file=$header1;
           }
        }
        for my $i (0..($count-1)) {
            $entry_index=$index."_".$i;
            if ( $header1_struct_value{$entry_index} ne $header2_struct_value{$entry_index}) {
                printf "mismatched struct entry in struct %s line %d:\n"
                      ."   header2 '%s' (%s)\n"
                      ."   header1 '%s' (%s)\n",
                       $index, $i, $header2_struct_value{$entry_index},
                       $header2, $header1_struct_value{$entry_index}, $header1;
            }
        }
        for my $i ($count..($max-1)) {
            $entry_index=$index."_".$i;
            $value="";
            if ($sel == 1 ) {
                $value=$header1_struct_value{$entry_index};
            } else {
                $value=$header2_struct_value{$entry_index},
            }
            printf "extra struct entry in struct %s line %d:\n"
                      ."   header%d '%s' (%s)\n",
                      $index, $i, $sel, $value, $header_file;
        }
    }

    foreach (sort keys %header2_typedef_struct_name)  {
        $index=$_;
        if ( $header1_typedef_struct_name{$index} eq "" ) {
            printf "struct '%s' missing in header1 %s\n", $index, $header1;
        }
    }
}

sub print_diff_typedefs
{
    print "typedef diffs from header1 ($header1) and header2($header2)\n";
    my $ckptr_count=0;
    my %header1_typedef_present=();
    my %header2_typedef_present=();
    for my $i (0..($header1_typedef_count-1)) {
        $header1_typedef_present{$header1_typedef_names[$i]}=1;
    }
    for my $i (0..($header2_typedef_count-1)) {
        $header2_typedef_present{$header2_typedef_names[$i]}=1;
    }
    foreach (sort keys %header1_typedef_present)  {
        $name=$_;
        if ($header2_typedef_present{$name} == 0) {
            printf "missing typedef (%s) from header2 %s\n", $name, $header2;
        }
    }
    foreach (sort keys %header2_typedef_present)  {
        $name=$_;
        if ($header1_typedef_present{$name} == 0) {
            $test=$name;
            printf "typedef (%s) missing from header1 %s\n", $name, $header1;
        }
    }
}

sub usage
{
    printf "Usage: %s [commands...] [header1_file] [header2_file]\n", Command;
    print " parse a doc text file and/or a header file and output according\n";
    print " to the command:\n";
    print "    verbose:  output debugging data\n";
    print "    verbose1:  output debugging data for header1_file processing\n";
    print "    verbose2:  output debugging data for header2_file processing\n";
    print "    defines:  all the defines in both the header1_file and header2_file\n";
    print "    typedefs:  all the typedefs in both the header1_file and header2_file\n";
    print "    structs:  all the structs in both the header1_file and header2_file\n";
    print "    header1_defines:  all the defines in the header1_file\n";
    print "    header1_typedefs:  all the typedefs in the header1_file\n";
    print "    header1_structs:  all the structs in the header1_file\n";
    print "    header1_all:  all the parsed values in the header1_file\n";
    print "    header2_defines:  all the defines in the header2_file\n";
    print "    header2_typedefs:  all the typedefs in the header2_file\n";
    print "    header2_structs:  all the structs in the header2_file\n";
    print "    header2_all:  all the parsed values in the header1_file\n";
    print "    diff_defines:  the differences betweeen the defines in the header1_file and the header2_file\n";
    print "    diff_typedefs: the differences between the typedefs in header1_file and header2_file\n";
    print "    diff_structs:  the differences between the structs in header1_file andthe header2_file\n";
    print "    diff_all:  all the diffs\n";
    print "if both files are required, the header1_file must be first, if no\n";
    print "commands are supplied, then diff_all is assumed\n";
}
