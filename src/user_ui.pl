% Consult necessary files
% :- consult('../data/trips_database_fuzzy.pl').
:- consult('fuzzing.pl').

% Example trip
% trip(1, 'Polska', 'bardzo krótki', 'bardzo niska', 'zadowalający', 'prom', 'góry', 'we własnym zakresie', 'tak', 'nie', 'umiarkowany', 'pln', 'tak').

% Predicate to get the country of a trip
get_country(ID, Country) :- trip(ID, Country, _, _, _, _, _, _, _, _, _, _, _).

% Attribute value predicates
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

% Rule to get the attribute name based on index
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

% Initial attributes
attributes([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]).

% Transform numeric values into categories for duration
transform_duration(Number, Category) :-
    (   Number < 7 -> Category = 'short'
    ;   Number < 14 -> Category = 'medium'
    ;   Category = 'long'
    ).

% Transform numeric values into categories for price
transform_price(Number, Category) :-
    (   Number < 1500 -> Category = 'very_low'
    ;   Number < 3000 -> Category = 'low'
    ;   Number < 6000 -> Category = 'medium'
    ;   Number < 10000 -> Category = 'high'
    ;   Category = 'very_high'
    ).

% Rule to check if a trip satisfies additional conditions.
satisfies_conditions(_, []). % Use _ to indicate an unused variable
satisfies_conditions(ID, [(AttrIndex, Values)|Rest]) :-
    get_attr_value(ID, AttrIndex, AttrValue),
    member(AttrValue, Values),
    satisfies_conditions(ID, Rest).

% Rule to check if two entries differ in the specified attribute and decision while satisfying additional conditions.
diff_attr_dec(ID1, ID2, AttrIndex, Conditions) :-
    get_attr_value(ID1, AttrIndex, AttrValue1),
    get_attr_value(ID2, AttrIndex, AttrValue2),
    trip(ID1, Dec1, _, _, _, _, _, _, _, _, _, _, _),
    trip(ID2, Dec2, _, _, _, _, _, _, _, _, _, _, _),
    AttrValue1 \= AttrValue2,
    Dec1 \= Dec2,
    satisfies_conditions(ID1, Conditions),
    satisfies_conditions(ID2, Conditions).

% Rule to count the number of pairs that differ in the specified attribute and decision while satisfying additional conditions.
count_diff_attr_dec(AttrIndex, Conditions, PairsCount) :-
    findall((ID1, ID2), 
            (trip(ID1, _, _, _, _, _, _, _, _, _, _, _, _), 
             trip(ID2, _, _, _, _, _, _, _, _, _, _, _, _), 
             ID1 < ID2, 
             diff_attr_dec(ID1, ID2, AttrIndex, Conditions)), 
            Pairs),
    length(Pairs, PairsCount).

% Rule to find distinct values for a specific attribute while satisfying conditions
find_distinct_values(AttrIndex, Conditions, Values) :-
    findall(Value, 
            (trip(ID, _, _, _, _, _, _, _, _, _, _, _, _), 
             satisfies_conditions(ID, Conditions), 
             get_attr_value(ID, AttrIndex, Value)), 
            AllValues),
    sort(AllValues, Values).

% Rule to find distinct countries while satisfying conditions
find_distinct_countries(Conditions, Countries) :-
    findall(Country, 
            (trip(ID, Country, _, _, _, _, _, _, _, _, _, _, _), 
             satisfies_conditions(ID, Conditions)), 
            AllCountries),
    sort(AllCountries, Countries).

% Rule to find entries that satisfy the conditions
find_entries(Conditions, MatchingEntries) :-
    findall((ID, Dec, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11), 
            (trip(ID, Dec, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11), 
             satisfies_conditions(ID, Conditions)), 
            MatchingEntries).

% Recursive loop to find the best matching trip
find_matching_trip(MatchingTripID) :-
    attributes(Attributes),
    find_matching_trip_loop(Attributes, [], MatchingTripID).

find_matching_trip_loop([], Conditions, MatchingTripID) :-
    % Base case: No more attributes to check
    find_entries(Conditions, MatchingEntries),
    (   MatchingEntries = [(MatchingTripID, _, _, _, _, _, _, _, _, _, _, _, _)|_] ->
        true
    ;   MatchingTripID = 'Trip not found.'
    ).

find_matching_trip_loop(Attributes, Conditions, MatchingTripID) :-
    Attributes \= [],  % Ensure attributes list is not empty
    find_best_attribute(Attributes, Conditions, MaxAttribute),
    select(MaxAttribute, Attributes, RemainingAttributes),
    find_distinct_values(MaxAttribute, Conditions, Values),
    attribute_name(MaxAttribute, AttributeName),
    (   MaxAttribute = 1 -> format('Enter duration in days (e.g., 5): ')
    ;   MaxAttribute = 2 -> format('Enter price in PLN (e.g., 2000): ')
    ;   format('Select the ~w (possible values: ~w, input as a list [value1, value2, ...] or a single value): ', [AttributeName, Values])
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
    
    % Check for collisions and inconsistencies
    find_distinct_countries(NewConditions, Countries),
    (   length(Countries, 1) ->
        Countries = [Country],
        MatchingTripID = Country
    ;   find_matching_trip_loop(RemainingAttributes, NewConditions, MatchingTripID)
    ).

% Start the process
start :-
    find_matching_trip(MatchingTripID),
    (   MatchingTripID = 'Trip not found.' ->
        format('Matching trip: ~w~n', [MatchingTripID])
    ;   format('Matching trip country: ~w~n', [MatchingTripID])
    ).

% Find the best attribute that maximizes the difference in attribute values
find_best_attribute(Attributes, Conditions, MaxAttribute) :-
    findall(PairsCount-Attr, 
            (member(Attr, Attributes), 
             count_diff_attr_dec(Attr, Conditions, PairsCount)), 
            Counts),
    keysort(Counts, SortedCounts),
    reverse(SortedCounts, [_-MaxAttribute|_]).
