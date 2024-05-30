import sys
import pandas as pd

# Function to generate codes
def generate_code(population_name, used_codes):
    # Remove spaces and make the name uppercase
    population_name = population_name.replace(" ", "").upper()
    
    # Take the first two consonants (or vowels) and the last two characters
    code = ""
    consonants = "".join([c for c in population_name if c not in "AEIOU"])
    vowels = "".join([c for c in population_name if c in "AEIOU"])
    
    if len(consonants) >= 2:
        code += consonants[:2]
    else:
        code += consonants
    
    if len(vowels) >= 2:
        code += vowels[:2]
    else:
        code += vowels
    
    # If the name is shorter than four characters, pad with 'X's
    code += 'X' * (4 - len(code))
    
    # If the code already exists, substitute the last character
    count = 1
    while code in used_codes:
        # Find the last character in the population name that is not already in the code
        for char in reversed(population_name):
            if char not in code:
                break
        
        code = code[:-1] + char
        count += 1
        
        # If we can't find a unique code after trying all characters, append a numerical suffix
        if count > len(population_name):
            code += str(count)
            break
    
    used_codes.add(code)
    
    return code

# Function to process the input file and generate codes
def process_file(input_file):
    # Load the data from the input file into a pandas DataFrame
    data = pd.read_csv(input_file, header=None, names=['Population'])

    # Set to store used codes
    used_codes = set()

    # Apply the function to the 'Population' column to generate codes
    data['Code'] = data['Population'].apply(lambda x: generate_code(x, used_codes))

    # Write the updated DataFrame back to the input file
    data.to_csv(input_file, index=False)

if __name__ == "__main__":
    # Check if the correct number of arguments is provided
    if len(sys.argv) != 2:
        print("Usage: python generateCODE.py input_file")
        sys.exit(1)

    input_file = sys.argv[1]
    
    process_file(input_file)

