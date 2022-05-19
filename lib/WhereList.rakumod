my sub all-items(+@matchers) is export {
    sub (\v) {
        quietly {
            CATCH { default { .fail } }
            v.cache if v ~~ Seq:D;
            for @matchers -> \matcher {
                matcher.cache if matcher ~~ Seq:D;
                return False
                  unless v.elems == v.grep: matcher;
            }
        }
        True
    }
}

=begin pod

=head1 NAME

WhereList - Simpler C<where> constraints for items of lists

=head1 SYNOPSIS

=begin code :lang<raku>

use WhereList;

subset StrArray of Array where all-items Str, *.chars ≥ 3, *.contains: any <o a e>;

say [<foo bar meow>] ~~ StrArray; # OUTPUT: «True␤»
say ['dddrrrrrrrrr'] ~~ StrArray; # OUTPUT: «False␤»
say [<ha ha ha ha >] ~~ StrArray; # OUTPUT: «False␤»
say [<ooh come onn>] ~~ StrArray; # OUTPUT: «True␤»

class Foo {
    has @.bar where all-items any Str|Nil|Int:D, * === Any
}

sub foo (
    @meows where all-items(/meow/), # <-- use parens to avoid gobbling of params that follow
    @barks where all-items(/woof/) = ['woof'], # <-- or to add defaults
) {
    …
}

=end code

=head1 DESCRIPTION

Type-constraining elements of list parameters, attributes, and subsets can be
done with `where` clauses, however, they can quickly get overly complex when
you want to constraint using multiple requirements. This module addresses that
problem!

=head1 EXPORTED SUBROUTINES

=head2 sub all-items(+@matchers)

See SYNOPSIS for sample use.

Takes a list of matchers (anything that can be fed to
L<C<.grep>|https://docs.raku.org/routine/grep>. Returns a
L<C<Callable>|https://docs.raku.org/type/Callable> that a C<where> clause
can use to check whether I<all> items in a list match I<all> of these matchers.
Matchers will be checked in the order provided, short-circuiting as soon as
a matcher fails. If an exception occurs during matching, it will be turned
into a L<C<Failure>|https://docs.raku.org/type/Failure>, gracefully failing
the type check.

=head3 Notes and tips

An empty list always matches the type constraint.

There's no thunking involved. C<where all-items .so> is an error, as C<.so>
will be called on the list itself, not each of the elements and its return
value will be used as a matcher. Use
L<C<WhateverCode>|https://docs.raku.org/type/WhateverCode> instead:
C<where all-items *.so>.

All L<C<Seq>s|https://docs.raku.org/type/Seq> will be
L<cached|https://docs.raku.org/type/Seq>.

Don't forget to add parens around the args when more params follow this
routine (see C<sub> example in SYNOPSIS).

Don't drink bleach.

=head1 AUTHOR

Zoffix Znet

=head1 COPYRIGHT AND LICENSE

Copyright 2017 Zoffix Znet

Copyright 2018 - 2022 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
