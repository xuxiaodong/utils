#!/usr/bin/env perl
#
# Make symbolic link
#
# Usage: makelink.pl
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

my $root_path = '/home/xiaodong/proj/utils';
opendir my ($dir_fh), $root_path;
my @files = grep {/\.pl$/} readdir $dir_fh;
closedir $dir_fh;

FILE: for my $file (@files) {
    chdir '/home/xiaodong/bin';
    my $symlink_exist = eval { symlink "$root_path/$file", $file };
    if ($symlink_exist) {
        say "Creating $file.";
    }
    else {
        next FILE;
    }
}
