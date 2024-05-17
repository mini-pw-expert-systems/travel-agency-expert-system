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

% Rule to check if an entry satisfies additional conditions.
satisfies_conditions(ID, []).
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

find_entries(Conditions, MatchingEntries) :-
    findall((ID, A1, A2, A3, A4, Dec), 
            (entry(ID, A1, A2, A3, A4, Dec), 
             satisfies_conditions(ID, Conditions)), 
            MatchingEntries).