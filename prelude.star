!_-~_: ._-~_
!_++_: ._++_
!_--_: ._--_
!_+_:#a#b a._+_(b)
!_-_:#a#b a._-_(b)
!_*_:#a#b a._*_(b)
!_/_:#a#b a._/_(b)
!_%_:#a#b a._%_(b)
!_^_:#a#b a._^_(b)
!_=_?[`@ `@ => bool]:#a#b a._=_(b)
!_>_?[`@ `@ => bool]:#a#b a._>_(b)
!_<_?[`@ `@ => bool]:#a#b a._<_(b)
!_~_: ._~_
!_|_:#a#b a._|_(b)
!_&_:#a#b a._&_(b)
!_><_:#a#b a._><_(b)
!_->_:#a#b a._~_._|_(b)
!_<~_:#a#b a._~_._&_(b)
!_<<_:#a#b a._<<_(b)
!_<<|_:#a#b a._<<|_(b)
!_>>_:#a#b a._>>_(b)
!_|>>_:#a#b a._|>>_(b)
!_>>>_:#a#b a._>>>_(b)

!_=~_?[`@ `@ => bool]: = ~
!_<=_?[`@ `@ => bool]: > ~
!_>=_?[`@ `@ => bool]: < ~
!_|~_: | ~
!_&~_: & ~
!_<>_: >< ~
!_~>_: -> ~
!_<-_: <~ ~

!show: .show

@_-~=_:#$a a =: a-~
@_++=_:#$a a =: a++
@_--=_:#$a a =: a--
@_~=_:#$a a =: a~

@_|#_?[bool [bool] => bool]:#f dup if_f: f# |
@_|~#_?[bool [bool] => bool]: |# ~
@_&#_?[bool [bool] => bool]:#f dup if_t: f# &
@_&~#_?[bool [bool] => bool]: &# ~
@_->#_?[bool [bool] => bool]:#f ~ dup if_t: f# |
@_~>#_?[bool [bool] => bool]: -># ~
@_<~#_?[bool [bool] => bool]:#f ~ dup if_t: f# &
@_<-#_?[bool [bool] => bool]: <~# ~

@_!?_?[bool =>`]: !?()

@_!!_?[~t => t]: ![#`]
@_!#_?[xs.. ~f\[xs.. =>$ ys..] =>$[f] ys..]: ![#`]#
@_!*#_?[xs.. ~f\[xs.. =>$ ys..] =>$[f] ys..]: !*[#`]#

[show]!?[`@ => //]
[=]!?[`@ `@ => bool]
[>]!?[`@ `@ => bool]
[<]!?[`@ `@ => bool]
??comp?([#x (x x =)!?bool (x x <)!?bool (x x >)!?bool true]`[#_ false]#)


!_=_?[_ _ => bool]:[#{x xs..}#{y ys..} x y = xs ys = &]`[#{}#{} true]`[#_#_ false]#
!_>_?[_ _ => bool]:[#{x xs..}#{y ys..} x y > (x y = xs ys > &) |]`[#{}#_ false]`[#_#_ true]#
!_<_?[_ _ => bool]:#a#b b a >
!show?[_ => //]:{#{x xs..} '{' show(x).. xs each[',' swap show..] '}'}`{#_ '{}'}


??maybe?@none?{#_}?@some?{#t t} @None:{}?![none(`?)]; @Some:`?t #x?t {x}?![some(t)]
??either?@left?{#l#r l}?@right?{#l#r r} @Left:`?t #x?t {x}?![either(t, `?)]; @Right:`?t #x?t {x}?![either(`?, t)]


@true?[bool]:                          0 0 =
@false?[bool]:                         true ~
??unit?_?([#{} true]`[! false]#)
??void

@nop?[=>]:
@id?[~t => t]:                           #x x
@_!_: drop
@drop?[`@ =>]:                            #_
@drop2?[`@*2 =>]:                        #_#_
@drop3?[`@*3 =>]:                      #_#_#_
@dropn?[`@*n #n?uint =>]:                          list drop
@nip?[`@ ~t => t]:#x#y y
@nip2?[`@2 ~t => t]:#x#y#z z
@nip3?[`@3 ~t => t]:#w#x#y#z z
@nipn?[`@*n ~t #n?uint => t]:#n dip[n list !]
@tuck?[~a ~b => b a b]: #a#b b a b
@tuck2?[~a ~b ~c => b c a b c]: #a#b#c b c a b c
@tuck3?[~a ~b ~c ~d => b c d a b c d]: #a#b#c#d b c d a b c d
@tuckn?[~a ~ts*n #n?uint => ts.. a ts..]:         list [dip:..][..] bi
@dup?[~t => t t]:                        #x x x
@dup2?[~x ~y => x y x y]:               #x#y x y x y
@dup3?[~x ~y ~z => x y z x y z]:         #x#y#z x y z x y z
@dupn?[~ts*n #n?uint => ts.. ts..]:                          list [..][..] bi
@over?[~a ~b => a b a]:                 #a#b a b a
@over2?[~a ~b ~c => a b c a b]: #a#b#c a b c a b
@over3?[~a ~b ~c ~d => a b c d a b c]: #a#b#c#d a b c d a b c
@overn?[~ts*n ~a #n?uint => ts.. a ts..]:#n dip[n list] over dip2[..] ..
@pick?[~t ~ts*m #m?uint => t ts.. t]:                1+ list [..][head] bi
@pick2?[~s ~t ~ts*m #m?uint => s t ts.. s t]: 2+ list [..][chop head] bi
@pick3?[~r ~s ~t ~ts*m #m?uint => r s t ts.. r s t]: 3+ list [..][chop chop head] bi
@pickn?[~vs*n ~ts*m #m?uint #n?uint => vs.. ts.. vs..]:#n list dip[n list] over apply3[..]
@swap?[~a ~b => b a]:                   #a#b b a
@swap2?[~a ~b ~c => c a b]: #a#b#c c a b
@swap3?[~a ~b ~c ~d => d a b c]: #a#b#c#d d a b c
@swapn?[~ts*n ~t #n?uint => t ts..]:#n dip[n list] swap..
@rot?[~a ~b ~c => b c a]:              #a#b#c b c a
@roll?[~t ~ts*m #m?uint => ts.. t]: list swap dip[..]
@roll2?[~s ~t ~ts*m #m?uint => ts.. s t]: list swap2 dip2[..]
@roll3?[~r ~s ~t ~ts*m #m?uint => ts.. r s t]: list swap3 dip3[..]
@rolln[~vs*n ~ts*m #m?uint #n?uint => ts.. vs..]:#n list dip[n list] swap apply2[..]

@dip?[xs.. ~v ~f\[xs.. =>$ ys..] =>$[f] ys.. v]:                          #v#f f# v
@dip2?[xs.. ~v ~w ~f\[xs.. =>$ ys..] =>$[f] ys.. v w]:                   #v#w#f f# v w
@dip3?[xs.. ~v ~w ~x ~f\[xs.. =>$ ys..] =>$[f] ys.. v w x]:             #v#w#x#f f# v w x
@dipn?[xs.. ~vs*n #n?uint ~f\[xs.. =>$ ys..] =>$[f] ys.. vs..]:                          #f list dip(f) ..
@keep?[xs.. v ~f\[xs.. v =>$ ys..] =>$[f] ys.. v]:                  #v#f v f# v
@keep2?[xs.. v w ~f\[xs.. v w =>$ ys..] =>$[f] ys.. v w]:         #v#w#f v w f# v w
@keep3?[xs.. v w x ~f\[xs.. v w x =>$ ys..] =>$[f] ys.. v w x]: #v#w#x#f v w x f# v w x
@bi?[xs.. v ~f\[xs.. v =>$ ys..] ~g\[ys.. v =>$ zs..] =>$[f g] zs..]:                       #v#f#g v f# v g#
@bi2?[xs.. v w ~f\[xs.. v w =>$ ys..] ~g\[ys.. v w =>$ zs..] =>$[f g] zs..]:                #v#w#f#g v w f# v w g#
@bi3?[xs.. v w x ~f\[xs.. v w x =>$ ys..] ~g[ys.. v w x =>$ zs..] =>$[f g] zs..]:          #v#w#x#f#g v w x f# v w x g#
@tri?[ws.. v ~f\[ws.. v =>$ xs..] ~g\[xs.. v =>$ ys..] ~h\[ys.. v =>$ zs..] =>$[f g h] zs..]:                    #v#f#g#h v f# v g# v h#
@tri2?[ws.. v w ~f\[ws.. v w =>$ xs..] ~g\[xs.. v w =>$ ys..] ~h\[ys.. v w =>$ zs..] =>$[f g h] zs..]:             #v#w#f#g#h v w f# v w g# v w h#
@tri3?[ws.. v w x ~f\[ws.. v w x =>$ xs..] ~g\[xs.. v w x =>$ ys..] ~h\[ys.. v w x =>$ zs..] =>$[f g h] zs..]:       #v#w#x#f#g#h v w x f# v w x g# v w x h#
@multi?[`@zss\{{_*}+} head(zss).. ~v ~fs\({init(zss) tail(zss)}zipwith:#xs#ys [xs.. v =>$ ys..]) =>$[fs..] top(zss)..]:                    #v#l l each[#f v f#]
@multi2?[`@zss\{{_*}+} head(zss).. ~v ~w ~fs\({init(zss) tail(zss)} zipwith:#xs#ys [xs.. v w =>$ ys..]) =>$[fs..] top(zss)..]:                    #v#w#l l each[#f v w f#]
@multi3?[`@zss\{{_*}+} head(zss).. ~v ~w ~x ~fs\({init(zss) tail(zss)} zipwith:#xs#ys [xs.. v w x =>$ ys..]) =>$[fs..] top(zss)..]:                    #v#w#x#l l each[#f v w x f#]
@both?[xs.. t ~f\[xs.. =>$ ys..] ~g\[ys.. t =>$ zs..] =>$[f g] zs..]:#f#g dip(f) g#
@apply?[as.. ~f\[as.. =>$ bs..] =>$[f] bs..]:                           #
@apply2?[xs.. t t ~f\[xs.. t =>$ ys.. xs..] =>$[f] ys.. ys.. xs..]: #f dip(f) f#
@apply3?[xs.. t t t ~f\[xs.. t =>$ ys.. xs..] =>$[f] ys.. ys.. ys.. xs..]: #f dip[apply2(f)] f#
@applyn?[xs.. t*n #n?uint ~f\[xs.. t =>$ ys.. xs..] =>$[f] n times[ys..] xs..]:#n#f n 0 > if_t: dip[n 1- applyn(f)] f#

@quote?[~t => [=> t]]:       #v [v]
@curry?[t ~f\[xs.. t =>$ ys..] => [xs.. =>$[f] ys..]]:              #x#f [x f#]
@curry2?[t u ~f\[xs.. t u =>$ ys..] => [xs.. =>$[f] ys..]]:       #x#y#f [x y f#]
@curry3?[t u v ~f\[xs.. t u v =>$ ys..] => [xs.. =>$[f] ys..]]: #x#y#z#f [x y z f#]
@curryn?[xs.. vs.. #n?uint ~f\[xs.. vs*n =>$ ys..] => [xs.. =>$[f] ys..]]:                        #f list@xs [xs.. f#]
@compose?[~f\[xs.. =>$ ys..] ~g\[ys.. =>$ zs..] => [xs.. =>$[f g] zs..]]:                    #f#g [f# g#]

@_?#_?[xs.. bool ~f\[xs.. =>$ ys..] ~g\[xs.. =>$ zs..] =>$[f g] [ys..]|[zs..]#]:                     ? #
@if_t?[xs.. bool ~f\[xs.. =>$ ys..] =>$[f] [xs..]|[ys..]#]:                       [] ?#
@if_f?[xs.. bool ~f\[xs.. =>$ ys..] =>$[f] [xs..]|[ys..]#]:                       [] swap ?#
??ifchain?{#xs #fs\{[(xs).. =>$ yss..]*}
                                       >b: xs.. =>$[fs..] choose{xs,yss..}..
                                       >e: xs.. ~f\[xs.. =>$ xs.. bool] =>$[f] xs.. bool
                                       >sb: ~f\[xs.. =>$ ys..]  => ifchain{xs, {fs.. f}}}
   @if?[bool ~f\[xs.. =>$ ys..] => ifchain(xs,{f})]: #c#f
       {>b[] >e[#] >sb[#f ic !ic{>b(f) >e[! false] >sb[#_ ic]}]}?[ifchain{`@,{}}] if_t(c): .sb(f)
   @elif?[`@fs ifchain(xs,fs) ~e\[xs.. =>$ xs.. bool] ~f\[xs.. => ys..] =>$[e] xs.. ifchain(xs,{fs.. f})]:#ic#b#f ic.e(b) ic swap if_t: .sb(f)
   @else?[`@fs\{[(xs).. =>$ yss..]*} xs.. ifchain(xs,fs) ~f\[xs.. => ys..] =>$[fs.. f] choose{yss.. ys}..]:#f .sb(f).b
   @endif?[`@xs `@fs\{[(xs).. =>$ yss..]*} xs.. ifchain(xs,fs) =>$[fs..] => choose{xs yss..}..]: .b

@empty?[~{_..} => bool]:            [#{} true]`[! false]#
@head?[~{t _..} =>` t]:                   #{x _..} x               ?\ Same as >[0]
@tail?[~{_ ts..} =>` ts]:                  #{_ xs..} xs
@chop?[~{t ts..} =>` t ts]:             #{x xs..} x xs       ?\Rename to uncons? Probably not
@chopb?[~{t ts..} =>` ts t]:            #{x xs..} xs x
@top?[~{_.. t}=>` t]:                    #{_.. x} x               ?\ Same as <[0]
@init?[~{ts.. _} =>` ts]:                  #{xs.. _} xs
@pop?[~{ts.. t} =>` ts t]:              #{xs.. x} xs x
@popb?[~{ts.. t} =>` t ts]:             #{xs.. x} x xs
@popn?[~ts #n =>` ts n popn]: #n n 0 > if_t: pop dip[n 1 - popn]
@push?[~ts ~t => {ts.. t}]:               #xs#e {xs.. e}
@pushb?[~t ~ts => {ts.. t}]               #e#xs {xs.. e}
@pushn?[~ts @us{n times[`@]} us.. #n?uint => {ts.. us..}]:#n n 0 > if_t: dip[n 1 - pushn] push
@cons?[~t ~ts => {t ts..}]: #e#xs {e xs..}
@consb?[~ts ~t => {t ts..}]: #xs#e {e xs..}
@consn?[@us{n times[`@]} us.. ~ts #n => {us.. ts..}]: times[cons]
@append?[~a ~b => {a.. b..}]:                #a#b {a.. b..}
@prepend?[~a ~b => {b.. a..}]:               #a#b {b.. a..}
@in?[~t {t*} => bool]::                     [#e#{e xs..} true]`[#e#{x xs..} e xs in]`[#_#{} false]
@contains?[{t*} ~t => bool]:                swap in
@indexof?[{t*} ~t =>` int]::                 [#{e xs..}#e 0]`[#{_ xs..}#e xs indexof(e) 1+]
@unique?[`@t {t*} => {t*}]:                    fold{}:#e if_f(dup contains(e)): push(e)

@loop?[xs.. ~f\[xs.. =>$ ys.. xs..] =>$[f] loop: ys..]:                           #f f# f loop
@while?[xs.. ~c\[xs.. =>$ ys.. xs.. bool] ~f\[xs.. =>$ zs.. xs..] =>$[c f] ys.. {{zs.., ys..}*} each[..] xs..]:               #c#f c# if_t: f# c f while
@until?[xs.. ~c\[xs.. =>$ ys.. xs.. bool] ~f\[xs.. =>$ zs.. xs..] =>$[c f] ys.. {{zs.., ys..}*} each[..] xs..]:               #c#f c# if_f: f# c f until
@untilfail[whilematch] @whilematch?[xs.. ~m\[xs.. =>` qs.. xs..] ~f\[xs.. =>$ rs.. xs..] =>$[f] {{qs.. rs..}*} each[..] xs..]: #m#f [m applied if_t: f# m f whilematch]
@whilefail[untilmatch] @untilmatch?[xs.. ~m\[xs.. =>` qs.. xs..] ~f\[xs.. =>$ rs.. xs..] =>$[f] {{qs.. rs..}*} each[..] xs..]: #m#f [m#]`*[f# m f untilmatch]
@dowhile?[xs.. ~f\[xs.. => ys.. xs.. bool] => {ys+ xs} each[..]]:                 #f f# if_t: f dowhile
@dountil?[xs.. ~f\[xs.. => ys.. xs.. bool] => {ys+ xs} each[..]]:                 #f f# if_f: f dountil
@dountilfail[dowhilematch] @dowhilematch?[TODO]:#f [f# f dowhilematch]`*[]#
@dowhilefail[dountilmatch] @dountilmatch?[TODO]:#f [f#]`*[f dountilmatch]#
@fix?[xs.. ~f\[xs.. [xs.. =>$[f] ys..] =>$ ys..] =>$[f] ys..]:                            #f f[f fix]#
@times?[xs.. #n?uint ~f\[xs.. =>$ ys.. xs..] =>$[f] n times[ys..] xs..]:#n#f n 0 > if_t: f# n 1 - times(f)

@map?[@ts{t*} ts ~f\[t =>$ xs..] =>$[f] ts map:! xs..]:                {#{x xs..}#f x f# map(xs,f)..}`{#_#_}#
@seqmap?[TODO]:             {#{x xs..}#f x f# .> seqmap(xs,f)..}`{#_#_}#
@parmap?[TODO]:             {#{x xs..}#f x f# . parmap(xs,f)..}`{#_#_}#
@each?[@ts{t*} ts ~f\[t =>$ xs..] =>$[f] ts each:! xs..]:                 [#{x xs..}#f x f# each(xs,f)]`[#_#_]#
@seqeach?[TODO]:              [#{x xs..}#f x f# .> seqeach(xs,f)]`[#_#_]#
@pareach?[TODO]:              [#{x xs..}#f x f# . pareach(xs,f)]`[#_#_]#
@eachref?[@ts{t$*} ts ~f\[t$ =>$ xs..] =>$[f] ts each:! xs..]:   [#{$x xs..}#f x f# each(xs,f)]`[#_#_]#
@filter?[{t*} ~f\[t =>$ bool] =>$[f] {t*}]:        {#{x xs..}#p x p# if_t[x] xs p filter..}`{#_#_}#
@filterout?[{t*} ~f\[t =>$ bool] =>$[f] {t*}]:     {#{x xs..}#p x p# if_f[x] xs p filterout..}`{#_#_}#
@takewhile?[{t*} ~f\[t =>$ bool] =>$[f] {t*}]:     {#{x xs..}#p x p# if_t: x xs p takewhile..}`{#_#_}#
@takeuntil?[{t*} ~f\[t =>$ bool] =>$[f] {t*}]:     {#{x xs..}#p x p# if_f: x xs p takeuntil..}`{#_#_}#
@leavewhile?[{t*} ~f\[t =>$ bool] =>$[f] {t*}]:    [#l\{x xs..}#p x p# [xs p leavewhile][l]?#]`[!]#
@leaveuntil?[{t*} ~f\[t =>$ bool] =>$[f] {t*}]:    [#l\{x xs..}#p x p# [l][xs p leaveuntil]?#]`[!]#
@splitwhen?[{t*} ~f\[t =>$ bool] =>$[f] {t*} {t*}]: bi2[takeuntil][leaveuntil]
@fold?[{t*} u ~f\[u t =>$ u] =>$[f] u]:         [#{x xs..}#e#f fold(xs, e x f#, f)]`[#_#e#_ e]#
@foldr?[{t*} u ~f\[t u =>$ u] =>$[f] u]:        [#{xs.. x}#e#f foldr(xs, x e f# ,f)]`[#_#e#_ e]#
@reduce?[{t+} ~f\[t t =>$ t] =>$[f] t]: #{x xs..}#f xs x f fold
@reducer?[{t+} ~f\[t t =>$ t] =>$[f] t]:       #f pop f foldr
@scan?[@ts{t*} ts u ~f\[u t =>$ u] =>$[f] ts map:u]:      {#{x xs..}#e#f @r(e x f#) r scan(xs, r, f)..}`{#_#_#_}#
@scanr?[@ts{t*} ts u ~f\[t u =>$ u] =>$[f] ts map:u]:     {#{xs.. x}#e#f @r(x e f#) scanr(xs, r, f).. r}`{#_#_#_}#
@spread?[@ts{t*} ts ~f\[t t =>$ t] =>$[f] ts]:        {#{x xs..}#f x scan(xs x f)..}`{#_#_}#
@spreadr?[@ts{t*} ts ~f\[t t =>$ t] =>$[f] ts]:       {#{xs.. x}#f scanr(xs x f).. x}`{#_#_}#
@find?[{t*} ~f\[t =>$ bool] =>`$[f] t]: #{x xs..}#p if(x p#)[x] else: xs p find
@findr?[{t*} ~f\[t =>$ bool] =>`$[f] t]:#{xs.. x}#p if(x p#)[x] else: xs p findr
@findmatch?[{t*} ~f\[t =>`] =>` t]:#m find: m applies nip
@findmatchr?[{t*} ~f\[t =>`] =>` t]:#m findr: m applies nip
@locate?[{t*} ~f\[t =>$ bool] =>`$[f] uint]: 0 locate_i
!locate_i: #{x xs..}#p#n?int if(x p#)[n] else: xs p n 1 + locate_i
@locater?[{t*} ~\f[t =>$ bool] =>`$[f] uint]: over length locater_i
!locater_i: #{xs.. x}#p#n?int if(x p#)[n] else: xs p n 1 - locater_i
@removeat?[~ts #n?uint =>` ts removeat(n)]: #{x xs..}#n if (n 0 =)[xs] else[{x, xs removeat(n 1-)..}]
@remove?[@ts{t+} ~f\[t =>$ bool] =>`$[f] ts init]: #{x xs..}#p if(x p#)[xs] else: {x, xs p remove..}
@all?[{t*} ~f\[t =>$ bool] =>$[f] bool]:         [#{x xs..}#p x p# [xs p all][false]?#]`[#_#_ true]#
@some?[{t*} ~f\[t =>$ bool] =>$[f] bool]:         [#{x xs..}#p x p# [true][xs p some]?#]`[#_#_ false]#
@dowhilefound?[xs.. {t*} ~f\[xs.. t =>$ ys.. xs.. bool] =>$[f] {ys* xs} each[..]]:    [#{x xs..}#p x p# if_t: xs p dowhilefound]`[#_#_]#
@dountilfound?[xs.. {t*} ~f\[xs.. t =>$ ys.. xs.. bool] =>$[f] {ys* xs} each[..]]:    [#{x xs..}#p x p# if_f: xs p dountilfound]`[#_#_]#

@unify?[~t t =>`]: #x #x 
@applied?[xs.. ~t\[xs.. =>` ys..] => [xs..]|[ys..]# bool]:#f [f# true]`*[false]#
@applies?[xs.. ~t\[xs.. =>` ys..] => xs.. bool]:#f [disprove(f) false]`[true]#
@disprove?[xs.. ~t\[xs.. =>` ys..] =>` xs..]:#f !`fail [f!*# #`fail]`[]`fail[#`]#
@proveifthen?[xs.. ~a\[xs.. =>` ys..] ~c\[ys.. =>` zs..] =>` xs..]: #a #c disprove[a# disprove(c)]
@proveiff?[`@xs xs.. [xs.. =>` xs..]*2 =>` xs..]: #f #g proveifthen(f,g) proveifthen(g,f)
@findall?[xs.. ~f\[xs.. => ys.. t] =>$[f] xs.. {t*}]:#f $xs::{}; [xs =: f# xs pushb; .> #`]`*[]# xs#  ?\N.B. syncpoint required otherwise the store transaction may be cancelled!

@solo?[~t => {t}]:             #a {a}
@duo?[~a ~b => {a b}]:        #a#b {a b}
@trio?[~a ~b ~c => {a b c}]: #a#b#c {a b c}
@list?[@vs{n times:`@} vs.. #n?uint => vs]:   #n n 0 > [dip[n 1 - list] push] {} ?#
@count?[~t => {loop:t}]: #n {n loop[dup 1+]}
@countdown?[~t => {loop:t}]:#n {n loop[dup 1-]}
@to[countto] @countto?[~t t => {t*}]:#a#b a count b upto
@tob[countbelow] @countbelow?[~t t => {t*}]:#a#b a count b below
@dto[countdownto] @countdownto?[~t t => {t*}]:#a#b a countdown b downto
@dtoa[countabove] @countabove?[~t t => {t*}]:#a#b a countdown b above
@iota?[#n?uint => {uint*n}]:     #n count(0) below(n)

@box?[~t => {t$}]:#v {v$}
@unbox?[~{t} => t]:#{v} v
@array?[`@t {t*} => {t$*}]:#vs {vs each:$}
@unarray?[`@t {t$*} => {t*}]: map[]
@mutate?[~t => mutate(t)]: [#{vs..} {vs each: mutate$}]`[]
@unmutate?[~t => unmutate(t)]: [#{vs..} vs map[unmutate]]`[]

@rev?[~{ts..} => rev(ts)]:               {#{x xs..} xs rev.. x}`{#_}#
@revr?[~{ts..} => revr(ts)]:              {#{xs.. x} x xs rev..}`{#_}#
@cycle?[~{ts..} => {loop: ts..}]:          #l {l.. l cycle..}
@cycler?[~{ts..} => cycler(ts)]:         #l {l cycler.. l..}
@reps?[~{ts..} => reps(ts)]:     #s#n {n times: s..}
@string?[#n?uint ~t => {t*n}]:  #n#c {n times: c}
@step?[~{ts..} #n?uint => ts n step]:              {#l\{x _..}#n x [(l n leave) n step..]`[]#}`{#_#_}#
@chunk?[~{ts..} #n?uint => ts chunk(n)]:          {#l?(length n >)#n l splitat(n) chunk(n)..}`{#l#_ l}#

?\ Bottom-up merge sort
@sort?[`?t?comp {t*} => {t*}]: sortwith[>]
@sortby?[{t*} ~[t => _?comp] => {t*}]:#f sortwith[apply2(f) >]
@sortwith?[{t*} [t t => bool] => {t*}]:#gt map[solo] while[dup length 1 >][merge_pairs] map[..]
    @merge_pairs:{#{x y r..} merge(x,y) merge_pairs(r)..}`{#{x} x}`{#_}#
    @merge:{#{x xs..}#{y ys..} y gt(x)# [x merge(xs, {y ys..})] [y merge({x xs..}, ys)] ?#}
          `[#{}#ys ys]`[#xs#_ xs]#

@sum?[`@t [t t +]!?t {t+} => t]:              reduce[+]    ?\0 fold[+]
@length?[~{_..} => uint]:              map[#_ 1u] 0u fold[+]
@product?[`@t [t t *]!?t {t+} => t]:          reduce[*]    ?\1 fold[*]
@and?[`@t [t t &]!?t {t+} => t]:              reduce[&]    ?\true fold[&]  or  -1 fold[&]
@or?[`@t [t t |]!?t {t+} => t]:               reduce[|]    ?\false fold[|]  or  0 fold[|]
@xor?[`@t [t t ><]!?t {t+} => t]:            reduce[><]   ?\0 fold[><]
@best?[{t*} ~f\[t t =>$ bool] =>$[f] t]:#f reduce[#a#b a b f# a b ?]
@max?[`@t [t t >]!?bool {t+} => t]:              best[>]
@min?[`@t [t t <]!?bool {t+} => t]:              best[<]
@cat?[`@t {{t*}*} => {t*}]:              map[..]
@showcat?[`@t [t show]!?// {t*} => //]:        map[show..]
@catlines?[{//*} => //]:           map[.. '\n']
@take?[~{ts..} #n?uint => ts take(n)]:         #n n 0 > {#{x xs..} x xs n 1 - take..} {#_} ?#
@leave?[~{ts..} #n?uint => ts leave(n)]:           times[tail]
@splitat?[~{ts..} #n?uint => ts splitat(n)]:        bi2[take][leave]
@topn?[~{ts..} #n?uint => ts topn(n)]:         #n n 0 > {#{xs.. x} xs n 1 - topn.. x} {#_} ?#
@initn?[~{ts..} #n?uint => ts initn(n)]:          times[init]
@upto?[`@t [t t >]!?bool {t*} #n?t => {t*}]:         #n takeuntil[n >]
@downto?[`@t [t t <]!?bool {t*} #n?t => {t*}]:       #n takeuntil[n <]
@upfrom?[`@t [t t <]!?bool {t*} #n?t => {t*}]:       #n leavewhile[n <]
@downfrom?[`@t [t t >]!?bool {t*} #n?t => {t*}]:     #n leavewhile[n >]
@above?[`@t [t t >]!?bool {t*} #n?t => {t*}]:        #n takewhile[n >]
@below?[`@t [t t <]!?bool {t*} #n?t => {t*}]:        #n takewhile[n <]
@fromabove?[`@t [t t >]!?bool {t*} #n?t => {t*}]:    #n leaveuntil[n >]
@frombelow?[`@t [t t <]!?bool {t*} #n?t => {t*}]:    #n leaveuntil[n <]

@findbest?[{t+} ~f\[t =>$ u] ~c\[u u =>$ bool] =>$[f c] t]:#f#c reduce[#a#b a f# b f# c# a b ?]
@findmax?[{t+} ~f\[t =>$ u] [u u >]!?bool =>$[f] t]:                findbest[>]
@findmin?[{t+} ~f\[t =>$ u] [u u <]!?bool =>$[f] t]:                findbest[<]

@zip?[~{{tss..}*} => zip(tss)]:         {#l l map[head], l map[tail] zip..}`{#_}#
@transpose?[~{{tss..}*} => transpose(tss)]:   filterout[empty] {#l\{_+} l map[head], l map[tail] transpose..}`{#_}#
@zipwith?[ts map[#t {t*}] ~f\[ts.. => us..] => {us*} map[..]]:   #f zip map[.. f#]
@mux?[~{ts..} #n?uint => ts mux(n)]:        chunk transpose
@demux?[~{{tss..}*} => tss demux]:          transpose cat
@choose?[`@t {t*} => t]:    #{_.. x _..} x
@merge?[`@t {{t*}*} => {t*}]: {#{ps.. {x xs..} qs..} x, merge{ps.., xs, qs..}..}`{#_}#

@_.*_?[`@n {t*n} {t*n} => t]: zipwith[*] sum

@assert?[xs.. ~f\[xs.. =>$ ys.. bool] =>`$[f] ys..]: # !?()

@consecutive?[`@t {t*} #n?uint => {{t*n}*}]: [#l#n n iota map[#k l k leave] zip]`{#_#_}#

@dictadd?[~d #k ~v => d dictadd(k,v)]:#d#k#v {d<*> v>(k)}
@dictget?[~d #k => d dictget(k)]:#k .\(k)
@dicthas?[~d `? => bool]:#d#k [d.\(k)] applies
@dictremove?[~d #k => d dictremove(k)]:#d#k {d<*> {}>!(k)}
@dictkeys?[~d => dictkeys(d) map[`?t #?t t]]:#d findall[`@k d.\(k) k]
@dictvalues?[~d => dictvalues(d)]:#d findall[`@k d.\(k)]
