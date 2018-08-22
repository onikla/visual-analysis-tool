
/**
 * This Class creats a Scatterplot using the library "grafica"
 * 
 * @author Olivier Niklaus
 * @version 12.11.2017
**/

import grafica.*;

class ScatterPlot {
  
  GPointsArray points = new GPointsArray();
  GPointsArray highPoints = new GPointsArray();
  GPointsArray chosenPoints = new GPointsArray();
  //GPoint tempPoint = new GPoint(0,0,"Will be overwritten");

  ColorMap cm = new ColorMap();
  GPlot plot;
  GPlot newplot;
  GPoint highpoint;
  Visualization visualization;
  int [] colorArray;
  HashMap<String, Country> countryMap;
  
 /**
   * Constructor ScatterPlot
   *@Input HashMap of Object countries and parrent Applet
   */
 public ScatterPlot(HashMap<String, Country> countryMap, Visualization visualization){ //<>//
   
   this.visualization = visualization;
   this.countryMap = countryMap;
   
    //Iterate over HashMap to get Countries Value and assign to ScatterPlot point
    //Default Scatterplot uses Wine and Beer
     for (Country country : countryMap.values()){
       GPoint gpoint = new GPoint((float) country.getBeer() , country.getWine(), country.getName());
       points.add(gpoint);
       
     }
  this.colorArray = new int[points.getNPoints()];
  for(int i = 0; i < colorArray.length; i++){
    colorArray[i] = color(192,192,192);
  }
  
  
  //Setup the Plot properties
  plot = new GPlot(visualization);
  plot.setPos(25,25);
  plot.setDim(800, 500);
  plot.setTitleText("Beer vs. Wine"); 
  plot.getXAxis().setAxisLabelText("Beer");
  plot.getYAxis().setAxisLabelText("Wine");
  plot.getXAxis().setFontSize(22);
  plot.getYAxis().setFontSize(22);
  plot.getTitle().setFontSize(30);
  plot.setFontSize(22);
  plot.getXAxis().getAxisLabel().setFontSize(28);
  plot.getYAxis().getAxisLabel().setFontSize(28);
  plot.setPoints(points);
  plot.setPointSize(12);
  plot.setPointColors(colorArray);
  plot.activatePointLabels();
  plot.activatePanning();
  plot.activateZooming(1.1, CENTER, CENTER);
 }
 
 //Where the plot is actually drawn
 public void draw(){
   
  
  plot.beginDraw();
  plot.drawBox();
  plot.drawGridLines(GPlot.BOTH);
  plot.drawXAxis();
  plot.drawYAxis();
  plot.drawTitle();
  plot.drawPoints();
  plot.drawLabels();
  plot.endDraw();
  
 }
 
/**
 * Update Coordinates of Points according to new Axis
 *@Input integer for x and y value resulting from Controller
 *@Input HashMap of the selected Countries, which are stored in a seperate GPointArray
 */
 
 public void updateX(int newX, int yvalue, HashMap<String, Country> selectedCountries){
 
   String xname;
   String yname;
   List<String> names = Arrays.asList("Life expectancy","Beer","Wine","Spirits","Total Alcohol");
   xname = names.get(newX);
   yname = names.get(yvalue);
   
   //Recreate new Plot over the old one
   plot = new GPlot(visualization);
   plot.setPos(25,25);
   plot.setDim(800, 500);
   plot.getYAxis().getAxisLabel().setText(yname);
   plot.getXAxis().getAxisLabel().setText(xname);
   
   //Update the X-coordinate of Points
   int i = 0;
   for(Country c: countryMap.values()){
    // c.getName().contentEquals()
     points.setX(i, c.getCountryAttribute(newX));
     i++;}
    
    //If manually selected points, recalculate X-coordinate 
    if(selectedCountries.size() != 0){
          int rmax = chosenPoints.getNPoints();
          chosenPoints.removeRange(0,rmax);
       for(Country country : selectedCountries.values()){
              chosenPoints.add(country.getCountryAttribute(newX) ,country.getCountryAttribute(yvalue));}
     } 
   
   //Set up the updated Plot
   plot.removeLayer("chosenPoints");   
   plot.getXAxis().setFontSize(22);
   plot.getYAxis().setFontSize(22);
   plot.setTitleText(xname + " and " + yname);
   plot.getTitle().setFontSize(30);
   plot.getXAxis().getAxisLabel().setFontSize(28);
   plot.getYAxis().getAxisLabel().setFontSize(28);
   plot.setPoints(points);
   plot.addLayer("chosenPoints", chosenPoints);
   plot.getLayer("chosenPoints").setPointSize(20);
   plot.getLayer("chosenPoints").setPointColor(color(0,200,0));
   plot.setPointColors(colorArray);
   plot.setPointSize(12);
   plot.activatePointLabels();
   plot.setFontSize(22);
   plot.activatePanning();
   plot.activateZooming(1.1, CENTER, CENTER);
   }
 
 /**
 * Update Coordinates of Points according to new Axis
 *@Input integer for x and y value resulting from Controller
 *@Input HashMap of the selected Countries, which are stored in a seperate GPointArray
 */
  public void updateY(int newY, int xvalue, HashMap<String, Country> selectedCountries){
    
   String yname;
   String xname;
   List<String> names = Arrays.asList("Life expectancy","Beer","Wine","Spirits","Total Alcohol");
   xname = names.get(xvalue);
   yname = names.get(newY);

   //Recreate new Plot over the old one
   plot = new GPlot(visualization);
   plot.setPos(25,25);
   plot.setDim(800, 500);
   plot.getXAxis().getAxisLabel().setText(xname);
   plot.getYAxis().getAxisLabel().setText(yname);
   
   //Update the X-coordinate of Points
   int i = 0;
   for(Country c: countryMap.values()){
     points.setY(i, c.getCountryAttribute(newY));
     i++;}
     
   //If manually selected points, recalculate X-coordinate 
   if(selectedCountries.size() != 0){
        int rmax = chosenPoints.getNPoints(); //remove all old chosenPoints
        chosenPoints.removeRange(0,rmax);
     for(Country country : selectedCountries.values()){
      chosenPoints.add(country.getCountryAttribute(xvalue) ,country.getCountryAttribute(newY));}
     } 
     
    plot.removeLayer("chosenPoints");   
    plot.getXAxis().setFontSize(22);
    plot.getYAxis().setFontSize(22);
    plot.getTitle().setFontSize(30);
    plot.setTitleText(xname + " and " + yname);
    plot.getXAxis().getAxisLabel().setFontSize(28);
    plot.getYAxis().getAxisLabel().setFontSize(28);
    plot.setPoints(points);
    plot.setPointSize(12);
    plot.setFontSize(22);
    plot.addLayer("chosenPoints", chosenPoints);
    plot.getLayer("chosenPoints").setPointSize(20);
    plot.getLayer("chosenPoints").setPointColor(color(0,200,0));
    plot.setPointColors(colorArray);
    plot.activatePointLabels();
    plot.activatePanning();
    plot.activateZooming(1.1, CENTER, CENTER);
    //plot.updateLimits();
   }

/**
 * Calcultes all points that are within the scatterplotbox
 *@Input integer for color Value
 *@Output: List of point names 
 */
 public List<String> getPointsInBox(int selectionValue){
   //GPointsArray pointsInBox = new GPointsArray();
   List<String> pointnames = new ArrayList<String>();
   
   float xlim[];
   float ylim[];
   GPoint gpoint;
   
   xlim = plot.getXLim();
   ylim = plot.getYLim(); 
   
   for(int i = 0; i < points.getNPoints() ; i++){
     gpoint = points.get(i);
     
       if(xlim[0] < gpoint.getX() && gpoint.getX() < xlim[1] && ylim[0] < gpoint.getY() && gpoint.getY() < ylim[1]){
         pointnames.add(gpoint.getLabel());
         //pointsInBox.add(gpoint);
         colorArray[i] = cm.colorRamp[selectionValue];
       }    
   }
   plot.setPointColors(colorArray);
   return pointnames;
 }
 
 /**
 * Checks and removes if a Points is already in an Array
 *@Input PointArray and Point
 *@Output: Array without point 
 */
 
 public GPointsArray checkifPointInPointArray(GPointsArray pointArray, GPoint point){
   List<String> testlist = new ArrayList<String>();
   
   for(int j = 0; j < pointArray.getNPoints(); j++)
                {testlist.add(pointArray.getLabel(j));}
             
            if(testlist.contains(point.getLabel())){
                int Asshole = testlist.indexOf(point.getLabel());
                 pointArray.remove(Asshole);}
                 
            else{pointArray.add(point);}
   return pointArray;
  }
   
}