import java.util.Date;

/**********Logic vars**********/
final boolean ISDEBUG = true; //TODO set to false for presentation. 
//Screen dimensions
final int screenWidth  = 1280;
final int screenHeight = 720;
//Dimensions of the area pictures can be drawn.
final int picAreaHeight= screenHeight - 150;
final int picAreaWidth = 1000;
final int iconHeight   = (screenHeight - picAreaHeight) / 2;
//Switch the picture on this frame#
int picSwitchFrame = 60 * 4;
final int frameSwitchDelay = 60 * 4;
//Content Providers
ProviderDelegate delegate;
HardDriveProvider hdPro;
TumblrProvider tmblrPro;
Date date = new Date();

/**********Graphics vars**********/
//Maybe make a color scheme? 
ScreenImage currentImage;
ArrayList<Content> contentQueue;
final int transitionTime = 60; //Time until a transition finishes. 
//index of the current image from the contentqueue
int contentQueueIndex;
//color palette
final color baseColor         = color(175);
final color brightAccentColor = color(57,234,58);
final color darkAccentColor   = color(9, 148, 178);
PImage logo;
PImage[] socialMediaLogos = new PImage[4];

void setup() {
  //Init graphics
  size(screenWidth, screenHeight);
  contentQueue = new ArrayList<Content>();

  //Init providers
  delegate = new ProviderDelegate(this);
  hdPro = new HardDriveProvider(delegate);

  tmblrPro = new TumblrProvider(delegate);
  tmblrPro.start();

  //heavy loading:
  hdPro.init();
  logo = loadImage("Logos/CherryPicLogo.png");
  socialMediaLogos[0] = loadImage("Logos/Facebook.png");
  socialMediaLogos[1] = loadImage("Logos/Tumblr.png");
  socialMediaLogos[2] = loadImage("Logos/Twitter.png");
  socialMediaLogos[3] = loadImage("Logos/Reddit.png");

  logo.resize((int)(iconHeight / (1/1.438)), iconHeight);
  for (int i=0; i<socialMediaLogos.length; i++) {
    socialMediaLogos[i].resize(iconHeight, iconHeight);
  }

  //Get first few pictures and get them into the screen
  for (int i=0; i<5; i++) {
    contentQueue.add(hdPro.forceNextPicture());
  };
  currentImage = new ScreenImage(contentQueue.get(0).image, contentQueue.get(1).image);
  contentQueueIndex = 2;
}

void draw() {
  background(baseColor);
  currentImage.drawMe(this);

  //See if we need to change the picture yet.
  //TODO make is so every change, the wait time is reset.
  if (frameCount == picSwitchFrame) {
    debugPrint("Time up! Switching image.", "main.draw()");
    proceedToNextImage();
    picSwitchFrame = frameCount + frameSwitchDelay;
  }

  //if there's a comment, draw it
  if (contentQueue.get(contentQueueIndex).optionalText != null) {
    drawCommentBox(contentQueue.get(contentQueueIndex).optionalText);
  }

  //Draw the title bar and logo
  drawUI();
}



//Draw the comment box
void drawCommentBox(String text) {
}

//Draw the bar at the top with the logos. 
void drawUI() {
  //draw the UI top bar
  noStroke();
  fill(brightAccentColor);
  rect(0, 0, width, iconHeight);
  fill(darkAccentColor);
  rect(0, 0, logo.width +1, iconHeight);
  
  //Line for thickness at the top
  stroke(255);
  line(0,iconHeight,width,iconHeight);

  //Draw the logo
  imageMode(CORNERS);
  tint(255, 255);
  image(logo, 2, 0);

  //Draw the image channel
  Source contentSource = contentQueue.get(0).getSource();
  switch(contentSource) {
  case HARDDRIVE:
    fill(0);
    textSize(iconHeight *2);
    text("HD",0,height - iconHeight - 10);
    break;
  default: 
    break;
  }
  
  //temporarily tell the user they're looking at the image source
  if(frameCount < 6 * 60){
    textSize(15);
    fill(255);
    text("← Media channel. Swipe to change.",iconHeight * 2,300);
  }
  
  //print the system time
  textSize(15);
  fill(0);
  text(date.toString().substring(0,19), width - textWidth(date.toString().substring(0,19)) - 10, iconHeight - 3);
}

//Adds an image to the queue, and tosses it up front if it's urgent enough.
void addImageToQueue(Content newContent, boolean isUrgent) {
  if (isUrgent) {
    debugPrint("New urgent Image added to queue", "addImageToQueue");
    Content toSwitch = contentQueue.get(contentQueueIndex + 1);
    contentQueue.set(contentQueueIndex+1, newContent);
    contentQueue.add(toSwitch);
    proceedToNextImage();
  } else {
    debugPrint("New non-urgent Image added to queue", "addImageToQueue");
    contentQueue.add(newContent);
  }
}

//Switches to the next image in the queue
void proceedToNextImage() {
  Content temp;
  if (contentQueueIndex+1 >= contentQueue.size()) {
    contentQueueIndex = 0;
  } else {
    contentQueueIndex++;
  }
  temp = contentQueue.get(contentQueueIndex);
  debugPrint("New content queue index is " + contentQueueIndex, "proceedToNextImage()");

  currentImage.changeImage(temp.image);
  picSwitchFrame = frameCount + frameSwitchDelay;
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

