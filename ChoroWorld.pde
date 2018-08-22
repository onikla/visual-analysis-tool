/**
 *This Class builds a WorldMap using Unfonlding
 *There are Methods implemented to shade Countries Color according to a Country Attribute Value
 *Furthermore it cointains Methods to color specific Countries
 *
 * @author Olivier Niklaus
 * @version 20.12.2017
 *
 */
import java.util.Arrays;
import java.lang.Object;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.*;
//import de.fhpotsdam.unfolding.events.*;
//import de.fhpotsdam.unfolding.geo.Location;
//import java.util.Map;
import java.util.List;

class ChoroWorld{

UnfoldingMap map;
List<Marker> countryMarkers;
Visualization visualization;
ColorMap cm = new ColorMap();
int [] colorArray;


/**
 *Constructor to create a WorldMap using Microsoft Aerial pictures.
 *@Input: parrent Applet 
 */
  public ChoroWorld(Visualization visualization){
    
    this.visualization = visualization;
    map = new UnfoldingMap(this.visualization, 100, 700, 1000, 600,  new Microsoft.AerialProvider());
    map.zoomToLevel(2);
    map.setZoomRange(2,5);
    map.setBackgroundColor(240);
    
    
    // Load country polygons and adds them as markers
    List<Feature> countriespoly = GeoJSONReader.loadData(this.visualization, "count.geo.json");
    countryMarkers = MapUtils.createSimpleMarkers(countriespoly);
    map.addMarkers(countryMarkers);
  
    // ColorCountries in Default-Gray
    colorCountries(countryMarkers);
    MapUtils.createDefaultEventDispatcher(this.visualization, map);
    }
  
/**
 *Method to shade markers according to a countries Life-Expectancy Value
 *@Input: HashMap of Objects Country
 */
  private void shadeCountries(HashMap<String, Country> countryMap) {
  
    for (Marker marker : countryMarkers) {
      // Find data for country of the current marker
      String countryId = (String) marker.getProperty("name");
      // Get the Country
      Country country = countryMap.get(countryId);
  
      if (country != null && country.lifeyears != null) {
        // Encode value as brightness (values range: 0-1000)
        float transparency = map(country.getLifeyears(), 40, 100, 10, 255);
        //float transparency = map(country.getTotalc(), 5, 15, 10, 255);
        marker.setColor(color(255, 0, 0, transparency));
      } 
      else {
        // No value available
        marker.setColor(color(100, 100, 100, 0));
      }
    }
  }
/**
 *Method to color Markers to default color
 *@Input: list of Markers
 */
   private void colorCountries(List<Marker> countryMarkers) {
  
    for (Marker marker : countryMarkers) {
        marker.setColor(color(192,192,192));
      } 
    }
  
  
  
 //Where the map is actually drawn
public void draw(){
  
    background(240);
    
    map.draw();
  }
  
/**
 *Method to color Markers that have been selected through the Scatterplot
 *@Input: List of selected country names
 *@Input: integer for desired color
 */
  public void choroUpdate(List<String> pointsIn, int selectionValue){
     //Identify the markers and check if selected or not
    for (Marker marker: countryMarkers){
      String countryId = (String) marker.getProperty("name");

      if (pointsIn.contains(countryId)){
        int col = cm.colorRamp[selectionValue];
        //System.out.println(cm.colorRamp[1]);
        marker.setColor(col);
      }
     }
     
  }
   public void choroUpdate(ArrayList<List<String>> oldselection){
     //Identify the markers and check if selected or not
    for (Marker marker: countryMarkers){
      String countryId = (String) marker.getProperty("name");
        int i = 0;
        for(List<String> list: oldselection){
          if(list.contains(countryId)){
            int col = cm.colorRamp[i];
              marker.setColor(col);
          }
        i++;}
        
     }
     
  }
  
  
/**
 *Method to color Markers that have been MANUALLY selected through the Scatterplot
 *@Input: List of selected country names
 */
  public void colorCountry(List<String> cname){
    //recolor all to standard
    colorCountries(countryMarkers);
    //color only the selected
    for (Marker marker: countryMarkers){
     String name = (String) marker.getProperty("name");
      
      if(cname.contains(name)){
          marker.setColor(color(0,200,0));}
    }
  }
  
/**
 *Method to (re)color Markers that have been selected through scatterplot selection and Manually selected Countries
 *But was not finished
 *@Input: List of selected country names
 */
  public void choroMasterUpdate(ArrayList<List<String>> oldselection, List<String> cname ){
    
    for (Marker marker: countryMarkers){
      String countryId = (String) marker.getProperty("name");
        
      if(cname.contains(countryId)){marker.setColor(color(0,200,0));}
      else{int i = 0;
          for(List<String> list: oldselection){
            if(list.contains(countryId)){
                  int col = cm.colorRamp[i];
                   marker.setColor(col);
              }
        i++;}
      }
     }
  }
  
  
  
}
  
  
  
  
  
  
  
  