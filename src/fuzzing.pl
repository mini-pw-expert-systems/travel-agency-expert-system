:- consult('../data/trips_database.pl'). 

% trip(Country, durationFuzzy, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment).

priceFuzzy('niska', PriceNum) :- PriceNum < 1500, !.
priceFuzzy('bardzo niska', PriceNum) :- PriceNum < 3000, !.
priceFuzzy('średnia', PriceNum) :- PriceNum < 6000, !.
priceFuzzy('wysoka', PriceNum) :- PriceNum < 10000, !.
priceFuzzy('bardzo wysoka', _PriceNum) :- !.

% Zakomentowane do rozwazenia:
% priceFuzzy(veryLow, PriceNum, Days) :-
%     Days > 0,
%     PricePerDay is PriceNum / Days,
%     PricePerDay < 200, !.
% priceFuzzy(low, PriceNum, Days) :-
%     Days > 0,
%     PricePerDay is PriceNum / Days,
%     PricePerDay < 500, !.
% priceFuzzy(medium, PriceNum, Days) :-
%     Days > 0,
%     PricePerDay is PriceNum / Days,
%     PricePerDay < 1000, !.
% priceFuzzy(high, PriceNum, Days) :-
%     Days > 0,
%     PricePerDay is PriceNum / Days,
%     PricePerDay < 2000, !.
% priceFuzzy(veryHigh, _PriceNum, _Days) :- !.

durationFuzzy('krótki', Days) :- Days < 7, !.
durationFuzzy('średni', Days) :- Days < 14, !.
durationFuzzy('długi', _Days) :- !.

% trip(Country, durationFuzzy, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment).
tripFuzz(Id, Country, DurationFuzz, PriceFuzz, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment):- 
    trip(Id, Country, Duration, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment),
    priceFuzzy(PriceFuzz, Price), 
    durationFuzzy(DurationFuzz, Duration).