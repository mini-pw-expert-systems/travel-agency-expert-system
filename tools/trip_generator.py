import argparse
import random
import json
import numpy as np

class TripGenerator:
    DURATION = ['bardzo krótki', 'krótki', 'średni', 'długi']
    ACCOMODATION_STANDARD = ['zadowalający', 'dobry', 'wysoki', 'luksusowy']
    PRICE_RANGE = (200, 1000)
    TRANSPORTATION = ['samolot', 'prom', 'autobus', 'pociąg']
    BOARD_BASIS = ['we własnym zakresie', 'w cenie', 'all inclusive']
    CHILDREN_FRIENDLY = ['tak', 'nie']
    PETS_FRIENDLY = ['tak', 'nie']
    TOURIST_DENSITY = ['niski', 'umiarkowany', 'wysoki', 'bardzo wysoki']
    SOUVERNIR_SHOPS_PER_SQ_KM_RANGE = (0, 50)
    
    COUNTRIES = {
    'Francja': {'trip_types': ['góry', 'morze', 'miasto'], 'distance_range': (1000, 2000)},
    'Włochy': {'trip_types': ['góry', 'morze', 'miasto'], 'distance_range': (900, 1800)},
    'Niemcy': {'trip_types': ['góry', 'miasto'], 'distance_range': (500, 1000)},
    'Hiszpania': {'trip_types': ['góry', 'morze', 'miasto'], 'distance_range': (2000, 3000)},
    'Grecja': {'trip_types': ['góry', 'morze', 'miasto'], 'distance_range': (1500, 2500)},
    'Portugalia': {'trip_types': ['góry', 'morze'], 'distance_range': (2500, 3500)},
    'Holandia': {'trip_types': ['miasto'], 'distance_range': (800, 1200)},
    'Szwajcaria': {'trip_types': ['góry', 'miasto'], 'distance_range': (800, 1200)},
    'Austria': {'trip_types': ['góry', 'miasto'], 'distance_range': (700, 1100)},
    'Belgia': {'trip_types': ['miasto'], 'distance_range': (800, 1200)}
    }


    def generate_trip(self):
        duration = random.choice(self.DURATION)
        standard = random.choice(self.ACCOMODATION_STANDARD)
        price = self._calculate_price(standard, duration)
        country = random.choice(list(self.COUNTRIES.keys()))
        trip_type = random.choice(self.COUNTRIES[country]['trip_types'])
        transportation = random.choice(self.TRANSPORTATION)
        board_basis = random.choice(self.BOARD_BASIS)
        children_friendly = random.choice(self.PETS_FRIENDLY)
        pets_friendly = random.choice(self.PETS_FRIENDLY)
        tourist_density = random.choice(self.TOURIST_DENSITY)
        distance_from_poland = random.randint(self.COUNTRIES[country]['distance_range'][0], self.COUNTRIES[country]['distance_range'][1])
        souvenir_shops_per_sq_km = random.randint(self.SOUVERNIR_SHOPS_PER_SQ_KM_RANGE[0], self.SOUVERNIR_SHOPS_PER_SQ_KM_RANGE[1])

        trip = {
            'country': country,
            'duration': duration,
            'price': price,
            'accomodation_standard': standard,
            'transportation': transportation,
            'type': trip_type,
            'board_basis': board_basis,
            'children_friendly': children_friendly,
            'pets_friendly': pets_friendly,
            'tourist_density': tourist_density,
            'distance_from_poland': distance_from_poland,
            'souvenir_shops_per_sq_km': souvenir_shops_per_sq_km
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
        duration_multiplier = self.DURATION.index(duration) + 1
        
        # Multiply base price and round to the nearest hundred
        return np.round(base_price * accomodation_standard_multiplier * duration_multiplier, -2).item()

def main():
    parser = argparse.ArgumentParser(description='Generate trip data for travel agency.')
    parser.add_argument('-n', '--num-trips', type=int, default=20, help='Number of trips to generate (between 1 and 100)')
    args = parser.parse_args()

    num_trips = max(min(args.num_trips, 100), 1)

    generator = TripGenerator()
    trips_data = generator.generate_trips(num_trips)

    with open('trips_data.json', 'w') as f:
        json.dump(trips_data, f, indent=4)
    print(f"{num_trips} trips data generated successfully!")
    
main()