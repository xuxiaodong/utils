#!/usr/bin/env perl
#
# Add file header
#
# Usage: add_file_header.pl <symbol> <filename>
#
# Copyright (C) 2011 Xiaodong Xu <xxdlhy@gmail.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA

use Modern::Perl;
use POSIX qw(strftime);
use Tie::File;
use autodie;

unless ( $#ARGV == 1 ) {
    ( my $me = $0 ) =~ s!.*/!!;
    die "Usage: $me <symbol> <filename>\n";
}

my $symbol      = shift;
my $file        = shift;
my $symbol_line = $symbol x 50;
my $date        = strftime "%d/%m/%g %H:%M:%S", localtime;
my $line        = <<"LINE";
$symbol_line
$symbol
$symbol File:           $file
$symbol Maintainer:     Xiaodong Xu <xxdlhy\@gmail.com>
$symbol Last modified:  $date
$symbol
$symbol_line


LINE

tie my @lines, 'Tie::File', $file;
unshift @lines, $line;
untie @lines;
