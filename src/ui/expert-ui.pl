:- consult("../../data/trips_database.pl").

main :-
    format('------------------~n'),
    format('~n   Trip planner~n~n'),
    format('------------------~n'),
    format('Choose an action:~n'),
    print_menu_options,
    choose_menu_option.


menu_option(0, print_all_trips, 'Print all trips').
menu_option(1,add_trip, 'Add trip').
menu_option(2,edit_trip, 'Edit trip').
menu_option(3,remove_trip, 'Remove trip').

print_menu_options :-
    menu_option(Index, _, Description),
    format('~p - ~s~n', [Index, Description]),
    fail.
print_menu_options :- !.

choose_menu_option :-
    write('Action'), read(Index), nl, !,
    search_action(Index, Action),
    Action,
    check_exit_action_action(Action).

search_action(Index, Action) :-
    menu_option(Index, Action, _), !.

search_action(_, out_of_range) :-
    format('Option should be from range 0-9~n').

out_of_range.

check_exit_action_action(exit_action) :- !.
check_exit_action_action(_) :- main.
print_error :-
    format('Something went wrong!~n').

print_all_trips :-
    trip(Id, Country, Duration, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment),
    print_location(Id, Country, Duration, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment),
    fail.
   

print_location(Id, Country, Duration, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment) :-
    format('~n| ~w~t~8+ | ~w~t~12+ | ~w~t~2+| ~w~t~10+| ~w~t~15+| ~w~t~10+| ~w~t~10+| ~w~t~15+| ~w~t~3+| ~w~t~3+| ~w~t~15+| ~w~t~6+| ~w~t~3+|~n', [Id, Country, Duration, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment]).

read_trip(Id, Country, Duration, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment) :-
    read_field('ID', Id),
    read_field('Country (in apostrophes)', Country),
    read_field('Duration', Duration),
    read_field('Price', Price),
    read_field('Accomodation', AccStd),
    read_field('Transport', Transport),
    read_field('Type', Type),
    read_field('BoardB', BoardB),
    read_field('ChildFr', ChildFr),
    read_field('Pets', Pets),
    read_field('Tourists', Tourists),
    read_field('Currency', Currency),
    read_field('Payment', Payment).

read_field(Name, Value) :-
    format('~s', [Name]), read(Value).

add_trip :-
    read_trip(Id, Country, Duration, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment), nl,
    not( trip(Id, _, _, _, _, _, _, _, _, _, _, _, _)),
    assert(trip(Id, Country, Duration, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment)),
    format('#Location ~p added~n', [Id]).
edit_trip :-
 read_trip(Id, Country, Duration, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment), nl,  
    retract(trip(Id, _, _, _, _, _, _, _, _, _, _, _, _)),
    assert(trip(Id, Country, Duration, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment)),
    format('Location ~p edited~n', [Id]).
edit_trip :- print_error.


remove_trip :-
    read_field('Location Id', Id), nl,
   trip(Id, _, _, _, _, _, _, _, _, _, _, _, _),
    retract(trip(Id, _, _, _, _, _, _, _, _, _, _, _, _)),
    retractall(trip(Id, _, _, _, _, _, _, _, _, _, _, _, _)),
    format('Location ~p removed~n', [Id]).
remove_trip :-     print_error.