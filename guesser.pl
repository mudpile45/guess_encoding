#!/usr/bin/perl
use strict;
use Encode;
binmode STDOUT, ":utf8";

use constant FREQDIR => 'freqlists';
my @encodings = qw/utf8 big5 euc-cn utf-16 utf-16le utf-16be/; #encodings to check
my %freqs = get_freq_data(FREQDIR . "/freqlist-trad.utf8.txt");

my $infile = shift(@ARGV);
my $in_data = slurp_file($infile);

my @probs = calculate_probs($in_data);
print $probs[0];

sub calculate_probs {
    my $in_data = shift;
    my %results;
    foreach my $enc (@encodings) {
        my $score;
        eval {
            $score = get_prob_for($enc, $in_data);
            # print "Score for $enc: $score\n";
            $results{$enc} = $score;
        }
    }
    my @probs = sort {$results{$b} <=> $results{$a}} keys %results;
    return @probs;
}

# print "Score for big5: " . get_prob_for("big5", $in_data) . "\n";
# print "Score for gb2312: " . get_prob_for("gb2312", $in_data) . "\n";
# print "Score for utf-16: " . get_prob_for("utf-16", $in_data) . "\n";


sub get_prob_for {
    my ($enc, $in_data) = @_;
    my @in_chars = char_arr_for_str(decode($enc, $in_data));

    my $score = 0;
    for (my $i=0; $i < scalar(@in_chars); $i++) {
        my $cur_char = $in_chars[$i];
        # print "[$cur_char] = +" . $freqs{$cur_char}."\n";
        $score += $freqs{$cur_char};
    }
    return $score;
}

sub slurp_file {
    my $infile = shift;
    open DATA, $infile;
    my $in_data;
    {
        local $/;
        $in_data = <DATA>;
    }
    close DATA;
    return $in_data;
}

sub get_freq_data {
    # returns a hash of all the characters and their rank (based on position in
    # freq file)
    my $freq_file = shift;
    my @orig_chars = split("\n", decode("utf8", slurp_file($freq_file)));

    # Reverse the order of the array so that most frequent chars get highest
    # rank
    my @chars;
    for (my $i = scalar(@orig_chars); $i >= 0; $i--) {
        push(@chars, $orig_chars[$i]);
    }
    my %result;
    for (my $i=0; $i < scalar(@chars); $i++) {
        $result{$chars[$i]} = ($i + 1);
    }
    return %result;
}

sub char_arr_for_str {
    # returns an array of characters for a string
    my $in_str = shift;
    my @res;
    for (my $i=0; $i < length($in_str); $i++) {
        push(@res, substr($in_str, $i, 1));
    }
    return @res;
}

sub print_hash {
    my %freqs = @_;
    foreach my $key (keys(%freqs)) {
        print "$key: " . $freqs{$key} . "\n";
    }
}

sub print_arr {
    my @in_chars = @_;
    foreach (@in_chars) {
        print "$_\n"
    }
}
 
