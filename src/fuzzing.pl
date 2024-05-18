:- consult('../data/trips_database.pl'). 

% "chosen_country": "Francja",
% "duration": 15,
% "price": 3800,
% "accomodation_standard": "zadowalający",
% "transportation": "pociąg",
% "type": "morze",
% "board_basis": "we własnym zakresie",
% "children_friendly": "nie",
% "pets_friendly": "nie",
% "tourist_density": "wysoki",
% "currency": "euro",
% "prepayment_needed": "tak"

% trip(Country, durationFuzzy, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment).

% priceFuzzy(veryLow, PriceNum) :- PriceNum < 1000, !.
% priceFuzzy(low, PriceNum) :- PriceNum < 2000, !.
% priceFuzzy(medium, PriceNum) :- PriceNum < 4000, !.
% priceFuzzy(high, PriceNum) :- PriceNum < 8000, !.
% priceFuzzy(veryHigh, PriceNum) :- !.

% Fuzzy logic for price based on price per day
priceFuzzy(veryLow, PriceNum, Days) :-
    Days > 0,
    PricePerDay is PriceNum / Days,
    PricePerDay < 200, !.

priceFuzzy(low, PriceNum, Days) :-
    Days > 0,
    PricePerDay is PriceNum / Days,
    PricePerDay < 500, !.

priceFuzzy(medium, PriceNum, Days) :-
    Days > 0,
    PricePerDay is PriceNum / Days,
    PricePerDay < 1000, !.

priceFuzzy(high, PriceNum, Days) :-
    Days > 0,
    PricePerDay is PriceNum / Days,
    PricePerDay < 2000, !.

priceFuzzy(veryHigh, _PriceNum, _Days) :- !.

durationFuzzy(short, Days) :- Days < 7, !.
durationFuzzy(medium, Days) :- Days < 14, !.
durationFuzzy(long, _Days) :- !.

% trip(Country, durationFuzzy, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment).
tripFuzz(Country, DurationFuzz, PriceFuzz, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment):- 
    trip(Country, Duration, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment),
    atom_number(Duration, DurationNum),
    nonvar(DurationNum),
    priceFuzzy(PriceFuzz, Price, DurationNum), 
    durationFuzzy(DurationFuzz, DurationNum).