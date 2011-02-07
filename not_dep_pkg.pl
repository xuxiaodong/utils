#!/usr/bin/env perl
#
# Get orphan packages in Gentoo
#
# Usage: not_dep_pkg.pl
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
use autodie;

local $/ = "\n\n";

open my $in_fh, "emerge -av --depclean |";

my @pkgs;
while (<$in_fh>) {
    push @pkgs, $1 if m!/(.*?)\s.*\s+\@selected\n\n!;
}

close $in_fh;

say "Total ", scalar @pkgs, " packages:";
say for @pkgs;
