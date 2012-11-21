#!/usr/bin/perl
use LWP 5.64;
use JSON;

# Declare vars
my $browser = LWP::UserAgent->new;
my $url = 'http://xbmc:xbmc@127.0.0.1:8000/jsonrpc?request={"jsonrpc":"2.0","method":"Player.GetItem","params":{"playerid":1,"properties":["title","year","director","studio","season","episode","showtitle"]},"id":1}';
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
        Xchat::register( "xbmc now playing", $xmbc_version, "Now Playing XBMC", sub { } );
        Xchat::hook_command( "xb", \&xbmc );
}

sub xbmc {
  # Get information from XBMC
  $response = $browser->get($url);
  die "post failed" if (!defined $response);
  my $json_text = $response->content;

  $json = JSON->new->allow_nonref;
  $perl_scalar = $json->decode($json_text);
  # $pretty_printed = $json->pretty->encode( $perl_scalar );
  # print $pretty_printed;
  
  # Get now playing
	$showtitle = $perl_scalar->{'result'}->{'item'}->{'showtitle'};
	$season = $perl_scalar->{'result'}->{'item'}->{'season'};
	$episode = $perl_scalar->{'result'}->{'item'}->{'episode'};
	$title = $perl_scalar->{'result'}->{'item'}->{'title'};
	$year = $perl_scalar->{'result'}->{'item'}->{'year'};
	$director = $perl_scalar->{'result'}->{'item'}->{'director'}->[0];
	$studio = $perl_scalar->{'result'}->{'item'}->{'studio'}->[0];


  # Set NP var
  if ($season > 0){
    $np = $showtitle . " - " . $season . "x" . $episode . " - " . $title. " [" . $studio . "]";
    } else {
    $np = $title . " (" . $year . ") by " . $director . " [" . $studio . "]";
    }
  
  # Unset vars
  undef $title;
  undef $showtitle;
  undef $season;
  undef $episode;
  undef $year;
  undef $director;
  undef $studio;
  undef $type;
  
  # Output to active window in xchat
  if (defined $np){		
	Xchat::command("me np: $np");
	}
  return 1;
}

