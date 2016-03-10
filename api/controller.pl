#!/Users/karloe/perl5

use strict;
use warnings;

use XML::Simple;
use XML::LibXML;
use JSON::XS qw(encode_json decode_json);
use JSON::Parse ':all';
use Dancer;
use Dancer::Plugin::RequireSSL;

use Test::Simple tests => 2;
use Data::Dumper;

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
  return &convertXMLtoJSON($bets_url);
}

sub newbet {
  my ($new_bet) = @_;
  my $newbet_ref = &convertJSONtoHASH($new_bet);
  my %newbet_hash = %{ $newbet };

  #generate unique control number
  my @chr = ('0' ..'9', 'A' .. 'Z');
  my $controlno = join ('', map $chr[rand @chr], 1 .. 8);

  #TODO: append new bet to XML

  my $parser = XML::LibXML->new();
  my $bets_details = $parser->parse_file($bets_url) or die;

  my $bet  = $bets_details->findnodes("bets")->[0];

  my $node = XML::LibXML::Element->new("bet");

  my $t = XML::LibXML::Element->new("team");
  my $tn = XML::LibXML::Text->new($newbet_hash{team});
  $t->addChild($tn);

  my $a = XML::LibXML::Element->new("amount");
  my $an = XML::LibXML::Text->new($newbet_hash{amount});
  $a->addChild($an);

  my $c = XML::LibXML::Element->new("controlno");
  my $cn = XML::LibXML::Text->new($controlno);
  $c->addChild($cn);

  $node->addChild($t);
  $node->addChild($a);
  $node->addChild($c);

  $bet->addChild($node);

  open(my $fh, '>', $bets_url);
  print $fh $bet;
  close $fh;



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
    my $newbet_json = request->body;
    # my $newbet = &
    newbet($newbet_json);
    return $newbet_json;
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
