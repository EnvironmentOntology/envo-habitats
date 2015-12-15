#!/usr/bin/perl
while(<>) {
    my @vals = split(/\t/,$_);
    print "$vals[6] $vals[7]\n";
}
