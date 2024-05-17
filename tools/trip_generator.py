import argparse
import random
import json
import os
import numpy as np

class TripGenerator:
    BASE_PATH = "../data/"
    
    DURATION_RANGE = (2,15)
    ACCOMODATION_STANDARD = ['zadowalający', 'dobry', 'wysoki', 'luksusowy']
    PRICE_RANGE = (100, 400)
    TRANSPORTATION = ['samolot', 'prom', 'autobus', 'pociąg']
    BOARD_BASIS = ['we własnym zakresie', 'w cenie', 'all inclusive']
    CHILDREN_FRIENDLY = ['tak', 'nie']
    PETS_FRIENDLY = ['tak', 'nie']
    PREPAYMENT_NEEDED = ['tak', 'nie']
    TOURIST_DENSITY = ['niski', 'umiarkowany', 'wysoki', 'bardzo wysoki']
    
    COUNTRIES = {
    'Francja': {'trip_types': ['góry', 'morze', 'miasto'], 'currency': 'euro'},
    'Włochy': {'trip_types': ['góry', 'morze', 'miasto'], 'currency': 'euro'},
    'Polska': {'trip_types': ['góry', 'morze'], 'currency': 'pln'},
    'Hiszpania': {'trip_types': ['morze', 'miasto'], 'currency': 'euro'},
    'Japonia': {'trip_types': ['góry', 'morze', 'miasto'], 'currency': 'yen'},
    }


    def generate_trip(self):
        chosen_country = random.choice(list(self.COUNTRIES.keys()))
        duration = random.randint(self.DURATION_RANGE[0], self.DURATION_RANGE[1])
        standard = random.choice(self.ACCOMODATION_STANDARD)
        price = self._calculate_price(standard, duration)
        trip_type = random.choice(self.COUNTRIES[chosen_country]['trip_types'])
        transportation = random.choice(self.TRANSPORTATION)
        board_basis = random.choice(self.BOARD_BASIS)
        children_friendly = random.choice(self.PETS_FRIENDLY)
        pets_friendly = random.choice(self.PETS_FRIENDLY)
        tourist_density = random.choice(self.TOURIST_DENSITY)
        currency = self.COUNTRIES[chosen_country]['currency']
        prepayment_needed = random.choice(self.PREPAYMENT_NEEDED)

        trip = {
            'chosen_country': chosen_country,
            'duration': duration,
            'price': price,
            'accomodation_standard': standard,
            'transportation': transportation,
            'type': trip_type,
            'board_basis': board_basis,
            'children_friendly': children_friendly,
            'pets_friendly': pets_friendly,
            'tourist_density': tourist_density,
            'currency': currency,
            'prepayment_needed': prepayment_needed
        }
        return trip

    def generate_trips(self, num_trips):
        trips = []
        for _ in range(num_trips):
            trips.append(self.generate_trip())
        return trips
    
    def _calculate_price(self, standard, duration):
        base_price = random.randint(self.PRICE_RANGE[0], self.PRICE_RANGE[1])
        accomodation_standard_multiplier = self.ACCOMODATION_STANDARD.index(standard) + 1
        duration_multiplier = duration
        
        # Multiply base price and round to the nearest hundred
        return np.round(base_price * accomodation_standard_multiplier * duration_multiplier, -2).item()
    
    def _create_json_database(self, trips):
        with open(self.BASE_PATH + 'trips_database.json', 'w', encoding='utf-8') as f:
            json.dump(trips, f, indent=4, ensure_ascii=False)
            
    def _create_prolog_database(self, trips):
        with open(self.BASE_PATH + 'trips_database.pl', 'w', encoding='utf-8') as f:
            f.write('% Facts representing trips available trips. \n')
            for trip in trips:
                f.write(f"trip('{trip['chosen_country']}', '{trip['duration']}', {trip['price']}, '{trip['accomodation_standard']}', '{trip['transportation']}', '{trip['type']}', '{trip['board_basis']}', '{trip['children_friendly']}', '{trip['pets_friendly']}', '{trip['tourist_density']}', '{trip['currency']}', '{trip['prepayment_needed']}').\n")
    

def main():
    parser = argparse.ArgumentParser(description='Generate trip data for travel agency.')
    parser.add_argument('-n', '--num-trips', type=int, default=100, help='Number of decisions to generate (between 1 and 100)')
    args = parser.parse_args()

    num_trips = max(min(args.num_trips, 200), 1)

    generator = TripGenerator()
    trips_data = generator.generate_trips(num_trips)

    if not os.path.exists(generator.BASE_PATH):
        os.makedirs(generator.BASE_PATH)

    generator._create_json_database(trips_data)
    generator._create_prolog_database(trips_data)
    
    print(f"{num_trips} trips data generated successfully!")
    
main()