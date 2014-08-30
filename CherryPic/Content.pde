class Content{
  PImage image;
  String optionalText;
  Source source;
  
  Content(PImage img, String text, Source src){
    this.image = img;
    this.optionalText = text;
    this.source = src;
  }
  
  String getOptionalText() throws NullPointerException{
    return optionalText;
  }
  
  PImage getPicture(){
    return image;
  }
  
  Source getSource(){
    return source;
  }
}
