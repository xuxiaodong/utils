#!/usr/bin/env perl
#
# Convert POD to MOBI format
#
# Usage: pod2mobi.pl -t <title> -o <outfile>
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

use strict;
use warnings;

use Getopt::Long;

my ( $title, $outfile, $podfile, $return );

GetOptions(
    't|title=s'   => \$title,
    'o|outfile=s' => \$outfile,
);

$outfile .= '.epub';
$podfile = shift;
$return  = system "pod2epub -t '$title' -o $outfile $podfile";

unless ($return) {
    system "kindlegen $outfile 1&> /dev/null";
    unlink $outfile or warn "Could not delete $outfile: $!";
}
