//Has a delegate, but shouldn't use it. Pictures are beaten out only. 
class HardDriveProvider extends ContentProvider {
  String pathToPics = "/images";
  PImage loadedPics[];
  int index =0;
  HardDriveProvider(ProviderDelegate delegate) {
    super(delegate);
  }

  //Called at the start of the thread.
  void init() {
    loadedPics = loadPics();
    debugPrint("Loaded pictures from HD.", "HDProvider");
  }

  Content forceNextPicture() {
    if(index == loadedPics.length - 1){
      index = 0;
    }
    else{
      index++;
    }
    return new Content(loadedPics[index],"",Source.HARDDRIVE);
  }

  PImage[] loadPics() {
    File picsFolder = new File(sketchPath("") + pathToPics);
    File[] pictureFiles = picsFolder.listFiles(); //similar to the "ls" command

    //we can't use just an array becuase not all files in this directory are pictures (and for safety)
    ArrayList<PImage> tempListOfPics = new ArrayList<PImage>();

    for (int i=0; i<pictureFiles.length; i++) {
      if (pictureFiles[i].toString().contains(".jpg") || pictureFiles[i].toString().contains(".png")) {
        tempListOfPics.add(loadImage(pictureFiles[i].toString()));
      }
    }
    //Convert from arraylist to fixed array
    PImage[] retList = new PImage[tempListOfPics.size()];
    for (int i=0; i<tempListOfPics.size (); i++) {
      retList[i] = tempListOfPics.get(i);
    }

    return retList;
  }
}

