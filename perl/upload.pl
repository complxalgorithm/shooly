#!/usr/bin/perl

# form encoding has to be set to:
# enctype="multipart/form-data"
# so server knows that file upload is coming in through
# CGI interface

# input type "file" is enough to put browse button and
# text box into form

use strict;

use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);

my %input;

my $upload_dir = "/home/mgossland/temp";
my $max_size = 30_000;

my $cgi = new CGI;

print $cgi->header();

for my $key ( $cgi->param() ) {
	$input{$key} = $cgi->param($key);
}

if ( $input{upload_demo} =~ /\.(exe|asp|php|jsp|cgi|pl|aspx|config|asax|asa)$/ ) {
	die  "Invalid file extension. No executable file types permitted";
}

if ( length($input{upload_demo}) > 0  ) {

	#We are uploading a file with a name other than ""
	#get rid of the leading directories

	( my $file_name = $input{upload_demo} ) =~ s/.*\\//;
	my $upload_path = "$upload_dir/$file_name";

	# open output file
	open OUT, ">$upload_path" or die "Error opening $upload_path: $!";
	binmode OUT;

	my $buffer = '';
	my $size = 0;

	#In file handle context, upload_file is a file handle
	while (my $chars_read = read $input{upload_demo}, $buffer, 4096) {
		print OUT $buffer;
		$size += $chars_read;

		#if size is getting bigger than you want to handle, quit!
		if ( $size > $max_size ) {
			last;
		}
	}
	close OUT;

	if ( -z $upload_path or $size > $max_size ) {
		unlink $upload_path;
		die  "File size zero or bigger than allowed size";
	}
}

#build list of inline file choices
opendir(DIR, "$upload_dir");

my @files = readdir(DIR);
closedir DIR;

my $file_lines = "<p>".join ( "\n<br>", @files) ."\n";

my $html = "/home/mgossland/webapps/web2py/web2py/applications/perlcourse/views/cgi_use/upload_form.html";
open (HTML, $html)
	or die "Can't open upload_form page at $html: $!";

#make substitutions

while ( <HTML> ) {
	s/<!-- file_lines -->/$file_lines/;
	print;
}

close HTML;
