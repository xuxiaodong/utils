#!/usr/bin/env perl
#
# Add author to MOBI
#
# Usage: set_mobi_author.pl <author> <MOBI>
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
use FindBin qw($RealBin);
use lib "$RealBin";
use Palm::PDB;
use Palm::Doc;
use MobiPerl::MobiHeader;
use MobiPerl::Util;

my $author   = shift;
my $in_file  = shift;
my $out_file = $$ . 'mobi';

my $pdb = new Palm::PDB;
$pdb->Load($in_file);

my @records       = @{ $pdb->{records} };
my $r0            = $records[0];
my $palmdocheader = substr( $r0->{data}, 0, 16 );

my $mh = substr( $r0->{data}, 16 );
$mh = MobiPerl::MobiHeader::set_exth_data( $mh, "author", $author );

$r0->{data} = $palmdocheader . $mh;

$pdb->{type}    = "BOOK";
$pdb->{creator} = "MOBI";

$pdb->Write($out_file);

rename $out_file => $in_file;
