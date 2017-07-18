@explorefactor:: 2.0
@iterations:: 250000
@board:: readBoard parseBoard
@parseBoard:#/"[" [parseRow]>first ("," [parseRow]>rest)%3% "]"/ {first, rest...}
@parseRow:#/"[" [parseNum]>first ("," [parseNum]>rest)%3% "]"/ {first, rest...}
@parseNum:#/0-9+'>digits/ Int.parse(digits)?(0 >=)?(16 <)
@best:: ChoiceNode(board) iterations times[dup.MCTS!] .moves findmax:.runs
movemap map[#{k,m} {k, m(board)#}] findmatch[#{_ (best.board)}] writeMove(head)

@ChoiceNode:#board {
   >moves:: movelist(board) map:MoveNode
   >MCTS:
      if(moves empty): 0
      elif(moves.[0].runs 0=): sum(moves map[.MCTSLeaf]) length(moves) / ++
      else: moves findmax[.score(sum(moves map[.runs]))].MCTS ++
}
@movemap:: {{0,[moveup]},{1,[moveright]},{2,[movedown]},{3,[moveleft]}}
@movelist:#board movemap map[#{_ m} m(board)#] filterout: board=
@moveleft:      map[shuntleft]
@moveup:    zip map[shuntleft] zip
@moveright:     map[shuntright]
@movedown:  zip map[shuntright] zip
@shuntleft: @xs:: filterout[0=] merge; {xs.., 4 length(xs)- times:0}
   @merge:[#{x, x, xs..} {x++, merge(xs)...}]`[#{x, xs..} {x, merge(xs)...}]`[#{} {}]#
@shuntright: rev shuntleft rev

@pickrandom:#xs xs.[randInt(xs length)]
@pickdrop: @{two,four}:: pickrandom; (rand 0.9 >) two four ?

@MoveNode:#b {b>board 0>$dist 0>$runs
   >drops:: dropboards(board); >dropnodes:: drops map:map:ChoiceNode
   >MCTS: runs++= pickdrop(dropnodes).MCTS dist+=: dup
   >MCTSLeaf: runs=:1; pickdrop(drops) playout dist=: dup
   >score:#logruns sqrt(logruns runs/ explorefactor*) (dist.?double runs/) +
}
@dropboards:#board {0 to(3) each:#i 0 to(3) each:#j
   if_t(board.[i,j] 0=): {inserttile(1), inserttile(2)} }
   @inserttile:#n mutate(board); dup.[i,j] =: n; unmutate

@playout: movelist [#{} 0]`[pickrandom pickdrop(dropboards) playout++]#
