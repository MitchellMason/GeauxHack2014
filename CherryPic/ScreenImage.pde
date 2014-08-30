//This is the class that controls the picture on the screen. We use this for transitioning as well. 
class ScreenImage {
  PImage currImage;
  PImage nextImage;
  ImageTransition transition;
  boolean isChangingImage = false;

  ScreenImage(PImage currImage, PImage nextImage) {
    this.currImage = currImage;
    this.nextImage = nextImage;
    sizeImage(currImage);
    sizeImage(nextImage);
  }

  //Resizes the images in the queue to an appropriate size
  void sizeImage(PImage img) {
    float percentOff;

    //adjust for height
    if (img.height > picAreaHeight) {
      percentOff = (float)picAreaHeight / (float)img.height;
      println("Percent off is " + percentOff);
      img.resize((int)(img.width * percentOff), (int)(img.height * percentOff));
    }
    //adjust for width
    if (img.width > picAreaWidth) {
      percentOff = (float)picAreaWidth / (float)img.width;
      img.resize((int)(img.width * percentOff), (int)(img.height * percentOff));
    }
  }

  //utility method to get a new transition
  ImageTransition getRandomTranstion() {
    int totalImageTransisitons = ImageTransition.values().length;

    return ImageTransition.NONE;
  }

  //TODO make this do the proper transition
  void changeImage(PImage next) {
    transition = getRandomTranstion();
    switch(transition) {
    case NONE: 
      break;
    case SWIPE: 
      break;
    case FADE: 
      break;
    }
  }

  //The PApplet arg gives us the ability to draw right to the screen. 
  void drawMe(PApplet main) {
    if (!isChangingImage) {
      main.imageMode(CENTER);
      main.image(currImage, width / 2, height / 2);
    } else {
      switch(transition) {
      case NONE: 
        break;
      case SWIPE: 
        break;
      case FADE: 
        break;
      }
    }
  }
}

