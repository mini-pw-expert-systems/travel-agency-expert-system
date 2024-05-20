:- consult('../data/trips_database.pl').

% Triangular membership function
triangular(X, A, B, C, Degree) :-
    (X < A -> Degree is 0;
     X >= A, X < B -> Degree is (X - A) / (B - A);
     X >= B, X < C -> Degree is (C - X) / (C - B);
     X >= C -> Degree is 0).

% Fuzzy categories for price
priceFuzzy('very_low', PriceNum, Degree) :- 
    triangular(PriceNum, 0, 0, 1500, Degree).
priceFuzzy('low', PriceNum, Degree) :- 
    triangular(PriceNum, 1000, 1500, 3000, Degree).
priceFuzzy('medium', PriceNum, Degree) :- 
    triangular(PriceNum, 2000, 4000, 6000, Degree).
priceFuzzy('high', PriceNum, Degree) :- 
    triangular(PriceNum, 5000, 7500, 10000, Degree).
priceFuzzy('very_high', PriceNum, Degree) :- 
    triangular(PriceNum, 8000, 10000, 100000, Degree).

% Fuzzy categories for duration
durationFuzzy('short', Days, Degree) :- 
    triangular(Days, 0, 0, 7, Degree).
durationFuzzy('medium', Days, Degree) :- 
    triangular(Days, 5, 7, 14, Degree).
durationFuzzy('long', Days, Degree) :- 
    triangular(Days, 10, 14, 10000, Degree).

% Trip predicate utilizing fuzzy categories
trip(Id, Country, DurationFuzz, PriceFuzz, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment):- 
    tripDB(Id, Country, Duration, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment),
    priceFuzzy(PriceLabel, Price, PriceDegree),
    durationFuzzy(DurationLabel, Duration, DurationDegree),
    DurationFuzz = [DurationLabel, DurationDegree],
    PriceFuzz = [PriceLabel, PriceDegree].

% Example usage to see the transformations
example_usage :-
    trip(1, Country, DurationFuzz, PriceFuzz, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment),
    writeln([Country, DurationFuzz, PriceFuzz, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment]).
