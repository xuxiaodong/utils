#!/usr/bin/env perl
#
# Change PDF title and author
#
# Usage: set_pdf.pl -t <title> -a <author> <PDF>
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
use PDF::API2;
use Getopt::Long;
use autodie;

my ( $title, $author );
GetOptions(
    't|title=s'  => \$title,
    'a|author=s' => \$author,
);

my $pdf_file     = shift;
my $pdf          = PDF::API2->open($pdf_file);
my $is_encrypted = $pdf->isEncrypted;

unless ($is_encrypted) {
    if ( $title and $author ) {
        my %pdf_info = $pdf->info(
            Title  => $title,
            Author => $author,
        );

        say "PDF title changed to $pdf_info{Title}.";
        say "PDF author changed to $pdf_info{Author}.";

        $pdf->update();
    }
    else {
        ( my $me = $0 ) =~ s!.*/!!;
        say "Usage: $me -t <title> -a <author> <pdf>";
    }
}
