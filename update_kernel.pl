#!/usr/bin/env perl
#
# Update kernel
#
# Usage: update_kernel.pl -v <version number> -r <revision number>
#
# Ex.: update_kernel.pl -v 2.6.37 -r 1
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
use File::Copy;
use Getopt::Long;

my $ver   = '';
my $r_ver = '';
my $help  = 0;

GetOptions(
    'v=s' => \$ver,
    'r=s' => \$r_ver,
    'h'   => \$help,
);

sub build_kernel {
    my ( $v, $r_v ) = @_;

    my $path = '/usr/src/linux';
    chdir $path;

    copy( "../.config", ".config" );
    system "make oldconfig";
    system "make && make modules_install";
    copy( "arch/i386/boot/bzImage", "/boot/kernel-$v-gentoo-r$r_v" );
    copy( ".config",                "../.config" );
}

sub build_module {
    system "module-rebuild rebuild";
}

sub edit_grub {
    my ( $v, $r_v ) = @_;

    my $line = <<"LINE";
title Gentoo Linux $v-r$r_v
root (hd0,0)
kernel /boot/kernel-$v-gentoo-r$r_v root=/dev/sda3 video=uvesafb:mtrr:3,ywrap,1440x900-32\@75
LINE

    open my $grub_conf, '+<', '/boot/grub/grub.conf';
    seek( $grub_conf, 424, 0 );
    say $grub_conf $line;

    close $grub_conf;
}

if ($help) {
    ( my $me = $0 ) =~ s!^.*/!!g;

    say <<"USAGE";

    Usage: $me -v <ver> -r <r_ver> -h

    -v version number
    -r revision number
    -h show this help
USAGE

    exit;
}

if ( $ver and $r_ver ) {
    build_kernel( $ver, $r_ver );
    build_module;
    edit_grub( $ver, $r_ver );
}
else {
    say "Oops...";
}
