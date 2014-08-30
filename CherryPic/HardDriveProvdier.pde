class HardDriveProvider extends ContentProvider{
  
  String pathToPics = "/images";
  PImage loadedPics[];
  
  HardDriveProvider(ProviderDelegate delegate){
    super(delegate);
  }
  
  //Called at the start of the thread.
  void start(){
    loadedPics = loadPics();
  }
  
  PImage forceNextPicture(){
    return loadedPics[(int)random(0,loadedPics.length)];
  }
  
  PImage[] loadPics(){
    File picsFolder = new File(sketchPath("") + pathToPics);
    File[] pictureFiles = picsFolder.listFiles(); //similar to the "ls" command
    
    //we can't use just an array becuase not all files in this directory are pictures (and for safety)
    ArrayList<PImage> tempListOfPics = new ArrayList<PImage>();
    
    for(int i=0; i<pictureFiles.length; i++){
      if(pictureFiles[i].toString().contains(".jpg")){
        tempListOfPics.add(loadImage(pictureFiles[i].toString()));
      }
    }
    
    PImage[] retList = new PImage[tempListOfPics.size()];
    return retList; 
  }
}
