#!/usr/bin/env perl
#
# Automatically create ebuild for Perl module
#
# Usage: create_ebuild.pl <module name>
#
# Ex.: create_ebuild.pl HTTP::Tiny
#
# Copyright (c) 2011 Xiaodong Xu <xxdlhy@gmail.com>
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
use HTTP::Tiny;
use JSON;
use autodie;


# Get module infomation, get_module_info($module)
sub get_module_info {
    my $module     = shift;
    my $url        = "http://api.metacpan.org/module/$module";
    my $http       = HTTP::Tiny->new;
    my $response   = $http->get($url);
    my $content    = $response->{content};
    my $json       = JSON->new;
    my $info_ref   = $json->decode($content);
    my $source_ref = $info_ref->{_source};

    return (
        $source_ref->{distname}, $source_ref->{author},
        $source_ref->{version},  $source_ref->{abstract}
    );
}


# Create ebuild file, create_ebuild($module)
sub create_ebuild {
    my $module = shift;
    my ( $name, $author, $version, $abstract ) = get_module_info($module);
    my $ebuild = << "TEMPLETE";
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=3

MODULE_AUTHOR=$author
MODULE_VERSION=$version
inherit perl-module

DESCRIPTION="$abstract"

LICENSE="perl 5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_TEST="do"
TEMPLETE

    my $root_path = '/usr/local/portage/dev-perl';
    chdir $root_path;

    mkdir $name;
    chdir $name;

    open my ($out_fh), '>', "$name-$version.ebuild";
    print $out_fh $ebuild;
    close $out_fh;

    system "ebuild", "$name-$version.ebuild", "manifest";
}


# Main program
sub main {
    my ($module) = @ARGV;

    die "Usage: $0 <module name>\n" unless $#ARGV == 0;
    create_ebuild($module);
}


main() unless caller;


__END__

=pod

=head1 NAME

create_ebuild.pl - Automatically create ebuild for Perl module

=head1 SYNOPSIS

create_ebuild.pl <module name>

=head1 AUTHOR

Xiaodong Xu <xxdlhy@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Xiaodong Xu.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

=cut
