#!/Users/karloe/perl5

use strict;
use warnings;

use XML::Simple;

use JSON::XS qw(encode_json decode_json);
use JSON::Parse ':all';
use Dancer;
use Dancer::Plugin::RequireSSL;

use Test::Simple tests => 2;
use Data::Dumper;

require_ssl();



#Database
my $team1 = "Denver Broncos";
my $team2 = "Carolina Panthers";
my $event = 'Super Bowl LI';
my $date = 'February 5, 2017';

my @bets = ({"team" => 1, "bet" => 200, "controlno" => "ABCD1234"},
            {"team" => 2, "bet" => 200, "controlno" => "ABCD1232"},
            {"team" => 1, "bet" => 100, "controlno" => "ABCD123B"});

my $game_url = "../data/game-info.xml";
my $bets_url = "../data/game-bets.xml";


#Converters (XML,JSON,HASH)

sub convertXMLtoJSON {
  # Create a XML Simple object, keeping the root tag.
  my ($raw) = @_;
  my $xml = new XML::Simple(KeepRoot => 1);

  # Load-in the xml file in object
  my $dataXML = $xml->XMLin($raw);

  # convert xml object to json.
  my $json = encode_json($dataXML);

  return $json;
}

sub convertJSONtoXML {
  # Create a XML Simple object, keeping the root tag.
  my ($raw) = @_;
  my $xml = new XML::Simple(KeepRoot => 1);

  # Load-in the xml file in object
  my $dataXML = $xml->XMLin($raw);

  # convert xml object to json.
  my $json = encode_json($dataXML);

  return $json;
}

sub convertJSONtoHASH {
  my ($raw) = @_;
  return parse_json ($raw);
}



sub getgame {
  return &convertXMLtoJSON($game_url);
}

sub getbets {

  my $json_str = encode_json(\@bets);
  return $json_str;

  #for use later xml to json
  # return &convertXMLtoJSON($bets_url);
}

sub newbet {
  my ($new_bet) = @_;
  my $newbet_ref = &convertJSONtoHASH($new_bet);
  my %newbet_hash = %{ $newbet_ref };

  #generate unique control number
  my @chr = ('0' ..'9', 'A' .. 'Z');
  my $controlno = join ('', map $chr[rand @chr], 1 .. 8);

  push @bets, {team => $newbet_hash{team}, bet => $newbet_hash{betAmount}, controlno => $controlno};

  my $json_str = encode_json(\@bets);
  return $json_str;
}


#listeners

get '/game' => sub {
    header 'Access-Control-Allow-Origin' => '*';
    my $game = getgame;
    return $game;
};


get '/bets' => sub {
    header 'Access-Control-Allow-Origin' => '*';
    my $bets = getbets;
    return $bets;
};

post '/newbet' => sub {
    header 'Access-Control-Allow-Origin' => '*';
    my $newbet_json = request->body;
    # my $newbet = &
    my $allbet = newbet($newbet_json);
    return $allbet;
    # &print($p);
};

# whew... preflight check by chrome need to fulfill.
options '/newbet' => sub {
    header 'Access-Control-Allow-Origin' => '*';
    header 'Access-Control-Allow-Headers' => 'Content-Type' => 'text/plain';
};

sub tests   {
    ok( 1 + 1 == 2 );

    my $newbet_json = ('{"betAmount":200,"team":1}');
    my $newbet = convertJSONtoHASH($newbet_json);
    my %newbethash = %{ $newbet };
    my @keys = keys %newbethash;
    my $size = @keys;
    ok(scalar $size == 2);

    exit;
}

print Dumper @ARGV;
my $myargs = @ARGV;
if ($myargs >= 1){
  tests;
}
else {
  dance;
}
