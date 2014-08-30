//This is the class that controls the picture on the screen. We use this for transitioning as well. 
class ScreenImage {
  PImage currImage;
  PImage nextImage;
  PImage tempImage; //The image we will make into the nextImage. Sort of like the 3rd in line, always temporary
  ImageTransition transition;
  boolean isChangingImage = false;
  int frameTransitionStarted = 0; //when we start a transition, we mark this.

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

    return ImageTransition.FADE;
  }

  //TODO make this do the proper transition
  void changeImage(PImage next) {
    tempImage = next;
    frameTransitionStarted = frameCount;
    transition = getRandomTranstion();
    isChangingImage = true;
  }

  //The PApplet arg gives us the ability to draw right to the screen. 
  void drawMe(PApplet main) {
    //Draw the image depending on whether we're in the process of changing it or not. 
    if (!isChangingImage) {
      tint(color(255), 255);
      main.imageMode(CENTER);
      main.image(currImage, width / 2, height / 2);
    } else {
      switch(transition) {
      case NONE: //TODO make transition
      case SWIPE://TODO make transition 
      case FADE:
        main.imageMode(CENTER);
        float percentComplete = (((float)frameCount - (float)frameTransitionStarted) / transitionTime);
        tint(255, percentComplete * 255);
        main.image(nextImage, width / 2, height / 2);
        tint(255, (1.0f - percentComplete) * 255);
        main.image(currImage, width / 2, height / 2);
        //If we're done changing the image, reset the vars. 
        if (frameCount == frameTransitionStarted + transitionTime -1) {
          debugPrint("Done changing images out", "ScreenImage.drawMe()");
          isChangingImage = false;
          currImage = nextImage;
          nextImage = tempImage;
          tempImage = null; //No being stupid!
          sizeImage(nextImage);
        }
        break;
      }
    }
  }
}

