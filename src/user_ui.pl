:- consult('fuzzing.pl').

% Example trip
% tripDB(1, 'France', 6, 2400, 'satisfactory', 'bus', 'sea', 'included', 'yes', 'yes', 'high', 'euro', 'no').

get_country(ID, Country) :- trip(ID, Country, _, _, _, _, _, _, _, _, _, _, _).

get_attr_value(ID, 1, A1) :- trip(ID, _, A1, _, _, _, _, _, _, _, _, _, _).
get_attr_value(ID, 2, A2) :- trip(ID, _, _, A2, _, _, _, _, _, _, _, _, _).
get_attr_value(ID, 3, A3) :- trip(ID, _, _, _, A3, _, _, _, _, _, _, _, _).
get_attr_value(ID, 4, A4) :- trip(ID, _, _, _, _, A4, _, _, _, _, _, _, _).
get_attr_value(ID, 5, A5) :- trip(ID, _, _, _, _, _, A5, _, _, _, _, _, _).
get_attr_value(ID, 6, A6) :- trip(ID, _, _, _, _, _, _, A6, _, _, _, _, _).
get_attr_value(ID, 7, A7) :- trip(ID, _, _, _, _, _, _, _, A7, _, _, _, _).
get_attr_value(ID, 8, A8) :- trip(ID, _, _, _, _, _, _, _, _, A8, _, _, _).
get_attr_value(ID, 9, A9) :- trip(ID, _, _, _, _, _, _, _, _, _, A9, _, _).
get_attr_value(ID, 10, A10) :- trip(ID, _, _, _, _, _, _, _, _, _, _, A10, _).
get_attr_value(ID, 11, A11) :- trip(ID, _, _, _, _, _, _, _, _, _, _, _, A11).

attribute_name(1, 'duration').
attribute_name(2, 'price').
attribute_name(3, 'accommodation standard').
attribute_name(4, 'transportation').
attribute_name(5, 'type').
attribute_name(6, 'board basis').
attribute_name(7, 'children friendly').
attribute_name(8, 'pets friendly').
attribute_name(9, 'tourist density').
attribute_name(10, 'currency').
attribute_name(11, 'prepayment needed').

attributes([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]).

% Transform duration using fuzzy logic
transform_duration(Number, [Category, Degree]) :-
    durationFuzzy(Category, Number, Degree).

% Transform price using fuzzy logic
transform_price(Number, [Category, Degree]) :-
    priceFuzzy(Category, Number, Degree).

satisfies_conditions(_, []).
satisfies_conditions(ID, [(AttrIndex, Values)|Rest]) :-
    get_attr_value(ID, AttrIndex, AttrValue),
    member(AttrValue, Values),
    satisfies_conditions(ID, Rest).

diff_attr_dec(ID1, ID2, AttrIndex, Conditions) :-
    get_attr_value(ID1, AttrIndex, AttrValue1),
    get_attr_value(ID2, AttrIndex, AttrValue2),
    trip(ID1, Dec1, _, _, _, _, _, _, _, _, _, _, _),
    trip(ID2, Dec2, _, _, _, _, _, _, _, _, _, _, _),
    AttrValue1 \= AttrValue2,
    Dec1 \= Dec2,
    satisfies_conditions(ID1, Conditions),
    satisfies_conditions(ID2, Conditions).

count_diff_attr_dec(AttrIndex, Conditions, PairsCount) :-
    findall((ID1, ID2), 
            (trip(ID1, _, _, _, _, _, _, _, _, _, _, _, _), 
             trip(ID2, _, _, _, _, _, _, _, _, _, _, _, _), 
             ID1 < ID2, 
             diff_attr_dec(ID1, ID2, AttrIndex, Conditions)), 
            Pairs),
    length(Pairs, PairsCount).

find_distinct_values(AttrIndex, Conditions, Values) :-
    findall(Value, 
            (trip(ID, _, _, _, _, _, _, _, _, _, _, _, _), 
             satisfies_conditions(ID, Conditions), 
             get_attr_value(ID, AttrIndex, Value)), 
            AllValues),
    sort(AllValues, Values).

find_distinct_countries(Conditions, Countries) :-
    findall(Country, 
            (trip(ID, Country, _, _, _, _, _, _, _, _, _, _, _), 
             satisfies_conditions(ID, Conditions)), 
            AllCountries),
    sort(AllCountries, Countries).

find_entries(Conditions, MatchingEntries) :-
    findall((ID, Dec, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11), 
            (trip(ID, Dec, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11), 
             satisfies_conditions(ID, Conditions)), 
            MatchingEntries).

find_matching_trip(MatchingTripID) :-
    attributes(Attributes),
    find_matching_trip_loop(Attributes, [], MatchingTripID).

find_matching_trip_loop([], Conditions, MatchingTripID) :-
    find_entries(Conditions, MatchingEntries),
    (   MatchingEntries = [(MatchingTripID, _, _, _, _, _, _, _, _, _, _, _, _)|_] ->
        true
    ;   MatchingTripID = 'Trip not found.'
    ).

find_matching_trip_loop(Attributes, Conditions, MatchingTripID) :-
    Attributes \= [],
    find_best_attribute(Attributes, Conditions, MaxAttribute),
    select(MaxAttribute, Attributes, RemainingAttributes),
    find_distinct_values(MaxAttribute, Conditions, Values),
    (   length(Values, 1) ->
        find_entries(Conditions, [(_, MatchingTripID, _, _, _, _, _, _, _, _, _, _, _)|_])
    ;   attribute_name(MaxAttribute, AttributeName),
        (   MaxAttribute = 1 -> format('Enter duration in days (e.g., 5): ')
        ;   MaxAttribute = 2 -> format('Enter price in PLN (e.g., 2000): ')
        ;   format('Select the ~w (possible values: ~w): ', [AttributeName, Values])
        ),
        read(UserInput),
        (   MaxAttribute = 1 -> (number(UserInput) -> transform_duration(UserInput, TransformedValue) ; TransformedValue = UserInput),
                                NewCondition = (MaxAttribute, [TransformedValue])
        ;   MaxAttribute = 2 -> (number(UserInput) -> transform_price(UserInput, TransformedValue) ; TransformedValue = UserInput),
                                NewCondition = (MaxAttribute, [TransformedValue])
        ;   is_list(UserInput) -> NewCondition = (MaxAttribute, UserInput)
        ;   NewCondition = (MaxAttribute, [UserInput])
        ),
        append(Conditions, [NewCondition], NewConditions),
        
        find_distinct_countries(NewConditions, Countries),
        (   length(Countries, 1) ->
            Countries = [Country],
            MatchingTripID = Country
        ;   find_matching_trip_loop(RemainingAttributes, NewConditions, MatchingTripID)
        )
    ).

start :-
    format('~n'),    
    format('Welcome to the trip matcher!~n'),
    format('The program will ask you a series of questions to find the best matching destination for you.~n'),
    format('You can input a single value or a list of values for each question.~n'),
    format('To input a list, use the format [value1, value2, ...].~n'),
    format('The program will also show you a list of possible values for each question.~n'),
    format('Please make sure that you input the values exactly as shown in the list.~n'),
    format('~n'),
    format('Let\'s start!~n'),
    format('~n'),

    find_matching_trip(MatchingTripID),
    (   MatchingTripID = 'Trip not found.' ->
        format('Matching trip: ~w~n', [MatchingTripID])
    ;   format('Matching trip country: ~w~n', [MatchingTripID])
    ).

find_best_attribute(Attributes, Conditions, MaxAttribute) :-
    findall(PairsCount-Attr, 
            (member(Attr, Attributes), 
             count_diff_attr_dec(Attr, Conditions, PairsCount)), 
            Counts),
    keysort(Counts, SortedCounts),
    reverse(SortedCounts, [_-MaxAttribute|_]).
