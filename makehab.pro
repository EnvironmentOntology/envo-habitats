:- use_module(bio(bioprolog_util)).
:- use_module(bio(ontol_db)).

tax(T) :-
        solutions(T,taxenv(T,_,_),Ts),
        member(T,Ts).


makehab(ID,N,TextDef,CDef) :-
        tax(T),
        atom_concat('NCBITaxon:',Frag,T),
        atom_concat('ENVO:H',Frag,ID),
        class(T,TN),
        debug(e,'tax: ~w',[TN]),
        atom_concat(TN,' habitat',N),
        setof(E,EN^taxenv(T,E,EN),Es),
        maplist(class,Es,ENs),
        jlist(ENs,ENA),
        sformat(TextDef,'An environmental system which overlaps ~w and supports the growth of an ecological population of ~w',[ENA,TN]),
        s(Sys),
        solutions(overlaps=E,member(E,Es),Diffs),
        CDef=cdef(Sys,[supports_population_of=T|Diffs]).

jlist(L,A) :-
        L=[H|T],
        concat_atom(T,', ',AT),
        concat_atom([H,AT],' and ',A).

whab :-
        makehab(ID,N,TextDef,CDef),
        format('[Term]~n'),
        format('id: ~w~n',[ID]),
        format('name: ~w~n',[N]),
        format('def: "~w" []~n',[TextDef]),
        CDef=cdef(_,Diffs),
        format('intersection_of: ENVO:01000254 ! environmental system~n',[]),
        forall(member(R=D,Diffs),
               (   class(D,DN),
                   format('intersection_of: ~w ~w ! ~w~n',[R,D,DN]))),
        nl,
        fail.

        



h('ENVO:00002036').
s('ENVO:01000254').


/*
Based on Vangelis' mappings of EOL species to ENVO classes, we would
automatically generate these classes in experimental branches of ENVO (for
the environments) and PCO (for the ecological populations of each species)
where:
- "[Species S] habitat" is an environmental system which overlaps with
[ENVO classes E1...En] and supports the growth of a [PCO ecological
population of Species S]"
- subclass axioms would be something like "'Species S habitat' overlaps
some 'ENVO class Ei'" and "'Species S habitat' habitat for some [PCO
ecological population of Species S]"
*/        
