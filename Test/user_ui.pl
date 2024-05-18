:- consult('table_diff.pl').

% Initial attributes
attributes([1, 2, 3, 4]).

find_best_attribute(Attributes, Conditions, MaxAttribute) :-
    findall(PairsCount-Attr, 
            (member(Attr, Attributes), 
             count_diff_attr_dec(Attr, Conditions, PairsCount)), 
            Counts),
    keysort(Counts, SortedCounts),
    reverse(SortedCounts, [_-MaxAttribute|_]).

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
    format('Ask question about attribute ~w: ', [MaxAttribute]),
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

% Entry point to run the script
:- start.
