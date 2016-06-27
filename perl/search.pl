#!/usr/bin/perl

# name a div tag "search_term" and include
# this script in your project for a search bar

use CGI;
use CGI::Carp qw(fatalsToBrowser);

use File::Find;

$cgi=new CGI();

print $cgi->header();

$search_term = $cgi->param('search_term');
$page        = $cgi->param('page');

if ( $^O eq "MSWin32" ) {
	( $root_dir = $ENV{PATH_TRANSLATED} ) =~ s/cgi-bin.*//;
	$root_dir =~ s|\\|/|g;
} else {
	$root_dir = $ENV{DOCUMENT_ROOT};
	$root_dir = "/home/mgossland/webapps/web2py/web2py/applications/perlcourse/views/"
}

$root_dir =~ s|/$||; #get rid of trailing slash

$html_lines= "";

#specify directories to avoid searching
$excluded = "cgi-bin|_vti_|music|fun|templates";

#walk the directory tree;
#open the file and look for the term

find( \&search, $root_dir ) if $search_term;

$html_lines ||= "<tr><td>No results found</td></tr>";

$search_results = qq{<table border="0" width="100%" align="center">}
                   .$html_lines.qq{</table>};

#open the requested page to put in the results
open (RESULTS, "$root_dir/$page") or die "Can't open results page ($root_dir/$page): $!";

#substitute the search results
#and replace the search term too.
while ( <RESULTS> ) {

	s{<!-- search_results -->}{$search_results};

	s{name="search_term"\s*?value=""}
	 {name="search_term" value="$search_term"};

	print;

}

close RESULTS;

#----- Sub to find search term and build html strings
sub search() {

	$seen = 0;

	$URL = $File::Find::name;

	if ( $URL !~ m/$excluded/ and -f and /.html?/ ) {

		$file = $_;
		open FILE, $file;
		@lines = <FILE>;
		close FILE;

		#grab the title, and the file name
		#could even grab some context,
		#but it gets trickier

		for ( @lines ) {

			$title = $1 if m|<title>(.*?)</title>|;

			$seen++ if /\Q$search_term\E/;

		}

		if ( $seen ) {

			#$root_dir = "/home/mgossland/webapps/web2py/web2py/applications/perlcourse/views"
			$URL =~ s|$root_dir|/perlcourse|;

			#format the found results into URL, title
			$html_lines .= qq{<tr><td><a href="$URL">$URL</a>};
			$html_lines .= qq{</td><td>$title</td></tr>\n};
		}
	}
}
