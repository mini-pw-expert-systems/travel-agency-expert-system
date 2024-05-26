:- consult('../data/trips_database.pl'). 

% trip(Country, durationFuzzy, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment).

% Fuzzy membership functions for price

very_low_price(Price, Factor) :-
    (number(Price), Price < 1500 -> Factor is 1;
     number(Price), Price >= 1500, Price < 2000 -> Factor is -0.002 * Price + 3;
     number(Price), Price >= 2000 -> Factor is 0).

low_price(Price, Factor) :-
    (number(Price), Price < 1500 -> Factor is 0;
     number(Price), Price >= 1500, Price < 3000 -> Factor is 0.002 * Price - 3;
     number(Price), Price >= 3000, Price < 4000 -> Factor is -0.002 * Price + 4;
     number(Price), Price >= 4000 -> Factor is 0).

medium_price(Price, Factor) :-
    (number(Price), Price < 3000 -> Factor is 0;
     number(Price), Price >= 3000, Price < 6000 -> Factor is 0.001 * Price - 3;
     number(Price), Price >= 6000, Price < 7000 -> Factor is -0.001 * Price + 7;
     number(Price), Price >= 7000 -> Factor is 0).

high_price(Price, Factor) :-
    (number(Price), Price < 6000 -> Factor is 0;
     number(Price), Price >= 6000, Price < 10000 -> Factor is 0.00025 * Price - 1.5;
     number(Price), Price >= 10000 -> Factor is 1).

very_high_price(Price, Factor) :-
    (number(Price), Price < 10000 -> Factor is 0;
     number(Price), Price >= 10000 -> Factor is 1).


% Fuzzy membership functions for duration

short_duration(Duration, Factor) :-
    (number(Duration), Duration < 7 -> Factor is 1;
     number(Duration), Duration >= 7, Duration < 10 -> Factor is -0.3333 * Duration + 3.3333;
     number(Duration), Duration >= 10 -> Factor is 0).

medium_duration(Duration, Factor) :-
    (number(Duration), Duration < 7 -> Factor is 0;
     number(Duration), Duration >= 7, Duration < 14 -> Factor is 0.1429 * Duration - 1;
     number(Duration), Duration >= 14, Duration < 20 -> Factor is -0.1667 * Duration + 3.3333;
     number(Duration), Duration >= 20 -> Factor is 0).

long_duration(Duration, Factor) :-
    (number(Duration), Duration < 14 -> Factor is 0;
     number(Duration), Duration >= 14 -> Factor is 1).


% Defuzzification using the centroid method

defuzzy_center(Factors, FactorValues, Result) :-
    sum_vector_2(Factors, FactorValues, Top),
    sum_vector(Factors, Bottom),
    (member(Bottom, [0, 0.0]) -> Result is 0 ; Result is Top / Bottom).

sum_vector([], 0).
sum_vector([H|T], Sum) :-
    sum_vector(T, R),
    Sum is H + R.

sum_vector_2([], [], 0).
sum_vector_2([H_L|T_L], [H_R|T_R], P) :-
    sum_vector_2(T_L, T_R, R),
    P is (H_L * H_R) + R.


% Evaluating the price factor

evaluate_price(Price, Factor) :-
    price_factor(Price, Factor2),
    price_category(Factor2, Factor).

price_factor(Price, Factor) :-
    very_low_price(Price, F1),
    low_price(Price, F2),
    medium_price(Price, F3),
    high_price(Price, F4),
    very_high_price(Price, F5),
    defuzzy_center([F1, F2, F3, F4, F5], [1, 2, 3, 4, 5], Factor).


% Evaluating the duration factor

evaluate_duration(Duration, Factor) :-
    duration_factor(Duration, Factor2),
    duration_category(Factor2, Factor).

duration_factor(Duration, Factor) :-
    short_duration(Duration, F1),
    medium_duration(Duration, F2),
    long_duration(Duration, F3),
    defuzzy_center([F1, F2, F3], [1, 2, 3], Factor).


% Determining price category

price_category(Factor, Category) :-
    (Factor =< 1.5 -> Category = 'very_low';
     Factor > 1.5, Factor =< 2.5 -> Category = 'low';
     Factor > 2.5, Factor =< 3.5 -> Category = 'medium';
     Factor > 3.5, Factor =< 4.5 -> Category = 'high';
     Factor > 4.5 -> Category = 'very_high').


% Determining duration category

duration_category(Factor, Category) :-
    (Factor =< 1.5 -> Category = 'short';
     Factor > 1.5, Factor =< 2.5 -> Category = 'medium';
     Factor > 2.5 -> Category = 'long').

trip(Id, Country, DurationFuzz, PriceFuzz, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment) :- 
    tripDB(Id, Country, Duration, Price, AccStd, Transport, Type, BoardB, ChildFr, Pets, Tourists, Currency, Payment),
    evaluate_price(Price, PriceFuzz), 
    evaluate_duration(Duration, DurationFuzz).