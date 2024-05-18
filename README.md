# travel-agency-expert-system
This repository contains code from Expert Systems course held at Warsaw University of Technology

## User interface
To run the system call: `swipl -s src/user_ui.pl` from the main directory.
When the system is running call: `start.` to start the trip selection process.

## Trip generator
This script generates trip data for a travel agency. User can specify the number of trips and whether to use fuzzy representation in the generated data.

### Usage
Run the script with optional arguments:

`python script_name.py [-f] [-n NUM_TRIPS]` 

Arguments:  
`-f, --fuzzy`:
Use fuzzy (string) representation in the generated data.   
`-n, --num-trips`:
Number of trips to generate (default: 100, range between 1 and 200).
### Example
`python trip_generator.py -f -n 50`  
Generate 50 trips with fuzzy representation

