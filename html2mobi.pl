#!/usr/bin/env perl
#
# Convert HTML to MOBI format
#
# Usage: html2mobi.pl -s <start> -e <end> -t <title> -a <author> -h
#
#       -s start    Trim start lines of HTML
#       -e end      Trim end lines of HTML
#       -t title    Specify title
#       -a author   Specify author
#       -h          Display help
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
use Tie::File;
use Getopt::Long;
use autodie;


# Trim HTML -- trim_html $start, $end
sub trim_html {
    my ( $start, $end ) = @_;

    opendir my ($dir_fh), '.';
    my @files = grep {/\.html?/} readdir $dir_fh;

    for my $file (@files) {
        tie my @lines, 'Tie::File', $file;

        @lines = @lines[ $start .. ( @lines - ( $end + 1 ) ) ];

        for (@lines) {
            s///g;
            s/bgcolor="black"\s//;
            s/\A<UL>(<p)/$1/;
        }

        untie @lines;
    }
}


# Cat HTML -- cat_html $title
sub cat_html {
    my $title    = shift;
    my $filename = $title . '.html';

    open my ($in_fh), '<', 'filenames';
    my @names = <$in_fh>;

    for (@names) {
        chomp;
        system "cat $_ >> \Q$filename\E";
    }

    close $in_fh;

    tie my @lines, 'Tie::File', $filename;
    my $html_header
        = "<html>\n<head>\n<title>$title</title>\n</head>\n<body>";
    my $html_footer = "</body>\n</html>";

    unshift @lines, $html_header;
    push @lines, $html_footer;

    untie @lines;
}


# Make MOBI -- make_mobi $title
sub make_mobi {
    my $title     = shift;
    my $html_file = $title . '.html';

    system "kindlegen \Q$html_file\E";
}


# Add author to MOBI -- add_mobi_author $title, $author
sub add_mobi_author {
    my ( $title, $author ) = @_;
    my $mobi_file = $title . '.mobi';

    system "set_mobi_author.pl \Q$author\E \Q$mobi_file\E";
}


# Main prog
my ( $start, $end, $title, $author, $help ) = ( 0, 0, '', '', 0 );

GetOptions(
    's|start=i'  => \$start,
    'e|end=i'    => \$end,
    't|title=s'  => \$title,
    'a|author=s' => \$author,
    'h|help'     => \$help,
);

if ($help) {
    ( my $me = $0 ) =~ s!.*/!!g;
    say <<"USAGE";

    Usage: $me -s <start> -e <end> -t <title> -a <author> -h

    -s <start>  Trim start lines of HTML
    -e <end>    Trim end lines of HTML
    -t <title>  Specify title
    -a <author> Specify author
    -h          Display help
USAGE
}

if ( $start and $end ) {
    trim_html $start, $end;
}

if ($title) {
    cat_html $title;
    make_mobi $title;

    add_mobi_author $title, $author if $author;
}


__END__

=pod

=head1 NAME

html2mobi.pl - Convert HTML to MOBI format

=head1 VERSION

version 0.01

=head1 SYNOPSIS

html2mobi.pl -s <start> -e <end> -t <title> -a <author> -h

=head1 AUTHOR

Xiaodong Xu <xxdlhy@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Xiaodong Xu.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

=cut
