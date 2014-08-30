/**********Logic vars**********/
final boolean ISDEBUG = true; //TODO set to false for presentation. 
//Screen dimensions
final int screenWidth  = 1280;
final int screenHeight = 720;
//Dimensions of the area pictures can be drawn.
final int picAreaHeight= 600;
final int picAreaWidth = 1000;
//Time until the frame changes
int framesUntilNextPicture = 60 * 3;
//Content Providers
ProviderDelegate delegate;
HardDriveProvider hdPro;
TumblrProvider tmblrPro;

/**********Net vars**********/


/**********Graphics vars**********/
//Maybe make a color scheme? 
ScreenImage currentImage;
ArrayList<Content> contentQueue;
//index of the current image from the contentqueue
int contentQueueIndex;

void setup() {
  //Init graphics
  size(screenWidth, screenHeight);
  contentQueue = new ArrayList<Content>();

  //Init providers
  delegate = new ProviderDelegate(this);
  hdPro = new HardDriveProvider(delegate);
  hdPro.start();
  
  tmblrPro = new TumblrProvider(delegate);
  tmblrPro.start();

  //Get first few pictures and get them into the screen
  for (int i=0; i<5; i++) {
    contentQueue.add(hdPro.forceNextPicture());
  };
  currentImage = new ScreenImage(contentQueue.get(0).image, contentQueue.get(1).image);
  contentQueueIndex = 2;
  
  tmblrPro.loadPics();
}

void draw() {
  background(0);
  currentImage.drawMe(this);

  //See if we need to change the picture yet.
  if (frameCount % framesUntilNextPicture == framesUntilNextPicture -1) {
    debugPrint("Time up! Switching image.", "main.draw()");
    proceedToNextImage();
  }

  //if there's a comment, draw it
  if (contentQueue.get(contentQueueIndex).optionalText != null) {
    drawCommentBox();
  }

  //Draw the title bar and logo
  drawUI();
}

//Draw the comment box
void drawCommentBox() {
}

//Draw the bar at the top with the logos. 
void drawUI() {
}

//Adds an image to the queue, and tosses it up front if it's urgent enough.
void addImageToQueue(Content nextContent, boolean isUrgent) {
}

//Switches to the next image in the queue
void proceedToNextImage() {
  Content temp;
  if (contentQueueIndex+1 >= contentQueue.size()) {
    contentQueueIndex = 0;
  }
  else{
    contentQueueIndex++;
  }
  temp = contentQueue.get(contentQueueIndex);
  debugPrint("New content queue index is " + contentQueueIndex, "proceedToNextImage()");

  currentImage.changeImage(temp.image);
}

//Called when the app exits. Use this to quit all threads, close all network jobs, etc.
void exit() {
}

void mouseClicked() {
  if (ISDEBUG) {
    debugPrint("Key pressed. Moving image.", "mouseClicked()");
    proceedToNextImage();
  }
}

//Utility debug printer.
void debugPrint(String message, String sender) {
  if (ISDEBUG) {
    println(sender + "--->" + message);
  }
}

