?> Based on RFC 4180 <?
@parse_csv:#s #has_header
    s @/`[has_header [#/`[header]>h [eol]`/ h] [#""] ?#]>maybe_hdr
         [record]>fstrec ([eol] [record]>otherrecs)* [eol]?`/
    maybe_hdr {fstrec, otherrecs..}

    @header:#/`[name]>fstname ("," [name]>othernames)*`/
        {fstname, othernames..}
    @record:#/`[field]>fstfield ("," [field]>otherfields)*`/
        {fstfield, otherfields..}
    @name: field
    @field:#/`[escaped]|[non_escaped]>f`/ f
    @escaped:#/`\" ([textdata]|{,\r\n}|[ddquote])*>s \"`/ s
    @non_escaped:#/`[textdata]*>s`/ s
    @ddquote:#"\"\"" "\""
    @eol:#nl\/`\r?\n`/ nl
    @textdata:#c\{_?(' ' >=)}\/{",~}/ c
