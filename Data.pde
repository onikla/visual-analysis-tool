/**
 *
 *Class to create a Hashmap of countries and read in a CSV file
 *
 * @author Olivier Niklaus
 * @version 12.11.2017
**/

// Load population data


class Data {

HashMap<String, Country> countryHashMap;

 
private HashMap<String, Country> loadFromCSV(String dataFileName) {
  
  
  String[] rows = loadStrings(dataFileName);
  
   HashMap<String, Country> countryHashMap = new HashMap<String, Country>();
  
   for (int row = 1 ; row < rows.length; row++) {   // startet erst bei 3 um den header zu überspringen
    //System.out.println(str(row) + rows[row]);
    String line = rows[row];
    // Reads country name and Alcohol Consumption value from CSV row
    String[] columns = line.split(";");
    
    if (columns.length >= 2) {
      Country country = new Country();
      country.cname = columns[0];
      //dataEntry.id = columns[1];
      country.totalc = Float.parseFloat(columns[1]);
      country.lifeyears = Float.parseFloat(columns[2]);
      country.beer= Integer.parseInt(columns[3]);
      country.spirits= Integer.parseInt(columns[4]);
      country.wine = Integer.parseInt(columns[5]);
      countryHashMap.put(columns[0], country); 
  }
}
  return countryHashMap;
}
}