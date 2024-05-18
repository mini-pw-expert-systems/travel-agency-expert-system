% Define the facts for the table.
entry(1, 'dobra', 'dobra', 'nie', 'nie', 'strata').
entry(2, 'dobra', 'dobra', 'nie', 'tak', 'strata').
entry(3, 'bdb', 'dobra', 'nie', 'nie', 'zysk').
entry(4, 'slaba', 'super', 'nie', 'nie', 'zysk').
entry(5, 'slaba', 'niska', 'tak', 'nie', 'zysk').
entry(6, 'slaba', 'niska', 'tak', 'tak', 'strata').
entry(7, 'bdb', 'niska', 'tak', 'tak', 'zysk').
entry(8, 'dobra', 'super', 'nie', 'nie', 'strata').
entry(9, 'dobra', 'niska', 'tak', 'nie', 'zysk').
entry(10, 'slaba', 'super', 'tak', 'nie', 'zysk').
entry(11, 'dobra', 'super', 'tak', 'tak', 'zysk').
entry(12, 'bdb', 'super', 'nie', 'tak', 'zysk').

% Rule to get the attribute value by index.
get_attr_value(ID, 1, A1) :- entry(ID, A1, _, _, _, _).
get_attr_value(ID, 2, A2) :- entry(ID, _, A2, _, _, _).
get_attr_value(ID, 3, A3) :- entry(ID, _, _, A3, _, _).
get_attr_value(ID, 4, A4) :- entry(ID, _, _, _, A4, _).

% Rule to get the attribute name based on index
attribute_name(1, 'Quality').
attribute_name(2, 'Performance').
attribute_name(3, 'Option1').
attribute_name(4, 'Option2').

% Initial attributes
attributes([1, 2, 3, 4]).

% Rule to check if an entry satisfies additional conditions.
satisfies_conditions(_, []). % Use _ to indicate an unused variable
satisfies_conditions(ID, [(AttrIndex, Value)|Rest]) :-
    get_attr_value(ID, AttrIndex, AttrValue),
    AttrValue = Value,
    satisfies_conditions(ID, Rest).

% Rule to check if two entries differ in the specified attribute and dec while satisfying additional conditions.
diff_attr_dec(ID1, ID2, AttrIndex, Conditions) :-
    get_attr_value(ID1, AttrIndex, AttrValue1),
    get_attr_value(ID2, AttrIndex, AttrValue2),
    entry(ID1, _, _, _, _, Dec1),
    entry(ID2, _, _, _, _, Dec2),
    AttrValue1 \= AttrValue2,
    Dec1 \= Dec2,
    satisfies_conditions(ID1, Conditions),
    satisfies_conditions(ID2, Conditions).

% Rule to count the number of pairs that differ in the specified attribute and dec while satisfying additional conditions.
count_diff_attr_dec(AttrIndex, Conditions, PairsCount) :-
    findall((ID1, ID2), 
            (entry(ID1, _, _, _, _, _), 
             entry(ID2, _, _, _, _, _), 
             ID1 < ID2, 
             diff_attr_dec(ID1, ID2, AttrIndex, Conditions)), 
            Pairs),
    length(Pairs, PairsCount).

% Rule to find distinct values for a specific attribute while satisfying conditions
find_distinct_values(AttrIndex, Conditions, Values) :-
    findall(Value, 
            (entry(ID, _, _, _, _, _), 
             satisfies_conditions(ID, Conditions), 
             get_attr_value(ID, AttrIndex, Value)), 
            AllValues),
    sort(AllValues, Values).

% Rule to find entries that satisfy the conditions
find_entries(Conditions, MatchingEntries) :-
    findall((ID, A1, A2, A3, A4, Dec), 
            (entry(ID, A1, A2, A3, A4, Dec), 
             satisfies_conditions(ID, Conditions)), 
            MatchingEntries).

% Recursive loop to find the best matching entry
find_matching_entry(MatchingEntry) :-
    attributes(Attributes),
    find_matching_entry_loop(Attributes, [], MatchingEntry).

find_matching_entry_loop([], Conditions, MatchingEntry) :-
    % Base case: No more attributes to check
    find_entries(Conditions, MatchingEntries),
    (   MatchingEntries = [MatchingEntry|_] ->
        true
    ;   MatchingEntry = 'No unique matching entry found'
    ).

find_matching_entry_loop(Attributes, Conditions, MatchingEntry) :-
    Attributes \= [],  % Ensure attributes list is not empty
    find_best_attribute(Attributes, Conditions, MaxAttribute),
    select(MaxAttribute, Attributes, RemainingAttributes),
    find_distinct_values(MaxAttribute, Conditions, Values),
    attribute_name(MaxAttribute, AttributeName),
    format('Select the ~w (possible values: ~w): ', [AttributeName, Values]),
    read(Value),
    NewCondition = (MaxAttribute, Value),
    append(Conditions, [NewCondition], NewConditions),
    
    % Check for collisions and inconsistencies
    find_entries(NewConditions, MatchingEntries),
    (   length(MatchingEntries, 1) ->
        MatchingEntries = [MatchingEntry]
    ;   find_matching_entry_loop(RemainingAttributes, NewConditions, MatchingEntry)
    ).

% Start the process
start :-
    find_matching_entry(MatchingEntry),
    format('Matching entry: ~w~n', [MatchingEntry]).

% Find the best attribute that maximizes the difference in attribute values
find_best_attribute(Attributes, Conditions, MaxAttribute) :-
    findall(PairsCount-Attr, 
            (member(Attr, Attributes), 
             count_diff_attr_dec(Attr, Conditions, PairsCount)), 
            Counts),
    keysort(Counts, SortedCounts),
    reverse(SortedCounts, [_-MaxAttribute|_]).
