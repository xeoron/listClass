ListClass.pl
========
Given X number of sourcecode files display a list of all the classes and subroutines declarations found. 

This is a quick and dirty script. Currently, the code looks patterns for function\method calls regardless 
of checking the language in the file, but if there is a next version it will have language detection and 
act accordingly.

Some of the Supported Languages
	
	Applescript
	Awk
	Bash
	C
	C++
	Dart
	Go
	Lisp
	Fortran
	Java
	Javascript
	MatLab
	Perl
	PHP
	Python
	Ruby
	Scheme
	TCL
	Visual Basic
	
Limitations

	Missing detection of functions that use structs or generics. 
	Example of what it can't detect: FOO Bar(FOO T)	

Usage
=====
    
	listClass.pl file1.py file2.pl file3.java file4.sh
    
   Example reading 3 different files
  
     listClass.pl woof.py frenamer.pl twitterstream.py
    
   Results

     ..\woof.py:(7)
	 ===========
 	  def find_ip ():
 	  class FileServHTTPRequestHandler (BaseHTTPServer.BaseHTTPRequestHandler):
  	  def log_request (self, code='-', size='-'):
  	  def do_GET (self):
 	  def serve_files (filename, maxdown = 1, ip_addr = '', port = 8080):
 	  def usage (defport, defmaxdown, errmsg = None):
 	  def main ():
   
     ..\frenamer\frenamer.pl:(15)
	 ========================
	  sub sig_handler{ 	#capture Ctrl+C signal
      sub cmdlnParm(){	#display the program usage info 
      sub confirmChange($$){ #ask if pending change is good or bad. Parameters $currentFilename and $newFilename
      sub getPerms($){ 	#get file permisions in *nix format. Parameter=$file to lookup
      sub fRename($){ 	#file renaming... only call this when not crawling any subfolders. Parameter = $folder to look at
      sub _transLC($){ 	#take a tokenized char and make it lower case
      sub _transLC($) { 	#make-lower-case
      sub _transToken($){	 #filter token
      sub _translateWL($){    #translate 1st letter of each word to uppercase
      sub _translate($){	#translate case either up or down. Parameter = $file
      sub _rFRename($){ 	#recursive file renaming processing. Parameter = $file
      sub _untaintData ($$){	#dereference any reserved non-word characters. Parameter = string of data to untaint, flag
      sub untaintData(){		#sanitize provided input data
      sub bool ($){	return (shift >=1) ? "On" : "Off";  } #translate boolean to On or Off for user verbose settings mode
      sub main(){
   
    .\twitterStream.py:(6)
	===================
      class TwitterStream:
      def __init__(self):
      def setup_connection(self):
      def get_oauth_header(self):
      def start(self):
      def handle_tweet(self, data):
	
