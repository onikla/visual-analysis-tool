
/**
 * This is the main, where all the other classes come together to produce the Visualization. 
 * Furthermore Buttons and Interactions are implemented in this class
 * For the Buttons and controllers the library controlP5 is used
 * 
 * @author Olivier Niklaus
 * @version 12.11.2017
**/


//import library
import controlP5.*;
import java.lang.Object;


//create instances for further use
Data dataEntriesMap = new Data();
ControlP5 myController;
ButtonBar xb;
ButtonBar yb;
Button rb;
Button tm;
HashMap<String, Country> dataMap;
ChoroWorld choroMap;
ScatterPlot scatterplot;
HashMap<String, Country> selectedCountries = new HashMap<String, Country>();
List<String> layerPoints = new ArrayList<String>();
List<String> pointsname = new ArrayList<String>();
ArrayList<List<String>> pointsnameGroup = new ArrayList<List<String>>();


void setup() {
  size(2000, 1500, P2D);
  smooth();
   
  //loads the Data and creates a HashMap of Objects Countries
  dataMap = dataEntriesMap.loadFromCSV("data.csv");
  
  // Draw map tiles and country markers on map
  choroMap = new ChoroWorld(this);
  // Draw Scatterplot
  scatterplot = new ScatterPlot(dataMap, this);
  
  // Add buttons and set their Font
  myController = new ControlP5(this);
  PFont p = createFont("Verdana",12);
  ControlFont font = new ControlFont(p);
  myController.setFont(font);
  
  //Buttonbar to choose the X-Axis Variable - Each Value corresponds a Country Variable
  xb = myController.addButtonBar("XButtonbar")
       .setPosition(1000,200)
       .setSize(600,60)
       .setValue(1)
       .addItems(split("life-expectancy Beer Wine Spirits total-Alcohol"," "));     
  xb.changeItem("life-expectancy", "text", "        life \nexpectancy");
  
  // Adds a callBack, means it reacts after an element has been clicked 
  xb.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent event){
      if(event.getAction() == myController.ACTION_CLICK){
        int yb_value = (int) myController.getController("YButtonbar").getValue(); //Get y-axis information
        //After click send new information to scatterplot to adjust the axis and the points
        //If countries have been selected manually their x-coordinates need to be recalculated
        scatterplot.updateX((int) event.getController().getValue(), yb_value, selectedCountries);
      }
    }
  });
  
  //Buttonbar to choose the -Axis Variable - Each Value corresponds a Country Variable
  yb = myController.addButtonBar("YButtonbar")
       .setPosition(1000,320)
       .setSize(600,60)
       .setValue(2) 
       .addItems(split("life-expectancy Beer Wine Spirits total-Alcohol"," "));     
  yb.changeItem("life-expectancy", "text", "        life \nexpectancy");
  // Adds a callBack, means it reacts after an element has been clicked
  yb.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent event){
      if(event.getAction() == myController.ACTION_CLICK){
        int xb_value = (int) myController.getController("XButtonbar").getValue(); //Get x-axis information
        //After click send new information to scatterplot to adjust the axis and the points
        //If countries have been selected manually their x-coordinates need to be recalculated
        scatterplot.updateY((int) event.getController().getValue(), xb_value, selectedCountries);
      }
    }
  });
  
  //Button that colors Points in Scatterplot which are within the Scatter-Window
  tm = myController.addButton("Select \n Points")
                   .setPosition(1200,440) //<>//
                   .setSize(120,60)
                   .setValue(0);
   // Adds a callBack, means it reacts after an element has been clicked
    tm.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent event){
      if(event.getAction() == myController.ACTION_CLICK){
       
               if (tm.getValue() <= 11) {   //ColorRamp contains 12 different colors (ColorBrewer)               
                   int oldValue = (int) tm.getValue(); 
                   //Identify Points within the ScatterplotBox and store them in a list of String
                   pointsname = scatterplot.getPointsInBox((int)tm.getValue());
                   pointsnameGroup.add(pointsname);
                   choroMap.choroUpdate(pointsname, (int) tm.getValue());   //Update Map and color selected Countries
                   tm.setValue(oldValue+1);                                 //Overwrite ButtonValue
                   }
               
               else{tm.setValue(0); //Resets ButtonValue to 0, if end of ColorArray 
                   int oldValue = (int) tm.getValue(); 
                   pointsname = scatterplot.getPointsInBox((int)tm.getValue());
                   pointsnameGroup.add(pointsname);
                   choroMap.choroUpdate(pointsname, (int) tm.getValue());
                   tm.setValue(oldValue+1);                                 //Overwrite ButtonValue
                    }
       }
     }
    });  
    
    
  //Button that sets everything back to Default
  rb = myController.addButton("ResetButton")
                   .setPosition(1000,440)
                   .setSize(120,60)
                   .setLabel("SET \n DEFAULT");
  
  rb.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent event){
      if(event.getAction() == myController.ACTION_CLICK){
        choroMap = new ChoroWorld(Visualization.this);
        scatterplot.plot.removeLayer("chosenPoints");
        scatterplot.plot.removeLayer("highPoints");
        scatterplot.plot.removeLayer("layerID");
        scatterplot = new ScatterPlot(dataMap, Visualization.this);
        int rmax = scatterplot.chosenPoints.getNPoints();
        scatterplot.chosenPoints.removeRange(0,rmax);
        layerPoints.clear();
        selectedCountries.clear();
        pointsname.clear();
        pointsnameGroup.clear();
        xb.setValue(1);
        yb.setValue(2);
        tm.setValue(0);
        
      }
   }
   });
  
  
}

void draw() {
  background(240);

  choroMap.draw();
  
  scatterplot.draw();
  
  drawMapTooltip((int)myController.getController("XButtonbar").getValue(), (int)myController.getController("YButtonbar").getValue());

  
}

//This Brushing Method highlights corresponding Countries in Scatterplot if moved over Country in Map
// It takes the ButtonBar values as Input to know the Axis Variables
void drawMapTooltip(int valuex, int valuey){
  Marker oldMarker = null;
  if (mouseX < 1100 && mouseX > 100 && mouseY < 1200 && mouseY > 600) {
    
    //Get Marker under the current Mouse-Position
    Marker marker = choroMap.map.getFirstHitMarker(mouseX,mouseY);
    
    //If the new CountryMarker is detected, highlight corresponding Point in Scatterplot
    if(marker != oldMarker) {
        
        //If firs time, no need to remove Layer in Scatterplot with highlighted Point
        if  (scatterplot.highPoints.getNPoints() == 0) {
        
            oldMarker = marker;
            String cname = marker.getStringProperty("name"); //identify the Country
            Country country = dataMap.get(cname);            //get the Country with all informations
            
            //Create Point on new Scatterplot Layer
            //Points x and y Value correspond to the current state of the X- and Y-Axis
            scatterplot.highPoints.add(country.getCountryAttribute(valuex) ,country.getCountryAttribute(valuey));
            scatterplot.plot.addLayer("layerID", scatterplot.highPoints);
            scatterplot.plot.getLayer("layerID").setPointSize(25);
        }
        //Remove old Layer if there is already // Check uses PointsArray
        if  (scatterplot.highPoints.getNPoints() != 0) {
        
            scatterplot.plot.removeLayer("layerID");
            scatterplot.highPoints.remove(0);
            oldMarker = marker;
            String cname = marker.getStringProperty("name");
            Country country = dataMap.get(cname);
            
            scatterplot.highPoints.add(country.getCountryAttribute(valuex) ,country.getCountryAttribute(valuey));
            scatterplot.plot.addLayer("layerID", scatterplot.highPoints);
            scatterplot.plot.getLayer("layerID").setPointSize(25);
         }
           
    }
  }
}

//If mouseClicked on Point in Scatterplot, color corresponding CountryMarker on Map and the Point
void mouseClicked(){
  
  if (mouseX < 825 && mouseX > 25 && mouseY < 525 && mouseY > 25) {
   //Get the Axis Variables
   int valuex = (int) myController.getController("XButtonbar").getValue();
   int valuey = (int) myController.getController("YButtonbar").getValue(); 

      //If Point under Mouse color it, otherwise its Zooming and Panning
      if(scatterplot.plot.getPointAt(mouseX,mouseY) != null) { //<>//
          
          //Get the pointLabel that corresponds to the Country name
          String cname = scatterplot.plot.getPointAt(mouseX,mouseY).getLabel();
          System.out.println(cname);
          
          //Check if country has already been selected, else remove it
          if(layerPoints.contains(cname)){layerPoints.remove(cname);} //<>//
          else{layerPoints.add(cname);}
          if(selectedCountries.containsKey(cname)){ //<>//
                selectedCountries.remove(cname);}
          else{selectedCountries.put(cname, dataMap.get(cname));}
          
          if(pointsnameGroup.size() >= 12){
                pointsnameGroup.clear();
                selectedCountries.clear();
                layerPoints.clear();
                scatterplot.plot.removeLayer("chosenPoints");
                scatterplot.plot.removeLayer("highPoints");
                scatterplot.plot.removeLayer("layerID");
                scatterplot = new ScatterPlot(dataMap, Visualization.this);       
           }
           
          //Clear GPointsArray each time
          int rmax = scatterplot.chosenPoints.getNPoints(); //<>//
          scatterplot.chosenPoints.removeRange(0,rmax);
          //Refill GPointArray with all selected Points
          for(Country country : selectedCountries.values()){
               scatterplot.chosenPoints.add(country.getCountryAttribute(valuex) ,country.getCountryAttribute(valuey));
                System.out.println(country.getName());}

          //Remove old Layer and Create new one with new filled GPointsArray, and reUpdate Map   
          scatterplot.plot.removeLayer("chosenPoints");
          scatterplot.plot.addLayer("chosenPoints", scatterplot.chosenPoints);
          scatterplot.plot.getLayer("chosenPoints").setPointSize(20);
          scatterplot.plot.getLayer("chosenPoints").setPointColor(color(0,200,0));
          scatterplot.plot.getLayer("chosenPoints").setFontSize(22); //<>//
          
          //choroMap.colorCountry(layerPoints);
          //choroMap.choroUpdate(pointsnameGroup);

          choroMap.choroMasterUpdate(pointsnameGroup, layerPoints);
          
          }
        }    
   }
  
  

  