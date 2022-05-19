[![Actions Status](https://github.com/raku-community-modules/WhereList/actions/workflows/test.yml/badge.svg)](https://github.com/raku-community-modules/WhereList/actions)

NAME
====

WhereList - Simpler `where` constraints for items of lists

SYNOPSIS
========

```raku
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
```

DESCRIPTION
===========

Type-constraining elements of list parameters, attributes, and subsets can be done with `where` clauses, however, they can quickly get overly complex when you want to constraint using multiple requirements. This module addresses that problem!

EXPORTED SUBROUTINES
====================

sub all-items(+@matchers)
-------------------------

See SYNOPSIS for sample use.

Takes a list of matchers (anything that can be fed to [`.grep`](https://docs.raku.org/routine/grep). Returns a [`Callable`](https://docs.raku.org/type/Callable) that a `where` clause can use to check whether *all* items in a list match *all* of these matchers. Matchers will be checked in the order provided, short-circuiting as soon as a matcher fails. If an exception occurs during matching, it will be turned into a [`Failure`](https://docs.raku.org/type/Failure), gracefully failing the type check.

### Notes and tips

An empty list always matches the type constraint.

There's no thunking involved. `where all-items .so` is an error, as `.so` will be called on the list itself, not each of the elements and its return value will be used as a matcher. Use [`WhateverCode`](https://docs.raku.org/type/WhateverCode) instead: `where all-items *.so`.

All [`Seq`s](https://docs.raku.org/type/Seq) will be [cached](https://docs.raku.org/type/Seq).

Don't forget to add parens around the args when more params follow this routine (see `sub` example in SYNOPSIS).

Don't drink bleach.

AUTHOR
======

Zoffix Znet

COPYRIGHT AND LICENSE
=====================

Copyright 2017 Zoffix Znet

Copyright 2018 - 2022 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

