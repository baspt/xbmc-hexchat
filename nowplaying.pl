#!/usr/bin/perl
use LWP::Simple;

# Declare vars
my $url = 
'http://user:pass@127.0.0.1:8000/xbmcCmds/xbmcHttp?command=getcurrentlyplaying';
my $showtitle;
my $title;
my $season;
my $episode;
my $year;
my $director;
my $studio;
my $np;
my $xmbc_version = 1;

initXBMC();

sub initXBMC {
        Xchat::register( "xbmc now playing", $xmbc_version, "Now Playing 
XBMC", sub { } );
        Xchat::hook_command( "xb", \&xbmc );
}

sub xbmc {
	my $content = get $url;
	
  die "get failed" if (!defined $content);
	# Get now playing
	if($content =~ m/<li>Show Title:(.*)/) {
		$showtitle = $1;
	}
	if($content =~ m/<li>Season:(.*)/) {
		$season = $1;
	}
    if($content =~ m/<li>Episode:(.*)/) {
		$episode = $1;
	}
    if($content =~ m/<li>Title:(.*)/) {
		$title = $1;
	}
  if($content =~ m/<li>Year:(.*)/) {
		$year = $1;
	}
  if($content =~ m/<li>Director:(.*)/) {
		$director = $1;
	}
  if($content =~ m/<li>Studio:(.*)/) {
		$studio = $1;
	}
	# Set NP var
	if (defined $showtitle){
		$np = $showtitle . " - " . $season . "x" . $episode . " - " 
. $title. " [" . $studio . "]";
	} else {
		$np = $title . " (" . $year . ") by " . $director . " [" . 
$studio . "]";
	}

	# Unset vars
	undef $title;
	undef $showtitle;
  undef $season;
  undef $episode;
  undef $year;
  undef $director;
  undef $studio;

	# Output to active window in xchat
	if (defined $np){		
    Xchat::command("me np: $np");
	}
	return 1;
}

