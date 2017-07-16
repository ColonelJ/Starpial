?>>>>>>> PROLOG CODE >>>>>>>>

top:-queens(8,Qs),fail.
top.

queens(N,Qs) :-
	range(1,N,Ns),
	queens(Ns,[],Qs).

queens([],Qs,Qs).
queens(UnplacedQs,SafeQs,Qs) :-
	select(UnplacedQs,UnplacedQs1,Q),
	not_attack(SafeQs,Q),
	queens(UnplacedQs1,[Q|SafeQs],Qs).

not_attack(Xs,X) :-
	not_attack(Xs,X,1).

not_attack([],_,_) :- !.
not_attack([Y|Ys],X,N) :-
	X =\= Y+N, X =\= Y-N,
	N1 is N+1,
	not_attack(Ys,X,N1).

select([X|Xs],Xs,X).
select([Y|Ys],[Y|Zs],X) :- select(Ys,Zs,X).

range(N,N,[N]) :- !.
range(M,N,[M|Ns]) :-
	M < N,
	M1 is M+1,
	range(M1,N,Ns).

<<<<<<<< PROLOG CODE <<<<<<<?

@top::[`@Qs queens(8, Qs) show(Qs) print .> #`]`[]

@queens:#N #Qs `@Ns range(1, N, Ns) queens_aux(Ns, {}, Qs)

!queens_aux:#{} #Qs #Qs
@queens_aux:#UnplacedQs #SafeQs #Qs `@UnplacedQs1 `@Q
    select(UnplacedQs, UnplacedQs1, Q)
    not_attack(SafeQs, Q)
    queens_aux(UnplacedQs1, {Q, SafeQs..}, Qs)

@not_attack:#Xs #X not_attack_aux(Xs, X, 1)

@not_attack_aux::[#{} #_ #_]
    !:#{Y, Ys..} #X #N
        X ?(Y N+ =~) !?(Y N- =~)
        not_attack_aux(Ys, X, N 1+)

!select:#{X, Xs..} #Xs #X
@select:#{Y, Ys..} #{Y, Zs..} #X select(Ys, Zs, X)

@range::[#N #N #{N}]
    !:#M #N #{M, Ns..} M N < !? range(M 1+, N, Ns)
