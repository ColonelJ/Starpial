# Starpial
## Introduction
Starpial is a stack-oriented (concatenative) functional logic programming language with object-oriented programming, recursive regular expressions, dependent types, refinement types and automatic parallelization based on transactions.

## Fundamentals
The primary data type in Starpial is the stack, represented by `{}`.  After a `{` you start performing computations from the new empty stack, and when `}` is reached everything on this stack is enclosed in a stack object.  You can also export fields from within the `{}` using `>identifier` and access them from outside using `.identifier`.  Alternatively, for dynamic or non-string keys you can use `>(expression)` and `.(expression)`.  The other fundamental data types in Starpial are booleans, signed/unsigned integers (of any bit width), IEEE754 floating-point numbers of any supported bit width, and UTF-8 octets (representing Unicode strings when bound together in a stack).

There is a special 'spill' operator for stack objects written as `..` that has the effect of emptying the contents of the stack object into the current stack.  Note that this may spill anywhere from zero to infinitely many objects since the evaluation of stacks is done lazily if possible.

Functions are first class in Starpial and are represented by quotations, written as `[]` containing the code to be executed; this is done using the 'apply' operator `#`.  Instead of writing `[]` you can simply write `:` and everything that follows is included in the quotation, plus any code on the following lines, provided it is indented more than the (extended) line the `:` itself occupies, and there is no `;`, which ends the quotation.  Any `#identifier` included at the beginning of a quotation represent local parameters which are immediately taken off the stack in reading order at the moment the quotation is applied.  Normal parameters are bound by value (forcing variables to be read) but you can also bind by reference using `#$identifier` which creates an alias to the variable it binds to.

A quotation or value can be assigned to a name using `@identifier` (or `!identifier`) and then when you use the word `identifier` the quotation is automatically applied (this is not the case for `#parameters` or `$variables` where you have to use `#` explicitly).  (If you want to force it not to be applied in any case you can use `\identifier` instead.)  With `$variables` you can reassign the value using either `=variable` or `variable =[value]` or more commonly the equivalent `variable =: value`.  If you use e.g. `!identifier` multiple times within the same scope, then it does not overwrite the value, it creates an alternative to it, i.e. when you use `identifier` it may on backtracking try one of the later options, useful for logical programming.  The difference between `!identifier` and `@identifier` is that the `@` form is considered final so any following definitions are not able to recursively refer to previous ones, hence normally you will have a chain of `!` bindings followed by a `@` one to complete the definition.

Since Starpial is concatenative, all functions and operators are postfix, meaning there is no operator precedence to worry about.  Parentheses therefore have a special purpose, which is to assert that everything within `()` has the effect of adding one item to the stack - this makes the code much easier to read.  You can also use `::` instead of parentheses, which follows the same indentation rules as `:` does for `[]`.  To assert multiple values adding to the stack you can simply separate them by commas as in `(1,2,3)` and a trailing comma is allowed but not necessary (these comma assertions are also usable within stacks but needs the trailing comma to be fully equivalent as in `{1,2,3,}`).  A completely empty `()` does not do anything, `( ;)` asserts that zero items are added to the stack since the last comma and `( ;;)` does not assert anything for after the last comma.  Finally there are special forms of the `..` operator described above, `..,` and `...` which are expressly permitted to add an unknown number of items to the stack, the `..,` allows you to carry on using `,` afterwards, and `...` is useful at the end just before `)`.

To make code more readable it is possible to prefix words onto any of `[]` `{}` `()` `:` or `::` (leaving no spaces!) and this results in the word jumping to far end of the bracket, therefore turning a postfix function into a prefix one.  This combined with the special rules for `()` means you can write function applications in the familiar `f(x,y)` style.  This also works with operators if they are surrounded by underscores e.g. `(2)_*_(3)` so you can write more readable mathematical expressions e.g. combining styles you can write `((-b)_+_(sqrt((b 2^)_-_(4 a*c*))))_/_(2 a*)`.  N.B. `-identifier` is a special syntax for negation which turns into `identifier -~` where `-~` is the dedicated unary negation operator.  The prefixing effect can be chained across multiple brackets provided that there are no spaces between any of them; this allows you to write `if_t(cond expr): code_if_true` as a more readable alternative to `cond expr [code_if_true] if_t`.  When using `.field` prefixing is done in a special way that carries the value at the top of the stack with it (allowing you to write the familiar `object.method(args)`, without it turning into `object args .method` which is obviously incorrect).

Apart from the `#` and `..` operators already discussed, there is one more fundamental operator for programs which is `?`.  This is a ternary operator which takes a boolean as its first argument, then two more values.  If the boolean is true then the first of the two values is put back onto the stack, otherwise the second is.  This operator forms the basis for defining all conditional operations, except for those used in logic programming which distinguish between success and failure of unification.  Most other operators are user definable and are described in a later section.

## Pattern matching
Pattern matching is typically achieved on parameters using `#` notation e.g. `#5` matches the (signed) integer 5.  To match an expression you use `#()` e.g. `#(2 3+)` again matches 5.  The most useful kind of pattern matching though applies to stack objects, and can be done using `#{a,b,c}` to match a tuple, or for lists `#{}` (empty list) `#{first rest..}` and `#{rest.. last}`.  You can also match to fields of a stack object using e.g. `#{identifier>field_a (expression)>field_b}`.  If you don't want part of the pattern you use the special `_` identifier.  Normally you'd want to match a list so it's strict at one end, but since this is a logic programming language you are permitted to do stuff like `#{_.. a _.. b _..}` to non-deterministically pick any two entries from the list and call them `a` and `b`.  You can bind to a pattern as well as a name by using the 'as' syntax `#identifier\{pattern}`.

Within a pattern, you have use of the Kleene operators `*` (zero or more) `+` (one or more) `?` (one or none).  These can also be followed by numbers `*3` (exactly three) `+3` (at least three) `*?3` (up to three, can't use ?3 since that means the type of all integers with value 3 - see later).  Additionally you can combine some of these e.g. `+10?99` means between 10 and 99 times inclusive.  These may be used in other contexts, but particularly, in types, you can use them as is, and the program level operators have to be written as `_*_` `_+_` and `_?_` since they are uncommon there.  Note that `+?3` means between one and three, and `*?3` means between zero and three, i.e. the same as what `?3` would mean if it was allowed.

For character strings you can use `#//` which is a regular expression matcher.  If it is empty for example, it will match any (valid) string.  Starpial uses its own unique syntax for regular expressions which is described in a later section.

When a pattern doesn't match it triggers a 'match exception', a special soft exception that can be handled using <code>&#96;[]</code> and also triggers backtracking when doing logic programming (with any exception the state of the stack is rolled back to the point a different alternate execution path can be tried).  (Since the <code>&#96;[]</code> form implies a (soft) logical cut on the quotation it applies to you may sometimes prefer `|[]` which creates full logical alternatives providing more places to backtrack to.  There is also `![]` which is a hard cut, disabling all backtracking into the quotation it is applied to once its end has been successfully reached once.)  You can therefore create a case switch with code like <code>[#1 code]&#96;[#2 code]&#96;[#3 code]#</code>.

You are not limited to using `#{pattern}`, you can also bind patterns using `@{pattern}` `!{pattern}` and `${pattern}`.

## Unification variables
Most forms of bindings (except `#identifier` for obvious reasons) may be used in an uninitialized form, which means it has a completely undetermined value that may be refined through the use of unification.  These form the basis for free variables in logic programming and are written <code>&#96;@identifier</code> <code>&#96;!identifier</code> and <code>&#96;$identifier</code>.  Whenever the `identifier` is used it puts down a non-deterministic value to be further matched upon.  These can also be created anonymously as <code>&#96;@</code> <code>&#96;!</code> and <code>&#96;$</code> in which case the free variable (or variable reference in the latter case) is left on the stack.  You can create lots of them by doing e.g. <code>&#96;@&#42;10</code> but you're not allowed a space since that would mean repeating the *same* value 10 times.

On top of the regular unification variables you can also write <code>&#96;?identifier</code> which represents an unknown *type*.  This fulfils the purpose of implicit type parameters where the type can trivially be deduced from an argument fed in one of the actual parameters, since this unifies it with something.

## Exceptions
Apart from the built-in match exceptions (handled with <code>&#96;[]</code>), there is also the hard variant of those which is the last resort exception (handled with <code>&#96;&#42;[]</code>) caused when the exception raised is outside of the lexical scope of the calling site e.g. if there is a match exception within a function that is passed as a parameter.  Last resort exceptions also arise after backtracking following a named exception, if the quotation never succeeds without exceptions on any backtracking attempt.

Named exceptions can be declared using <code>!&#96;exception&#95;name</code> and if desired the scope for throwing them can be limited by using <code>@&#96;exception&#95;name</code> (but you can still catch).  To catch a named exception you use the <code>&#96;exception&#95;name</code> operator, normally written prefix as <code>&#96;exception&#95;name[]</code>.  To throw a named exception you do <code>#&#96;exception&#95;name</code> and you can raise the match exception, general exception and last resort exception explicitly with <code>#&#96;</code>, <code>#&#96;&#95;</code> and <code>#&#96;&#42;</code>.  <code>&#96;&#95;[]</code> is the general exception handler which will handle the general exception or any exception with a name (or a name that has gone out of scope).

## Object oriented programming and modules
To support object oriented programming beyond the simple exported fields described earlier, there are some extra mechanisms.  Firstly, a module can simply be represented as a stack object containing all the useful stuff you need, and you can already access it by name and then `.field` but we have other tricks.  As well as exporting there is also importing done using `<identifier` and more interestingly `<*` which will import everything that is exported from the object into the local scope.  You can select multiple items with `<id1|id2|id3`.

The important thing though is when you do `<*>`.  This imports everything from an object and then exports it again, but on top of that, it also copies any closed type tags (see next section) onto the active stack, essentially making it into a subtype, and furthermore anything defined using `@` within the object is imported along with any variables that aren't marked as private i.e. `!$` or `$!`.  So this is essentially object inheritance.  You are able to override anything imported/exported by simply defining it again (e.g. defining as `@` will unexport something that was exported) but in doing so you will lose access to the original definition, for which you'll have to go back to the original object.  Inheritance can be performed on multiple objects and if exported things share the same name a method resolution order will be used which descends the object hierarchy from the first object that defines it and then down any subtypes which occur.  Due to the inheriting of the type tag the derived object must satisfy all the constraints placed on that type tag, and for this reason placing an interface on your classes is almost mandatory to make them useful considering that subtyping may occur.

## Assertions and type tags
Assertions are very similar to pattern matching but instead involve a predicate.  These are written `?()` where inside you have the top item of the stack copied into a new temporary stack and you have to manipulate this stack until there is only a boolean value left on it, if true the assertion passes, if false it generates a 'match exception'.  For example, `?(2% 0=)` asserts that an integer is even.  These can be combined with bindings to form refinement types e.g. `$even_number?(2% 0=)` is a variable that only ever hold an even value.  Note that you can write `!?(assertion)` to assert something about a value and **not** leave it on the stack.  Additionally for booleans already on the stack you can see that `?()` and `!?()` would both be valid i.e. it turns `false` into logical failure and in the latter case doesn't leave true on the stack if this test succeeds.

Type tags refer to identifiers associated with types.  Some type tags are closed (only derived from a certain point of definition in the code) and others are open, simply referring to sets of possible values or a set pattern.  Either way writing `?type_tag` asserts that a value has that type tag, and again these may be combined with binding constructs to limit identifiers to certain types.  Intrinsically defined type tags include `bool`, `int`, `uint`, `float`, `double`, `char`, `uint16`, `int64`, `bigint` (unlimited precision signed integers), `nat` (unlimited precision unsigned integers) and the special type tag `_`, which refers to any stack object that does not have any *closed* type tag associated with it (useful to define generic operations on plain data without affecting more advanced types).  There are also higher level type tags including `set` the type of program types (sets of values), `prop` the type of propositions (for impredicative logic, not represented in the running program) and `type` (the type of all types).

## Type system
Type tags form the basis of the type system but obviously more is required.  Instead of a plain type tag you can type something using `?[]` inside of which is a type quotation which must evaluate to a single type describing the value it is applied to.  Writing a type tag results in a non-deterministic value representing the (potentially infinite) set of values under that type, and if you just write one type tag it's equivalent to using the type tag normally.  Starpial however has a very powerful type system that allows you to write basically any code in the world of types and refer to program level definitions if desired.

For type aliases, which are written as `??identifier?[]` you are allowed to include parameters in the type quotation in order to create type level functions, useful for 'generics' and phantom types.  By default, the identifier for the type alias is treated as an open type tag.

To create a closed type tag you write `?!identifier` (which may be refined using `?[]` or `??identifier` later) and then at the single point of definition in the program for a value under that type tag you tag it with `?@identifier` (this can only be used once wherever `?!identifier` is in scope!)  Note that by non-determinism you can assign a set of different possible values into a closed type tag.

For most of the fundamental type tags you should use the built-in type tags described previously.  When inside types you can use `//` directly as the type of a string (since it matches all of them), or any more complex regex to describe a subset of strings (if you need divide you have to use `_/_`).  The interesting case is stack objects.  For tuple types you simply write the types inside the `{}` e.g. `{int, double}` (comma optional).  For lists you have to make use of the Kleene operators mentioned previously e.g. `{int+}` is a non-empty list of ints.  The patterns for the inside of a stack object can be as complicated as you want, and might make use of type parameters or program functions to build the stack of types.  N.B. `{char*}` can represent a string similarly to `//`, but only the latter maintains an invariant that the string is a well-formed sequence of UTF-8 characters, and so it should be preferred.

To represent the interface of an object/class you simply create a type stack and export from it the same names as the object you're trying to represent, but instead of what was originally exported, you export the values of the types which represent those exported things.

To represent the type of a quotation there is a special object called a stack effect, represented as `[ => ]`.  Everything to the left of the arrow must represent the state of the stack prior to calling the quotation, and everything to the right represents the state after the quotation has completed.  Any parts of the stack underneath what the quotation touches may be left out, but if it is used it should be included, or must if it is modified.  For example <code>[+]?[&#96;?t t t => t]</code> shows a reasonable type judgement for the addition operator.  To make things shorter you can write `~identifier` to represent a named type parameter as one of the inputs so e.g. `[+]?[~t t => t]` works fine.  On top of this you can use `#identifier` to represent dependent parameters so an example type might be `[~t #n => {t*n}]` for a quotation that replicates a value of type t n times into a stack object.  Stack effects may of course be nested since quotations may take other quotations as inputs or produce them as outputs.  Furthermore the `=>` in the stack effect may be followed by <code>&#96;</code> (that is <code>=>&#96;</code>) to say that the quotation may raise an exception (directly), and/or followed by `$` (that is `=>$`) to show it performs I/O or alternatively `=>$[]` inside which you write the names of any functions you're going to call that may perform I/O.

Within a type stack you are permitted to use `~identifier` to refer to the type of that element within the stack object and use it to copy elsewhere within the type stack e.g. `{~t double t}` is the type of a stack object that contains two objects of the same type with a double inbetween.  Since there is no input or output you can put the binding on either of them (or even both) and it will still work.  However, there is a special type stack called a dependent stack which is created as `{=> }`.  The arrow has to go before any of the dependent arguments but other than that it doesn't really signify anything other than that dependent arguments are allowed and won't get confused with the stack quotation shorthand (you can write `{#x#y#z}` instead of `[#x#y#z {}]`) whose parameters must go to the left of the arrow (and before any actual code as per usual).  The dependent arguments are of course written `#identifier` and this allows you to create types for other elements of the type stack that dependent on program values.  For example <code>{=> #n {&#96;? &#42;n}}</code> represents a pair of a length and a list of that length for some type we don't care about.

## Type casting
It is possible to do explicit conversions from something to another type using the syntax `.?destination_type`.  This is mostly useful for converting between numerical types without using operators, or more uniquely to do narrowing conversions.  This can be used as a way of stripping unnecessary type tags by doing a cast to one of the supertypes.  In some cases it may be possible to reinterpret the contents of a stack as it would be serialized e.g. turning a `{uint8*}` into a `{float*}` using `.?{float*}` which is useful for interpreting values in memory.

## Automatic parallelization and transactions
By default all code within a Starpial program forms one transaction i.e. all I/O has to happen in order of the stack being evaluated and there is no chance of any other part of the program interfering with this process.  This is obviously not very useful for parallelization and so there are ways to break the program down into smaller transactions.

The sequence point `.>` says that everything before it has to happen before anything after it **but** at the position of the sequence point there are allowed to be I/O actions taking place from elsewhere in the program.

The sync point `.` says that I/O actions on either side can happen in any order as well as allowing actions from elsewhere in the program.  Provided that there are no data dependencies between the two sides this basically establishes true parallelism between the two parts.

Anything that is inbetween these sequence points and sync points constitutes a transaction and no I/O from elsewhere in the program is allowed to interfere in anything the transaction touches in any way that affects it being viewed as a transaction.

If the outermost level of a quotation does not contain any sequence/sync points then it is viewed as an atomic operation even though it might not be internally.  If it does contain at least one sequence or sync point then it is allowed to engage with the parallelism at the call site.  For this reason special versions of combinators etc. are needed that are explicitly made parallelizable.

## Literals
Firstly, there are no literals for true or false, you have to generate the values using e.g. `0 0 =`.

Integers come in various forms.  Firstly there is `123` which represents a machine-sized signed integer typically, or may represent a general integer in some contexts, then you can write negative numbers as `-123`.  To get unsigned machine-size values you have to use one of the base prefixes e.g. `0d123` for decimal then `0x` for hexadecimal, `0o` for octal and `0b` for binary.  For different bit-widths you replace the initial `0` by the bit width so e.g. `8x12` represents an 8-bit unsigned value 18.  To make those into signed you prefix with `-` or `+`, however note that prefix `+` can *only* be used in front of an integer literal with a base attached so `+0d123` is valid but `+123` is not (this is a Kleene operator `+` meaning repeat at least 123 times).  You are allowed to separate the digits by the `'` character for readability e.g. `0x1234'5678` and `123'456`.

Floating point is similar and written with a decimal point in the number e.g. `12.3` or `123.` which represents a default-sized float (expected to be 64-bit double precision).  These may be preceded by `-` or `+` and may be suffixed by `e` followed by an exponent base 10, or `p` followed by an exponent base 2.  Whenever a decimal point or exponent is present the number is treated as being floating point.  These can then be preceded by any of the bases mentioned before and the bit-width will be treated as the size of the floating point representation.  Finally there is an `0f` prefix which is the same as `0d` except that always interprets the value as floating point.  Example floats are `32f1.234e7` for a single precision float, and `0x1.2345'6789p-12` which represents a floating point value by its bit representation in hex.

String literals are surrounded by `""` and follow common conventions using `\` as the escape character.  Character literals are the same as string literals except they are delimited by `''` (if a character literal contains several characters or UTF-8 octets then they are all put onto the current stack, so it does not necessarily represent one value).  Any Unicode characters can be put into a string literal and will be expanded into their UTF-8 representation.  This is the list of escape sequences that are recognized:
* `\newline` - ignores the newline
* `\\` - backslash
* `\'` - single quote
* `\"` - double quote
* `\a` - alert (bell character)
* `\b` - backspace
* `\f` - form feed
* `\n` - line feed
* `\r` - carriage return
* `\t` - horizontal tab
* `\v` - vertical tab
* `\ooo` - octal raw byte where ooo are digits
* `\xhh` - hexadecimal raw byte where hh are hex digits
* `\uhhhh` - Unicode character (expands to UTF-8 octets)
* `\Uhhhhhhhh` - Unicode character (expands to UTF-8 octets)
* `\;` - empty string (can be used to complete one of the above early)

## Sigils
Starpial has no keywords (though it has words that are defined by default they are user overridable) so the language has to be defined in terms of sigils that have various meanings and are sometimes combined together.  This a run down of the meaning of each ASCII symbol, excluding `_`, excluding how they are defined as standard arithmetic etc. operators, and excluding regex usage:
* `.` - syncpoint operator; spill operator
* `,` - item quantity assertion
* `;` - end of statement / indented block
* `:` - code indented quotations and values
* `@` - final binding, memory at address
* `!` - continued binding; hard cut
* `$` - mutable variable binding; cloning
* `#` - parameter binding; call operator
* `~` - type parameter binding
* `<` - import binding(s)
* `>` - export binding(s)
* `?` - type; assertion; ternary operator; Kleene operator (one or none)
* `*` - Kleene operator/star (zero or more)
* `+` - Kleene operator (one or more)
* `=` - assignment
* `-` - negation
* `/` - regular expression
* `\` - as pattern
* `[]` - quotation; various special brackets
* `()` - item quantity assertion; expression
* `{}` - stack object
* <code>&#96;</code> - exception; soft cut
* `|` - alternation
* `'` - character
* `"` - string
* `&` - address of
* `%` - no meaning
* `^` - no meaning

## Overloadable operators for arithmetic etc.
All of these operators can be overloaded by the user for types of their own making, but for standard types they are intrinsically defined.  The non-relational ones come with their form with `=[]` appended built-in to create a modify assignment operator, by applying the operator and then assigning the result e.g. `+=[5]` will increase a value by 5.  The effect of the operator `=[]` contents must be that performing the code and applying the operator just changes the value at the top of the stack and not taking away or adding any items.  Even the unary operations still use the brackets in the built-in form (you would leave them empty).
### Arithmetical
* `-~` - negation
* `++` - increment
* `--` - decrement
* `+` - addition
* `-` - subtraction
* `*` - multiplication
* `/` - division
* `%` - modulo/remainder
* `^` - exponentiation
### Relational
* `=` - equality
* `=~` - inequality
* `>` - greater than
* `<` - less than
* `>=` - greater than or equal
* `<=` - less than or equal
### Logical
* `~` - NOT
* `|` - OR
* `|~` - NOR
* `&` - AND
* `&~` - NAND
* `<>` - IFF
* `><` - XOR
* `->` - implies
* `<-` - implied by
* `~>` - does not imply
* `<~` - is not implied by
### Bit manipulation
* `<<` - left shift
* `>>` - arithmetical right shift
* `>>>` - logical right shift
* `<<|` - left rotate
* `|>>` - right rotate
### User defined operators
The operators above can be overloaded by using the `_` delimited form of the operator e.g. `_+_` and doing normal bindings with them.  However, the user is not limited to those above and can define an operator out of any combination of symbols, however this excludes the characters `,`, `;`, `:`, `'`, `"`, and of course bracket symbols and `_`.  Due to special parsing rules for conciseness, it is not permitted to have `#` in your operator except as the last character since it terminates an operator character sequence when they are strung together, and by convention it is only used for operators which call a quotation (sometimes conditionally).

The user is not able to overload any of the operators listed in the following section or anything else that has a language defined meaning.

## Special operators
These operators are not overloadable by the user and have special meanings which cannot be recreated in the language.
### Propositional operators
These are used for propositional logic in the type system (not representable at the program level).
* `==` - equality
* `=/=` - inequality
* `&&` - conjunction
* `||` - disjunction
* `~/` - negation
* `-->` - implication
* `-/->` - non-implication
* `<--` - reverse implication
* `<-/-` - reverse non-implication
* `<-->` - bi-implication
* `<-/->` - non-bi-implication
### Standard operators
* `.` - sync point
* `.>` - sequence point
* `..` - spill
* `..,` - spill disabling comma assertion
* `...` - spill no comma assertion
* `?` - ternary operator
* `#` - call
* `$` - create variable reference from value
* `!*` - import all bindings from outer stack before current point
* `@*` - import all bindings from outer stack before current point, closing off partial defines
* <code>&#96;</code> - add match exception handler
* <code>&#96;&#42;</code> - add last resort exception handler
* <code>#&#96;</code> - raise match exception
* <code>#&#96;&#42;</code> - raise last resort exception
* <code>#&#96;&#96;</code>, <code>#&#96;&#96;&#96;</code> etc. - reraise exception triggering current exception handler, one enclosing that etc.
* `=>` - stack effect / dependent stack
### Kleene operators (for use in types/patterns)
* `*` - Kleene operator/star (zero or more)
* `+` - Kleene operator (one or more)
* `?` - Kleene operator (one or none)
* `*?` - equivalent to `?`

## Identifier expressions
Prefixing some selected operators onto identifiers (made up of alphanumerics and underscores) allows you to do certain things such as bindings.  The binding ones can be combined together to give variations on bindings.  This is a list of the most basic options:
* `@identifier` - final binding
* `!identifier` - continued binding
* `$identifier` - variable binding
* `$$identifier` - reference alias binding
* `#identifier` - (dependent) parameter binding
* `#$identifier` - paramater bound by reference (creates an alias)
* `~identifier` - type binding
* `<identifier` - import binding
* `>identifier` - export binding
* `>!identifier` - unexport and make private binding
* `>@identifier` - unexport and make protected binding
* `.identifier` - access field of stack object
* `?identifier` - check value matches type tag
* `*?identifier` - Kleene operator (up to the value of identifier times some object)
* `*identifier` - Kleene operator (exactly value of identifier times some object)
* `+identifier` - Kleene operator (at least value of identifier times some object)
* `=identifier` - assign to the variable `$identifier`
* `-identifier` - negate value of identifier i.e. `identifier -~`
* `\identifier` - get value without calling i.e. equivalent to `[identifier]` for quotations
* `.\identifier` - get value of field without calling
* <code>&#96;identifier</code> - assigns handler for exception named `identifier`
* `|identifier` - creates alternation with value of identifier
* `&identifier` - take address of object identifier refers to

## Special brackets
Since the prefixing rule does not work with operators (that would turn postfix into prefix) various combinations of operators with various brackets has special meanings completely different from when the brackets are used standalone.  Generally `[]` is used for arbitrary purposes, `()` is used for expressions (generally could use a literal instead of `()` for the following definitions) and `{}` has the more limited usage of pattern matching to a stack object.  Note that `[=>]` and `{=>}` may be used in the same contexts as that for `{}` so they are not listed here (and there is a syntactical ambiguity to avoid with the first of those).  Most sigils work as operators in this way but some don't, specifically `,`, `;`, `:`, `/` (due to its use for regex), `'` and `"` (`_` is treated similarly to a letter so also doesn't count). Here we attempt to enumerate the various types of brackets which currently have meanings (others are considered invalid and reserved for later use):
* `@[]` - memory (i.e. `{uint8*}`) at the address, or range of addresses (if you give two values) provided
* `@()` - final bind matching against the value of an expression
* `@{}` - final bind matching against a stack pattern
* `@*()` - drop expression number of items from the stack (same as `!*()`)
* `![]` - hard cut with match exception handler
* `!()` - continued bind matching against the value of an expression
* `!{}` - continued bind matching against a stack pattern
* `!*[]` - hard cut with last resort exception handler
* `!*()` - drop expression number of items from the stack
* `$[]` - cloning stack where everything inside is deep cloned and put onto the outer stack, but any shared references between things inside the cloning stack are kept shared (so it is good to put the entire data structure in there)
* `$()` - variable bind matching against the value of an expression
* `${}` - variable bind matching against a stack pattern
* `$*()` - create expression number of variables with starting value
* `#[]` - matches against any value produced within the stack e.g. you can match ASCII characters with `#['abcABC']`
* `#()` - match against the value of an expression
* `#{}` - match against a stack pattern
* `#$()` - match a reference to a reference computed by the expression
* `#${}` - match to elements of a stack pattern by reference
* `#*()` - perform call (`#`) expression number of times
* `~()` - match against the type computed by the expression
* `~{}` - match against a type stack pattern
* `<[]` - index into a stack object some number of objects from the top (and repeat for each index given)
* `>[]` - index into a stack object some number of objects from the bottom (and repeat for each index given)
* `>()` - exporting bind to key computed by expression (bind is not available locally)
* `>{}` - exporting bind matching against a stack pattern
* `>!()` - unexport key computed by expression
* `>!{}` - unexport anything bound within stack pattern as private binding
* `>@()` - same as `>!()`
* `>@{}` - unexport anything bound within stack pattern as protected binding
* `.[]` - equivalent to `>[]` indexing into a stack
* `.()` - access field of stack object by key expression
* `?[]` - type quotation that produces a type
* `?()` - assertion on a value
* `?{}` - type stack
* `?*()` - perform `?` expression number of times
* `*?()` - Kleene operator, up to evaluated expression times whatever is on the stack
* `*()` - Kleene operator, exactly evaluated expression times whatever is on the stack
* `+()` - Kleene operator, at least evaluated expression times whatever is on the stack
* `=[]` - assignment to the reference on the stack
* `operator=[]` - take reference, apply operator to value then assign to the reference (as described previously)
* `-()` - sugar for `()-~` i.e. negate the last value in the expression
* `\[]` - double quotation (you have to call it twice), these can be stacked up like `\\\[]` as a shorthand for `[[[[]]]]`
* `\()` - reserved for in patterns, something as matching the expression
* `\{}` - reserved for in patterns, something as matching the stack pattern
* `.\()` - access field of stack object by key expression, without calling it
* <code>&#96;[]</code> - match exception handler (soft cut)
* <code>&#96;()</code> - match exception handler using replacement expression
* <code>&#96;{}</code> - match exception handler using stack object or stack object quotation shorthand
* <code>&#96;&#42;[]</code> - last resort exception handler (soft cut ignoring exceptions)
* <code>&#96;&#42;()</code> - last resort exception handler using replacement expression
* <code>&#96;&#42;{}</code> - last resort exception handler using stack object or stack object quotation shorthand
* `|[]` - alternative quotation (creates choice point for logical backtracking)
* `|()` - alternative value (creates choice point for logical backtracking)
* `|{}` - alternative stack object (creates choice point for logical backtracking)
* `&[]` - takes memory addresses of any provided objects

## Regular Expressions
Regular expressions in Starpial are designed to work with Unicode characters (represented by UTF-8 octets) so using a regular expression will also validate that the sequence of octets passed to it is a valid UTF-8 representation.

Regular expressions in Starpial can be made recursive by calling other code within the regex that matches against part of the string (and can output an object).  This is done using `[sub_parse]` within the regular expression and then you can export the value produced using `>identifier` immediately after it (spaces are ignored in these regular expressions).

This is the list of ASCII character tokens and what they mean within a regular expression (again underscore is ignored, it just represents itself like a letter):
* `.` - any char
* `,` - break identifiers from text whilst keeping the last item as current
* `;` - null string (can also be used to break identifiers from text)
* `:` - character class e.g. `:alpha:`
* `[` - open subprocedure
* `]` - close subprocedure
* `@` - bind identifier in scope
* `!` - hard cut on previous item (prevents backtracking to try a different match)
* `^` - start of line
* `$` - end of line
* `>` - export identifier
* `<` - rollback string consumed by previous item (but keeps bindings)
* `=` - assign to variable
* `/` - regex terminator
* `\` - escape char
* `~` - no match on previous item (inverts failure)
* `*` - zero or more
* `?` - one or none
* `+` - one or more
* `-` - make range
* `%` - count delimiter e.g. `%3%` `%5+%` `%3-10%`
* `#` - comment delimiter
* `|` - alternation
* `&` - conjunction
* `(` - open capture group
* `)` - close capture group
* `{` - open character options, uses `~` to invert e.g. `{adfgkx}` `{12345~}` `{a-zA-Z0-9_}`
* `}` - close character options
* ` ` - ignored whitespace
* `"` - verbatim text string
* `'` - characters delimiter (only last character is counted as previous item
* <code>&#96;</code> - start/end of string, or alternation with (soft) cut
