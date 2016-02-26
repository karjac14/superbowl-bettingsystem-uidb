#!/usr/bin/perl5

use strict;
use warnings;
use Data::Dumper;



#Database
my $team1 = "Denver Broncos";
my $team2 = "Carolina Panthers";
my $event = 'Super Bowl LI';
my $date = 'February 5, 2017';

my @bets = ({"team" => 1, "bet" => 200, "controlno" => "ABCD1234"},
            {"team" => 2, "bet" => 200, "controlno" => "ABCD1232"},
            {"team" => 1, "bet" => 100, "controlno" => "ABCD123B"});







sub back {
  print("\n\nPress 'Enter' to go back main menu\n\n");
  my $back = <STDIN>;
  if ($back =~ /\S\s/ || $back =~ /\n/){
  &start;
  }
}

sub betfactors {
  my $team1bets;
  my $team2bets;
  foreach my $x (0..$#bets) {
    if ( $bets[$x]{"team"} eq 1 ){
      $team1bets += $bets[$x]{"bet"};
    }
    elsif ( $bets[$x]{"team"} eq 2 ){
      $team2bets += $bets[$x]{"bet"};
    }
  }
  return ($team2bets/$team1bets,$team1bets/$team2bets);
}


sub seebets {
  my @factors = betfactors;
  my $potential_winning1 = $factors[0] * 100;
  my $potential_winning2 = $factors[1] * 100;

  print("The betting period is on going...\n");
  print("Someone who had bet for $team1 with amount of \$100 will have a potential winning of \$" ); printf("%.2f", $potential_winning1);
  print("\nSomeone who had bet for $team2 with amount of \$100 will have a potential winning of \$" ); printf("%.2f", $potential_winning2);
  print("\nAs of the moment there are ", $#bets + 1, " bets confirmed.\n");
  print("Winnings may vary as the betting period goes on. Good Luck!\n\n");
  print("Press 'Enter' to go back main menu\n\n");
  my $back = <STDIN>;
  if ($back =~ /\S\s/ || $back =~ /\n/){
    &start;
  }
}



sub show {
  print("\n\n  Team           |  Control no.       |  Bet      |  Winning*  |");
  for my $href (@bets) {
    my @factors = &betfactors;
    my $winning;
    my $tn = $href->{"team"};
    if ($tn eq '1'){
      $tn = substr $team1, 0, 12;
      $winning = $href->{"bet"} * $factors[0];
    } elsif ($tn eq '2') {
      $tn = substr $team2, 0, 12;
      $winning = $href->{"bet"} * $factors[1];
    }
    print("\n  $tn   |  $href->{\"controlno\"}          |  \$ $href->{\"bet\"}    |  \$ "); printf("%.2f", $winning);
    print("  |");
  }
  print("\n\n   *winning amount may vary as betting period continues");
  return;
}

sub admin {
  print("Enter admin password:\n");
  my $pw = <STDIN>;
  chomp $pw;
  if ($pw eq "passme"){
    print "\033[2J";   #clear the screen
    print "\033[0;0H"; #jump to 0,0
    &show;
    &back;
  } else {
    &start;
  }
}

sub confirmbet {

  #confirm bets by getting last entry in DB
  #my $l = $#bets;
  my @factors = &betfactors;
  my $winning;
  my $confirmteam;

  if ($bets[-1]{"team"} eq 1){
    $winning = $bets[-1]{"bet"} * $factors[0];
    $confirmteam = $team1;
  } elsif ($bets[-1]{"team"} eq 2){
    $winning = $bets[-1]{"bet"} * $factors[1];
    $confirmteam = $team2;
  }

  print("Thank you for betting!\n",
        "You bet for $confirmteam with amount of $ @$bets[-1]{\"bet\"}\n",
        "Your potential winning will be: \$"); printf("%.2f", $winning);
  print("\nYour reference number is $bets[-1]{\"controlno\"}\n",
        "Good Luck!\n");
  &back;
}

sub recordbet {
  my ($choiceteam, $betamount) = @_;
  #generate unique control number
  my @chr = ('0' ..'9', 'A' .. 'Z');
  my $controlno = join ('', map $chr[rand @chr], 1 .. 8);
  push @bets, {team => $choiceteam, bet => $betamount, controlno => $controlno};
  #bet saved on DB
  &confirmbet;
}

sub getbet {
  print "Which team do you want to bet for?\n";
  print "[1] $team1\n[2] $team2\n";
  my $choiceteam = <STDIN>;
  chomp $choiceteam;

  print "How much you want to bet?\n";
  print "\$";
  my $betamount = <STDIN>;
  chomp $betamount;
  print "\n";
  if (($choiceteam eq 1 || $choiceteam eq 2) && ($betamount*1 eq $betamount)) {
    &recordbet($choiceteam, $betamount);
  } else {
    print "invalid team choice or bet amount";
    &back;
  }
  print "############################################\n\n";
}

sub start {
  print "\033[2J";   #clear the screen
  print "\033[0;0H"; #jump to 0,0

  print("Welcome to Betting System for\n",
          "$event\n",
          "$date\n",
          "$team1 vs. $team2\n\n");

  print("Choose what to do:\n",
          "[1] Place a Bet\n",
          "[2] See Betting Status\n\n",
          "[3] Admin\n");
  my $choice = <STDIN>;
  chomp $choice;
  print "\n";
  print "############################################\n\n";

  if ($choice eq 1) {
    &getbet;
  }
  elsif ($choice eq 2){
    &seebets;
  }
  elsif ($choice eq 3){
    &admin;
  }
  else {
    print "invalid choice";
    back;
  }
}

start;
