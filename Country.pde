
/**
 * This Class represents a country's attributes
 * 
 * @author Olivier Niklaus
 * @version 12.11.2017
**/

class Country{
  
  // initialise variables

  public String cname;
  public int wine, beer, spirits; 
  public Float lifeyears, totalc;
  
 /**
   * Constructor for Objects Country
   */
  public Country(String cname, int wine, int beer, int spirits, Float totalc, Float lifeyears){
               
          this.cname = cname;
          this.wine = wine;
          this.beer = beer;
          this.spirits = spirits;
          this.totalc = totalc;
          this.lifeyears = lifeyears;
  }
 /**
   * empty Constructor
   */
   
  public Country(){ }
   /**
   * Constructor with input other Country
   */
  public Country(Country c){
         this.cname = c.getName();
         this.wine = c.getWine();
         this.beer = c.getBeer();
         this.spirits = c.getSpirits();
         this.totalc = c.getTotalc();
         this.lifeyears = c.getLifeyears(); 
  }
   /**
     * Getter and setter methods
     */
    
    public String getName(){
      return this.cname;  }
    
    public int getWine(){
      return this.wine;  }
    
    public int getBeer(){
      return this.beer; }
    
    public int getSpirits(){
      return this.spirits; }
     
    public Float getTotalc(){
      return this.totalc; }
      
    public Float getLifeyears(){
      return this.lifeyears; }
    
    /**
      *Getter Methods to access Attribute by number
      *Input is a float number 
      *Attention of Casts form integer rto float!!
      */
    public Float getCountryAttribute(int i){
      float attribute;
      if (i == 0.0) {attribute = this.lifeyears;
        return attribute;}
      if (i == 1.0) {attribute = (float) this.beer;
        return attribute;}      
      if (i == 2.0) {attribute = (float) this.wine;
        return attribute;}       
      if (i == 3.0) {attribute = (float) this.spirits;
        return attribute;}           
      else {attribute = this.totalc;}           
        return attribute;
     }
    

    public void setName(String cname){
      this.cname = cname;  }
    
    public void setWine(int wine){
      this.wine = wine;  }
    
    public void setBeer(int beer){
      this.beer = beer; }
    
    public void setSpirits( int spirits){
      this.spirits = spirits; }
     
    public void setTotalc(Float totalc){
      this.totalc = totalc; }
      
    public void setLifeyears(Float lifeyears){
      this.lifeyears = lifeyears; }     
}