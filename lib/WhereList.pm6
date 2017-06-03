unit module WhereList;
sub all-items (+@matchers) is export {
    sub (\v) {
        quietly {
            v.cache if v ~~ Seq:D;
            for @matchers -> \matcher {
                matcher.cache if matcher ~~ Seq:D;
                v.elems == v.grep: matcher or return False
            }
        }
        True
    }
}
