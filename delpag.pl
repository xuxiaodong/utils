#!/usr/bin/env perl
#
# Delete pages from PDF.
#
# Usage: delpag.pl <pagenums> <infile.pdf> <outfile.pdf>
#
# Copyright (C) 2010 Xiaodong Xu <xxdlhy@gmail.com>
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

use CAM::PDF;

my $pagenums = shift;
my $infile   = shift;
my $outfile  = shift;

sub delete_pages {
    my ( $pn, $in, $out ) = @_;

    my $pdf = CAM::PDF->new($in)
        or die "$CAM::PDF::errstr";

    unless ( $pdf->deletePages($pn) ) {
        die "Failed to delete pages.\n";
    }

    $pdf->cleanoutput($out);
}

sub usage {
    print "Usage: $0 <pagenums> <infile.pdf> <outfile.pdf>\n";
}

if ( defined $pagenums and defined $infile and defined $outfile ) {
    delete_pages( $pagenums, $infile, $outfile );
}
else {
    usage();
}
