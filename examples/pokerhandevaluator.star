??rank?{>index::int; >show:://}?int
   [Rank]!?[int|char => rank]
   !Rank:#1|14 {12>index "A">show 14 <*>}
   !Rank:#n?int?(2>=)?(9<=) {(n 2 -)>index (n show)>show n <*>}
   !Rank:#10 {8>index "T">show 10 <*>}
   !Rank:#11 {9>index "J">show 11 <*>}
   !Rank:#12 {10>index "Q">show 12 <*>}
   !Rank:#13 {11>index "K">show 13 <*>}
   !Rank:#'A'|'a' Rank(1)
   !Rank:#r?char?('2'>=)?('9'<=) Rank(r '0' - .asc)
   !Rank:#'T'|'t' Rank(10)
   !Rank:#'J'|'j' Rank(11)
   !Rank:#'Q'|'q' Rank(12)
   @Rank:#'K'|'k' Rank(13)
   @RankFromIndex: 2 + Rank
??suit?'c'|'d'|'h'|'s'
   !Suit[#1 'c'?suit] @Club['c'?suit]     @Clubs:#n Card(n Rank,Club)
   !Suit[#2 'd'?suit] @Diamond['d'?suit]  @Diamonds:#n Card(n Rank,Diamond)
   !Suit[#3 'h'?suit] @Heart['h'?suit]    @Hearts:#n Card(n Rank,Heart)
   @Suit[#4 's'?suit] @Spade['s'?suit]    @Spades:#n Card(n Rank,Spade)
?@card
   @Card:#r?rank #s?suit {r r>rank s s>suit >show:{'[' r.show.. s ']'}}?!card
   !_>_: #c?card #d?card c.rank d.rank >
   !_<_: #c?card #d?card c.rank d.rank <
   !_=_: #c?card #d?card c.rank d.rank =
??handrepr?{{card*5} >kickers::{card*?5}}
??hand?handrepr?@straight|flush|straightflush|fullhouse|quads|trips|twopair|pair|hicard
   [.kickers]!?[hand => {rank*}]
   @sametype:#?straightflush#?straightflush
   @sametype:#?quads#?quads
   @sametype:#?fullhouse#?fullhouse
   @sametype:#?flush#?flush
   @sametype:#?straight#?straight
   @sametype:#?trips#?trips
   @sametype:#?twopair#?twopair
   @sametype:#?pair#?pair
   @sametype:#?hicard#?hicard
   @nexthand:#?quads#?straightflush
   @nexthand:#?fullhouse#?quads
   @nexthand:#?flush#?fullhouse
   @nexthand:#?straight#?flush
   @nexthand:#?trips#?straight
   @nexthand:#?twopair#?trips
   @nexthand:#?pair#?twopair
   @nexthand:#?hicard#?pair
   !_=_:#a?hand #b?hand [a b sametype a b apply2[.kickers]=]`[false]#
   !_<_: #a?hand #b?hand
       [a b sametype a b apply2[.kickers] <]
       `[a b nexthand true]
       `[`@m?hand a m nexthand m b <]
       `[false]#
   !_>_: #a?hand #b?hand
       [a b sametype a b apply2[.kickers] >]
       `[b a nexthand true]
       `[`@m?hand m a nexthand m c >]
       `[false]#
   
   @handeval?[{card*} => hand]: #cards
      @rankcounts:: array{13 times: 0} cards each[#{r _} dup.[r.index]++=]
      @flushsets:: cards splitsuits filter[length 5 >=] 
      
       :    
         flushsets [makestraight?!straightflush]`[] map max
      `:
         @quad:: 4 takebestset; @kicker:: 1 takebestset
         {pickcards{4 times[quad] kicker}  >kickers{quad,kicker}}?!quads
      `:
         @triple:: 3 takebestset; @pair:: 2 takebestset
         {pickcards{3 times[triple] pair pair} >kickers{triple,pair}}?!fullhouse
      `:    
         flushsets [makeflush?!flush] map max
      `:    
         cards makestraight?!straight
      `:
         @triple:: 3 takebestset; @kicker2:: 2 takekickers 
         {pickcards{3 times[triple] kicker2..} >kickers{triple,kicker2..}}?!trips
      `:
         @pairA:: 2 takebestset; @pairB:: 2 takebestset; @kicker:: 1 takebestset 
         {pickcards{pairA pairA pairB pairB kicker} >kickers{pairA,pairB,kicker}}?!twopair
      `:
         @pair:: 2 takebestset; @kicker3:: 3 takekickers 
         {pickcards{pair pair kicker3..} >kickers{pair,kicker3..}}?!pair
      `:
         @kicker5:: 5 takekickers 
         {pickcards(kickers) >kickers::kicker5}?!hicard
      #
      !takekickers?[int => {rank*}]:#n {n times:1 takebestset}
      !takebestset?[int => rank]: #n?int
         rankcounts locater[n >=] keep[#i rankcounts.[i] -=: n] RankFromIndex
      !pickcards?[{rank*} => {card*}]: cards {} pickranks
      !makestraight?[{card*} => handrepr]: #cards
         {cards rankfield
           ?\ 23456789TJQKA
          [#13bxxxxxxxx11111 {10 'J''Q''K''A'} map:Rank]
         `[#13bxxxxxxx11111x { 9 10 'J''Q''K'} map:Rank]
         `[#13bxxxxxx11111xx { 8  9 10 'J''Q'} map:Rank]
         `[#13bxxxxx11111xxx { 7  8  9 10 'J'} map:Rank]
         `[#13bxxxx11111xxxx { 6  7  8  9 10 } map:Rank]
         `[#13bxxx11111xxxxx { 5  6  7  8  9 } map:Rank]
         `[#13bxx11111xxxxxx { 4  5  6  7  8 } map:Rank]
         `[#13bx11111xxxxxxx { 3  4  5  6  7 } map:Rank]
         `[#13b11111xxxxxxxx { 2  3  4  5  6 } map:Rank]
         `[#13b1111xxxxxxxx1 {'A' 2  3  4  5 } map:Rank]#
         @highrank:: dup top 
         cards {} pickranks >kickers{highrank}}
      !makeflush?[{card*} => handrepr]:#cards
         @ranks:: cards map[.rank] sort 5 topn rev 
         {ranks cards {} pickranks >kickers::ranks}
      [pickranks]!?[{rank*}{card*}{card*} => {card*}]
      !pickranks: #{} #cards #picked picked
      !pickranks: #{card\{rank _} cards...} #picked
         rank remove cards (picked push(card)) pickranks
      !rankfield?[{card*} => uint13]: map[#{r _} 13b1 12 r.index - <<] or
      !splitsuits?[{card*} => {{card*}{card*}{card*}{card*}}]: binsuits{{}{}{}{}}
         !binsuits: #{c\{_ 'c'} cards..} #{cs ds hs ss} cards binsuits{cs push(c), ds, hs, ss}
         !binsuits: #{d\{_ 'd'} cards..} #{cs ds hs ss} cards binsuits{cs, ds push(d), hs, ss}
         !binsuits: #{h\{_ 'h'} cards..} #{cs ds hs ss} cards binsuits{cs, ds, hs push(h), ss}
         !binsuits: #{s\{_ 's'} cards..} #{cs ds hs ss} cards binsuits{cs, ds, hs, ss push(s)}
         @binsuits: #{} #bins bins
