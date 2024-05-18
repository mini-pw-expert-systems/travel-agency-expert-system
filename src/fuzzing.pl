:- consult('../data/trips_database.pl'). 

% trip(Country, durationFuzzy, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment).

priceFuzzy('very_low', PriceNum) :- PriceNum < 1500, !.
priceFuzzy('low', PriceNum) :- PriceNum < 3000, !.
priceFuzzy('medium', PriceNum) :- PriceNum < 6000, !.
priceFuzzy('high', PriceNum) :- PriceNum < 10000, !.
priceFuzzy('very_high', _PriceNum) :- !.

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

durationFuzzy('short', Days) :- Days < 7, !.
durationFuzzy('medium', Days) :- Days < 14, !.
durationFuzzy('long', _Days) :- !.

% trip(Country, durationFuzzy, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment).
trip(Id, Country, DurationFuzz, PriceFuzz, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment):- 
    tripDB(Id, Country, Duration, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment),
    priceFuzzy(PriceFuzz, Price), 
    durationFuzzy(DurationFuzz, Duration).