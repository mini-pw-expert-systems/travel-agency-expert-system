import tkinter as tk
from tkinter import ttk 

class MainApplication(tk.Frame):
    def __init__(self, parent, *args, **kwargs):
        tk.Frame.__init__(self, parent, *args, **kwargs)
        self.parent = parent

        # duration
        self.duration = tk.StringVar() 
        self.duration_chosen = ttk.Combobox(root, state='readonly', textvariable = self.duration) 
        self.duration_chosen['values'] = ('bardzo krótki',  
                                'krótki', 
                                'średni', 
                                'długi')
        self.duration_chosen.current()
        self.duration_chosen.grid(sticky = tk.W, column = 2, row = 1, pady=10)      

        self.duration_label = ttk.Label(root, text='Czas trwania wycieczki ')
        self.duration_label.grid(sticky = tk.E, column=1, row=1)

        # price
        self.price = tk.StringVar() 
        self.price_chosen = ttk.Combobox(root, state='readonly', textvariable = self.price)
        self.price_chosen['values'] = ('bardzo niska',  
                                'niska', 
                                'umiarkowana', 
                                'wysoka', 
                                'bardzo wysoka')
        self.price_chosen.current() 
        self.price_chosen.grid(sticky = tk.W, column=2, row=2, pady=10)

        self.price_label = ttk.Label(root, text='Cena ')
        self.price_label.grid(sticky = tk.E, column=1, row=2)

        # country/region
        self.region = tk.StringVar() 
        self.region_chosen = ttk.Combobox(root, state='readonly', textvariable = self.region)
        self.region_chosen['values'] = ('Polska',  
                                'Grecja', 
                                'Włochy', 
                                'Hiszpania', 
                                'Portugalia')
        self.region_chosen.current() 
        self.region_chosen.grid(sticky = tk.W, column=2, row=3, pady=10)

        self.region_label = ttk.Label(root, text='Kraj/region ')
        self.region_label.grid(sticky = tk.E, column=1, row=3)

        # transport
        self.transport = tk.StringVar() 
        self.transport_chosen = ttk.Combobox(root, state='readonly', textvariable = self.transport)
        self.transport_chosen['values'] = ('samolot',  
                                'pociąg', 
                                'statek', 
                                'autobus')
        self.transport_chosen.current() 
        self.transport_chosen.grid(sticky = tk.W, column=2, row=4, pady=10)

        self.transport_label = ttk.Label(root, text='Rodzaj transportu ')
        self.transport_label.grid(sticky = tk.E, column=1, row=4)

        # accomodation
        self.accomodation = tk.StringVar() 
        self.accomodation_chosen = ttk.Combobox(root, state='readonly', textvariable = self.accomodation)
        self.accomodation_chosen['values'] = ('zadowalający',  
                                'dobry', 
                                'wysoki', 
                                'luksusowy')
        self.accomodation_chosen.current() 
        self.accomodation_chosen.grid(sticky = tk.W, column=2, row=5, pady=10)

        self.accomodation_label = ttk.Label(root, text='Standard noclegu ')
        self.accomodation_label.grid(sticky = tk.E, column=1, row=5)

        # food
        self.food = tk.StringVar() 
        self.food_chosen = ttk.Combobox(root, state='readonly', textvariable = self.food)
        self.food_chosen['values'] = ('we własnym zakresie',  
                                'w cenie', 
                                'all inclusive')
        self.food_chosen.current() 
        self.food_chosen.grid(sticky = tk.W, column=2, row=6, pady=10)

        self.food_label = ttk.Label(root, text='Wyżywienie ')
        self.food_label.grid(sticky = tk.E, column=1, row=6)

        # type
        self.type = tk.StringVar() 
        self.type_chosen = ttk.Combobox(root, state='readonly', textvariable = self.type)
        self.type_chosen['values'] = ('morze',  
                                'góry', 
                                'miasto')
        self.type_chosen.current() 
        self.type_chosen.grid(sticky = tk.W, column=2, row=7, pady=10)

        self.type_label = ttk.Label(root, text='Typ ')
        self.type_label.grid(sticky = tk.E, column=1, row=7)

        # child-friendly
        self.childfriendly = tk.IntVar()
        self.childfriendly_chosen = tk.Checkbutton(root, variable=self.childfriendly, onvalue=1, offvalue=0)
        self.childfriendly_chosen.grid(sticky = tk.W, column=2, row=8, pady=10)

        self.childfriendly_label = ttk.Label(root, text='Przyjazny dzieciom ')
        self.childfriendly_label.grid(sticky = tk.E, column=1, row=8)

        # pet-friendly
        self.petfriendly = tk.IntVar()
        self.petfriendly_chosen = tk.Checkbutton(root, variable=self.petfriendly, onvalue=1, offvalue=0)
        self.petfriendly_chosen.grid(sticky = tk.W, column=2, row=9, pady=10)

        self.petfriendly_label = ttk.Label(root, text='Przyjazny zwierzętom ')
        self.petfriendly_label.grid(sticky = tk.E, column=1, row=9)

        # distance from Poland
        self.distance = tk.StringVar()
        self.distance_entry = tk.Entry(root, textvariable=self.distance)
        self.distance_entry.grid(sticky = tk.W, column=2, row=10, pady=10)

        self.tourists_label = ttk.Label(root, text='Odległość od Polski (w km) ')
        self.tourists_label.grid(sticky = tk.E, column=1, row=10)

        # tourists
        self.tourists = tk.StringVar() 
        self.tourists_chosen = ttk.Combobox(root, state='readonly', textvariable = self.tourists)
        self.tourists_chosen['values'] = ('niski',  
                                'umiarkowany', 
                                'wysoki',
                                'bardzo wysoki')
        self.tourists_chosen.current() 
        self.tourists_chosen.grid(sticky = tk.W, column=2, row=11, pady=10)

        self.tourists_label = ttk.Label(root, text='Stopień zatłoczenia turystycznego ')
        self.tourists_label.grid(sticky = tk.E, column=1, row=11)

        # shops
        self.shops = tk.StringVar()
        self.shops_entry = tk.Entry(root, textvariable=self.shops)
        self.shops_entry.grid(sticky = tk.W, column=2, row=12, pady=10)

        self.shops_label = ttk.Label(root, text='Liczba sklepów z pamiątkami na km^2 ')
        self.shops_label.grid(sticky = tk.E, column=1, row=12)

        # button
        self.search_button = tk.Button(text="Szukaj wycieczek")
        self.search_button.grid(sticky = tk.E, column=1, row=13)


if __name__ == "__main__":
    root = tk.Tk()
    root.title('Biuro turystyczne')
    root.geometry('400x600') 
    MainApplication(root)
    root.mainloop()