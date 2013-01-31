#!/usr/bin/perl
# Author: Jason Campisi
# File: listclass.pl
# CopyLeft: 2002 GPL v2 or higher
#
# Purpose: create a program that will read in X number of filenames and display
#  all the data in the file that is listed as public and private data and methods.
#  Why? Because text environments, such as, Vim lacks the ability to list them in text-box to the side like most IDE's.
#
# System requirements: Perl 5 or higher. Should be platform independent. 
# Tested on Perl 5.8.7 on Knoppix Linux 4.1+ & KUbuntu Linux 5.10+, Perl 5.16.2 on Windows 8
#
#NOTE: This is a quick and dirty script. Currently, the code looks for 
# function\method calls, regarless of language, but if there is a next 
# version it will have language detection and act accordingly. Until such time
# this is good enough for displaying method declarations in a terminal screen and 
# using VIM in another

use strict;
use Fcntl;
use constant LOCK_UN => '8';
use constant LOCK_EX => '2';
my $version ="v0.1.4 Date(9/17/2002)";

sub main(){
 usage() if( scalar(@ARGV)<=0 or ($ARGV[0]=~m/-(v|-version|h|-help)/i));
 
 my @result; 
 my $count=0;
 my %pattern = (
	def => qr/^\s*def\s+/,				#python, ruby, E
	sub => qr/^\s*sub\s+/,				#perl, visual basic
	class => qr/^\s*class\s+/,			#C, C++, Java, C#, Dartm  Asp.Net
	function1 => qr/^\s*function\s*\w+[\(|\{]/,	#javascript, php awk, bash, Lua, visual basic
	function2 => qr/^\s*function\s+/,		#awk, bash
	function3 => qr/^\s*function\s+\w+=\w+\(/,	#matlab
	func => qr/^\s*func\s*\w+\(/,			#Go
	on => qr/^\s*on\s*\w+\(/, 			#applescript
	onrun => qr/^\s*on\s*run/,	 		#applescript
	onopen=> qr/^\s*on\s*open/, 			#applescript droplet method
	private => qr/^\s*private\s+/,			#C, C++, Java, C#
	public => qr/^\s*public\s+/,			#C, C++, Java, C#
	protected => qr/^\s*protected\s+/,		#C, C++, Java, C#
	abstract => qr/^\s*abstract\s*\w+/,		#C, C++, Java, C#
	defun => qr/^\s*defun\s+/,
#	define => qr/^\s*\(define\s+/,			#Lisp, Scheme
	def => qr/^\s*\(def\w*\s+/,			#Lisp, Scheme, Clojure
	generic => qr/^\s*([A-Z])+\s+\w+\s*\(\s*$1/,	#generic to find: FOO Bar(FOO T)
	int => qr/^\s*int\s*\w+\(/,			#C,C++, Dart
	void => qr/^\s*void\s*\w+\(/,			#C,C++, Dart
	float => qr/^\s*float\s*\w+\(/,			#C,C++, Dart
	string => qr/^\s*string\s*\w+\(/,		#C,C++, Dart
	double => qr/^\s*double\s*\w+\(/,		#C,C++, Dart
	char => qr/^\s*char\s*\w+\(/,			#C,C++, Dart
	static => qr/^\s*static\s*/,			#C++, Dart
	procedure => qr/^\s*procedure\s+/,		#Ada, Pascal
	proc => qr/^\s*proc\s+/,			#tcl
	subroutine => qr/^\s*subroutine\s+\w+\s*\(/, 	#fortran
	recursivesubroutine => qr/^\s*recursive subroutine\s+\w+\s*\(/,	#fortran

	#note: add Opa support
	#missing detection of C-based langauge functions that use structs or generics. Exmaple: FOO Bar(FOO f)
	#language list: http://home.nvg.org/~sk/lang/lang.html
);

 while (my $file=shift @ARGV){
    if (-e $file && (-r $file) && !(-d $file)){#exists and not a directory
	$count=0; #track the # of method declarations found per file
	@result=();
        $result[0]="$file:";

	if (open (DATA,"<$file")){  until (flock(DATA, LOCK_EX)){ sleep .10; }  }
	else {  print " Error--Could not read the file $file: $!\n"; next; } 

	foreach(<DATA>){
	   next if ( m/^\s?$/ );          #if blank line, go to the next
	   s/^\s+/ / if (m/^\s+/);        #prune whitespaces before characters
	   s/\r$//g  if (m/\r\n$/g && $^O!=~m/mswin/i); #*nix doesn't need \r's
	   foreach my $k (keys %pattern){ #only 1 value needs to match
	       if ( m/$pattern{$k}/i ){
	            $count++;
		    $result[++$#result]=" $_";
		    last;
	       }#end if
	    }#end foreach
	}#end foreach
	flock (DATA, LOCK_UN);

	$result[0] = $result[0] . "($count)\n" . '=' x length($file . "1") . "\n";
	print @result; 
	print "\n" if ($#ARGV>=0); #add a blank newline between the current and next file to parse for methods
	undef @result;

    }else{ 
	print "File: '" .$file . "' can not be read or does not exist!\n"; 
    }

	#reset variables for next loops
 }#end while
}#end main

sub usage(){
  if ($ARGV[0]=~m/-(v|-version)/i){
	  print "listclass.pl $version\n"; 
  }else{

 print <<eof
listclass.pl $version handles n-number of file names.
 Usage: perl programName filename1 filename2
   listclass.pl <file_1 file_2 ... file_n>
  --help -h 		displays usage 
  --version -v		program version

 Searches for most class and methods declarations/headers in
      Ada, AppleScript, Asp.net, AWK, Bash, C?, C++?, C#?, Clojure, Dart, E, Fortran, 
      Go, Java?, JavaScript, Lisp, Lua, Matlab, Pascal, Perl, PHP, Pike?, Python, Ruby, 
      Scheme, Tcl, & Visual Basic
 Note: It does not check what language it is parsing. 
       ? marks denotes known partial support.
 listclass $version is released under the GPL version 2 or higher
eof
; 
 } #end else
 exit (1);
} #end usage

main();		#start program

__END__
