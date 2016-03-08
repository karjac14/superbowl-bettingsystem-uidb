#!/Users/karloe/perl5

use strict;
use warnings;

use XML::Simple;
use JSON::XS qw(encode_json decode_json);
use JSON::Parse;
use Dancer;
use Dancer::Plugin::RequireSSL;

require_ssl();
# use Dancer::Response;
# use Dancer::Plugin::CORS;

# use JSON;
# use XML::XML2JSON;
# use Google::Data::JSON;
# use LWP::Simple;
# use Data::Dumper;


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




sub convertXMLtoJSON {
  # Create a XML Simple object, keeping the root tag.
  my ($raw) = @_;
  my $xml = new XML::Simple(KeepRoot => 1);

  # Load-in the xml file in object
  my $dataXML = $xml->XMLin($raw);

  # convert xml object in json.
  my $json = encode_json($dataXML);

  return $json;
}

sub convertJSONtoXML {
  # Create a XML Simple object, keeping the root tag.
  my ($raw) = @_;
  my $xml = new XML::Simple(KeepRoot => 1);

  # Load-in the xml file in object
  my $dataXML = $xml->XMLin($raw);

  # convert xml object in json.
  my $json = encode_json($dataXML);

  return $json;
}


sub getgame {
  return &convertXMLtoJSON($game_url);
}

sub getbets {
  return &convertXMLtoJSON($bets_url);
}


#listeners

get '/game' => sub {
    header 'Access-Control-Allow-Origin' => '*';
    my $game = &getgame();
    return $game;
};


get '/bets' => sub {
    header 'Access-Control-Allow-Origin' => '*';
    my $bets = &getbets();
    return $bets;
};

post '/newbet' => sub {
    header 'Access-Control-Allow-Origin' => '*';
    my $json = request->body;
    my $p = decode_json $json;
    #convert json to hash
    #create control number and process
    #add (push) json to db
    return $p;
    # &print($p);
};

# whew... preflight check by chrome need to fulfill.
options '/newbet' => sub {
    header 'Access-Control-Allow-Origin' => '*';
    header 'Access-Control-Allow-Headers' => 'Content-Type' => 'text/plain';
};
dance;
