import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Date; 
import java.util.HashMap; 
import java.util.List; 
import com.restfb.*; 
import de.voidplus.leapmotion.*; 
import development.*; 
import com.github.jreddit.*; 
import java.util.HashMap; 
import java.util.List; 
import com.google.gson.JsonObject; 
import com.google.gson.JsonParser; 
import com.tumblr.jumblr.JumblrClient; 
import com.tumblr.jumblr.types.Blog; 
import com.tumblr.jumblr.types.Photo; 
import com.tumblr.jumblr.types.PhotoPost; 
import com.tumblr.jumblr.types.Post; 
import java.util.HashMap; 
import java.util.List; 

import org.apache.commons.lang3.text.translate.*; 
import org.apache.commons.lang3.time.*; 
import com.restfb.exception.*; 
import org.apache.commons.codec.language.*; 
import com.restfb.*; 
import com.github.jreddit.*; 
import com.github.jreddit.utils.*; 
import com.leapmotion.leap.*; 
import com.tumblr.jumblr.exceptions.*; 
import org.scribe.oauth.*; 
import com.google.gson.annotations.*; 
import org.scribe.utils.*; 
import com.restfb.util.*; 
import org.scribe.builder.api.*; 
import org.apache.commons.lang3.mutable.*; 
import org.scribe.builder.*; 
import org.scribe.model.*; 
import org.apache.commons.codec.*; 
import org.apache.commons.codec.digest.*; 
import com.tumblr.jumblr.request.*; 
import org.apache.commons.lang3.concurrent.*; 
import com.google.gson.internal.*; 
import org.apache.commons.lang3.event.*; 
import org.scribe.services.*; 
import org.apache.commons.lang3.tuple.*; 
import de.voidplus.leapmotion.*; 
import com.google.gson.stream.*; 
import org.scribe.exceptions.*; 
import com.tumblr.jumblr.types.*; 
import com.restfb.types.*; 
import com.google.gson.internal.bind.*; 
import com.github.jreddit.captcha.*; 
import com.tumblr.jumblr.*; 
import development.*; 
import com.github.jreddit.user.*; 
import org.apache.commons.lang3.builder.*; 
import org.apache.commons.codec.net.*; 
import org.apache.commons.lang3.text.*; 
import org.apache.commons.lang3.math.*; 
import com.google.gson.*; 
import org.apache.commons.lang3.*; 
import com.github.jreddit.submissions.*; 
import com.tumblr.jumblr.responses.*; 
import org.apache.commons.lang3.reflect.*; 
import com.google.gson.reflect.*; 
import com.restfb.json.*; 
import com.github.jreddit.subreddit.*; 
import org.apache.commons.codec.binary.*; 
import com.restfb.batch.*; 
import org.scribe.extractors.*; 
import org.apache.commons.lang3.exception.*; 
import com.github.jreddit.message.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class CherryPic extends PApplet {



/**********Logic vars**********/
final boolean ISDEBUG = false; //TODO set to false for presentation. 
//Screen dimensions
final int screenWidth  = 1920;
final int screenHeight = 1080;
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
FacebookProvider facebkPro;
LeapDelegate leap = new LeapDelegate(this);
Date date = new Date();
Source currentContentSource = Source.FACEBOOK; //ToStart

/**********Graphics vars**********/
//Maybe make a color scheme? 
ScreenImage currentImage;
PFont font;
ArrayList<Content> allContent;
ArrayList<Content> channelContent;
final int transitionTime = 60; //Time until a transition finishes. 
//index of the current image from the contentqueue
int contentQueueIndex;
//color palette
final int baseColor         = color(225);
final int brightAccentColor = color(57, 234, 58);
final int darkAccentColor   = color(9, 148, 178);
PImage logo;
PImage logoBig;
PImage[] socialMediaLogos = new PImage[5];

public void setup() {
  //Init graphics
  size(screenWidth, screenHeight);
  allContent = new ArrayList<Content>();
  channelContent = new ArrayList<Content>();

  //Init providers
  delegate = new ProviderDelegate(this);
  hdPro = new HardDriveProvider(delegate);

  tmblrPro = new TumblrProvider(delegate);
  tmblrPro.start();

  facebkPro = new FacebookProvider(delegate);
  facebkPro.start();

  //heavy loading:
  hdPro.init();
  logo    = loadImage("Logos/CherryPicLogo.png"); //TODO clone the Big one. THIS IS TERRIBLE
  logoBig = loadImage("Logos/CherryPicLogo.png");
  socialMediaLogos[0] = loadImage("Logos/Facebook.png");
  socialMediaLogos[1] = loadImage("Logos/Tumblr.png");
  socialMediaLogos[2] = loadImage("Logos/Twitter.png");
  socialMediaLogos[3] = loadImage("Logos/Reddit.png");
  socialMediaLogos[4] = loadImage("Logos/HD.png");
  font = loadFont("data/HelveticaNeue-48.vlw");

  logo.resize((int)(iconHeight / (1/1.438f)), iconHeight);
  for (int i=0; i<socialMediaLogos.length; i++) {
    socialMediaLogos[i].resize(iconHeight, iconHeight);
  }

  //Get first few pictures and get them into the screen
  for (int i=0; i<5; i++) {
    addImageToQueue(hdPro.forceNextPicture(), false);
  };
  contentQueueIndex = 0;
  currentImage = new ScreenImage(logoBig, logoBig);
  changeChannel();
}

public void draw() {
  background(baseColor);

  currentImage.drawMe(this);

  //See if we need to change the picture yet.
  //TODO make is so every change, the wait time is reset.
  if (frameCount == picSwitchFrame) {
    debugPrint("Time up! Switching image.", "main.draw()");
    proceedToNextImage(false);
    picSwitchFrame = frameCount + frameSwitchDelay;
  }

  //if there's a comment, draw it
  if (allContent.get(contentQueueIndex).optionalText != null) {
    drawCommentBox(allContent.get(contentQueueIndex).optionalText);
  }

  //Draw the title bar and logo
  drawUI();
}



//Draw the comment box
public void drawCommentBox(String text) {
}

//Draw the bar at the top with the logos. 
public void drawUI() {
  //draw the UI top bar
  noStroke();
  fill(brightAccentColor);
  rect(0, 0, width, iconHeight);
  fill(darkAccentColor);
  rect(0, 0, logo.width +1, iconHeight);

  //Line for thickness at the top
  stroke(255);
  line(0, iconHeight, width, iconHeight);

  //Draw the logo
  imageMode(CORNERS);
  tint(255, 255);
  image(logo, 2, 0);

  //Draw the image channel
  switch(currentContentSource) {
  case HARDDRIVE:
    image(socialMediaLogos[4], 0, height - iconHeight);
    break;
  case TUMBLR:
    image(socialMediaLogos[1], 0, height - iconHeight);
    break;
  case FACEBOOK:
    image(socialMediaLogos[0], 0, height - iconHeight);
  default: 
    break;
  }

  //temporarily tell the user they're looking at the image source
  if (frameCount < 6 * 60) {
    textSize(30);
    fill(darkAccentColor);
    text("\u2190 Media channel Swipe to change", iconHeight * 1.25f, height - 20);
  }

  //print the system time
  textSize(15);
  fill(0);
  date = new Date();
  text(date.toString().substring(0, 19), width - textWidth(date.toString().substring(0, 19)) - 10, iconHeight - 3);
}

//Adds an image to the queue, and tosses it up front if it's urgent enough.
public void addImageToQueue(Content newContent, boolean isUrgent) {
  if (newContent == null || newContent.getPicture() == null) {
    debugPrint("Got something null. Throwing away.", "addToImageQueue");
    return;
  }
  switch(newContent.getSource()) {
  case HARDDRIVE:
    if (isUrgent) {
      debugPrint("New urgent Image added to queue", "HD");
    } else {
      debugPrint("New non-urgent Image added to queue", "HD");
    }
    break;
  case TUMBLR:
    if (isUrgent) {
      debugPrint("New urgent Image added to queue", "Tumblr");
    } else {
      debugPrint("New non-urgent Image added to queue", "Tumblr");
    }
    break;
  case FACEBOOK:
    if (isUrgent) {
      debugPrint("New urgent Image added to queue", "FB");
    } else {
      debugPrint("New non-urgent Image added to queue", "FB");
    }
  default: 
    break;
  }
  if (isUrgent) {
    Content toSwitch = allContent.get(contentQueueIndex + 1);
    allContent.set(contentQueueIndex+1, newContent);
    allContent.add(toSwitch);
    proceedToNextImage(false);
  } else {
    allContent.add(newContent);
  }
}

//Switches to the next image in the queue
public void proceedToNextImage(boolean isUrgent) {
  if (!isUrgent) {
    Content temp;
    if (contentQueueIndex+1 >= channelContent.size()) {
      contentQueueIndex = 0;
    } else if (channelContent.size() ==0) {
      debugPrint("ChannelContent size is zero! This is really bad.", "proceedToNextImage");
    } else {
      contentQueueIndex++;
    }
    temp = channelContent.get(contentQueueIndex);
    currentImage.changeImage(temp.image);
  } else {
    contentQueueIndex = 0;
    currentImage.immediateChangeImage(channelContent.get(0).getPicture(), channelContent.get(1).getPicture()); //TODO fix atrocity
  }
  picSwitchFrame = frameCount + frameSwitchDelay;
  debugPrint("New content queue index is " + contentQueueIndex + " with content source " + channelContent.get(contentQueueIndex).getSource(), "proceedToNextImage()");
}

public void changeChannel() {
  debugPrint("Changing channel", "changeChannel");
  switch(currentContentSource) {
  case HARDDRIVE:
    currentContentSource = Source.TUMBLR;
    debugPrint("New channel is Tumblr", "changeChannel");
    break;
  case TUMBLR:
    currentContentSource = Source.FACEBOOK;
    debugPrint("New channel is FB", "changeChannel");
    break;
  case FACEBOOK:
    currentContentSource = Source.HARDDRIVE;
    debugPrint("New channel is HD", "changeChannel");
    break;
  }
  channelContent.clear();
  for (Content pic : allContent) {
    if (pic.getSource() == currentContentSource) {
      channelContent.add(pic);
    }
  }
  contentQueueIndex = 0;
  proceedToNextImage(true);
}

public void changeChannel(Source target) {
  debugPrint("Changing channel by force", "changeChannel");
  channelContent.clear();
  for (Content pic : allContent) {
    if (pic.getSource() == currentContentSource) {
      channelContent.add(pic);
    }
  }
  proceedToNextImage(true);
}

public void mouseClicked() {
  if (ISDEBUG) {
    debugPrint("Mouse clicked. Moving image.", "mouseClicked()");
    proceedToNextImage(false);
  }
}

public void keyPressed() {
  if (ISDEBUG) {
    if (key == 'c') {
      changeChannel();
    }
  }
}

//Utility debug printer.
public void debugPrint(String message, String sender) {
  if (ISDEBUG) {
    println(sender + "--->" + message);
  }
}

public void leapOnKeyTapGesture(de.voidplus.leapmotion.KeyTapGesture g) {
  int     id                  = g.getId();
  de.voidplus.leapmotion.Finger  finger              = g.getFinger();
  PVector position            = g.getPosition();
  PVector direction           = g.getDirection();
  long    duration            = g.getDuration();
  float   duration_seconds    = g.getDurationInSeconds();

  changeChannel();
  println("KeyTapGesture: "+id);
}

public void leapOnScreenTapGesture(de.voidplus.leapmotion.ScreenTapGesture g) {
  changeChannel();
  println("ScreenTapGesture");
}

public void leapOnSwipeGesture(de.voidplus.leapmotion.SwipeGesture g, int state) {
  switch(state) {
  case 1: // Start
    proceedToNextImage(false);
    break;
  case 2: // Update
    break;
  case 3: // Stop
    println("SwipeGesture");
    break;
  }
}

public void leapOnCircleGesture(de.voidplus.leapmotion.CircleGesture g, int state) {
  switch(state) {
  case 1: // Start
    changeChannel();
    break;
  case 2: // Update
    break;
  case 3: // Stop
    println("CircleGesture");
    break;
  }
}

class Content{
  PImage image;
  String optionalText;
  Source source;
  
  Content(PImage img, String text, Source src){
    this.image = img;
    this.optionalText = text;
    this.source = src;
  }
  
  public String getOptionalText() throws NullPointerException{
    return optionalText;
  }
  
  public PImage getPicture(){
    return image;
  }
  
  public Source getSource(){
    return source;
  }
}
//CAACEdEose0cBAFYVInCp7ZAgAAO2EmrGRId6OobhQFOer40aDZAfm0Q0M41PLgne3AAMC7rENi2t2LSyBVhDbnfKwPTu24wkkfZAOuNDQEBqQ0uCZByPeSXer3uo7dbiYxU2Vj0pbSDZAIL4rr0UCa2N2ZCZCdMmcUKlDV7LVQGdwZBIeCw0cNYEWZAg0xKfaDCcMPmekuToQ0mhT7aFfZCB2a

//import com.google.gson.JsonObject;
//import com.google.gson.JsonParser;


//import com.restfb.BinaryAttachment;
//import com.restfb.DefaultFacebookClient;
//import com.restfb.FacebookClient;
//import com.restfb.Parameter;


class FacebookProvider extends ContentProvider {

  PImage loadedPics[];
  HashMap usedPics = new HashMap();
  FacebookClient facebookClient;

  FacebookProvider(ProviderDelegate delegate) {
    super(delegate);
    facebookClient = new DefaultFacebookClient("CAACEdEose0cBAOmZCZAq6WmoTcXzXhMkNsRBt4gqzuwZCLmaYcS1XiSQt1mk7yQGY91v4hSrC1zuIAZB9GA6HlarZCUCCRrjwI18L0gmp3Q5QQFiOjXp4GWFwgiGO9ph3aZClCSZClLXr1R2nzXZCR8e59ZACZBtEVvZBF9ZC4Jd8d8ZAuwQ0ZBvbIlPGYZCF2Ji2OcHapeJ7ZBbHIx3l8g1w5NvXa2w");  
  }

  //Called at the start of the thread.
  public void run() {
   
    checkForNewImages();
 
    Connection<com.restfb.types.Photo> myFeed = facebookClient.fetchConnection("me/home", com.restfb.types.Photo.class, com.restfb.Parameter.with("width","600"), com.restfb.Parameter.with("height","600"));
    //req.setAttribute("photosList",photosList);
    
    /*
    ArrayList<String> ids = new ArrayList<String>();    
    for (List<com.restfb.types.Post> postList : myFeed)
    {
      for(com.restfb.types.Post post : postList)
      {
          String temp = post.getObjectId();
          if(temp != null)
            ids.add(temp);
      } 
    }
    
    debugPrint("First ID is " + ids.get(0),"FBProvider");
    
    ArrayList<com.restfb.types.Photo> myPhotos = new ArrayList<com.restfb.types.Photo>();
    for(String id : ids){
      com.restfb.types.Photo temp = facebookClient.fetchObject(id, com.restfb.types.Photo.class);
    }
    debugPrint("First photo is " + myPhotos.get(0),"FBProvider");
    */
    
    for (List<com.restfb.types.Photo> photoList : myFeed)
    {
      for(com.restfb.types.Photo photo : photoList)
      {
        //println("Post: " + photo.getPicture());
        String url = photo.getPicture();
        
        //String url = null;
        if(url != null)
        {
          //println("pushing!");
          debugPrint("Photo added from FB with URL " + url, "FBPro");
          delegate.pushContent(new Content(loadImage(url), "", Source.FACEBOOK));
        }
      }
    }
    
    
    //Connection<com.restfb.types.Post> myFeed = facebookClient.fetchConnection("me/home", )
    
    while (true)
    {
      try { 
        this.sleep(10000);
      }
      catch (InterruptedException ie) {
      }
    }
  }

  //Force one photo to pull into the queue
  public Content forceNextPicture() {

/*
    String url = pic.getSizes().get(0).getUrl();

    if (!usedPics.containsKey(url))
    {
      println("loaded pic at " + url);
      usedPics.put(url, null);
      return new Content(loadImage(url), "", Source.TUMBLR);
    }
*/

    return null;
  }

  public void checkForNewImages()
  { 
    /*
    List<Post> posts;

    String url = pic.getSizes().get(0).getUrl();


    if (!usedPics.containsKey(url))
    {
      //println("loaded pic at " + url);
      usedPics.put(url, null);
      delegate.pushContent(new Content(loadImage(url), "", Source.TUMBLR));
    }
    else
    {
      return;
    }
    */
  }

  public void loadPicsToQueue() {
/*
    PImage[] images = loadPics(); 

    for (PImage image : images)
    {
      delegate.pushContent(new Content(image, null, Source.TUMBLR));
    }
  */}

  public PImage[] loadPics() {
return null;
/*
    ArrayList<PImage> tempListOfPics = new ArrayList<PImage>();

    //User user = client.user();

    List<Post> posts = client.userDashboard();

    for (Post post : posts)
    {
      if (post instanceof PhotoPost)
      {
        List<Photo> photos = ((PhotoPost) post).getPhotos();

        for (Photo pic : photos)
        {
          String url = pic.getSizes().get(0).getUrl();
          if (!usedPics.containsKey(url))
          {
            tempListOfPics.add(loadImage(url));
            usedPics.put(url, null);
            println("loaded pic at " + url);
          }
        }
      }
    }


    PImage[] retList = new PImage[tempListOfPics.size()];
    for (int i=0; i<tempListOfPics.size(); i++) {
      retList[i] = tempListOfPics.get(i);
    }

    print("Loaded pictures from HD: ");
    println(retList);
    return retList;
    */
  }
}

//Has a delegate, but shouldn't use it. Pictures are beaten out only. 
class HardDriveProvider extends ContentProvider {

  String pathToPics = "/images";
  PImage loadedPics[];

  HardDriveProvider(ProviderDelegate delegate) {
    super(delegate);
  }

  //Called at the start of the thread.
  public void init() {
    loadedPics = loadPics();
    debugPrint("Loaded pictures from HD.", "HDProvider");
  }

  public Content forceNextPicture() {
    return new Content(loadedPics[(int)random(0, loadedPics.length)], "This is a test, courtesy of your hard drive.", Source.HARDDRIVE);
  }

  public PImage[] loadPics() {
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




class LeapDelegate{
  CherryPic main;
  LeapMotion leap;
  LeapDelegate(CherryPic main){
    this.main = main;
    leap = new LeapMotion(main).withGestures();
  }
  
  public void swipe(){
    main.proceedToNextImage(true);
  }
  public void buttonPush(){
    main.changeChannel();
  }
}
class ProviderDelegate{
  CherryPic main;
  ProviderDelegate(CherryPic main){
    this.main = main;
  }
  
  //Pushes content casually
  public void pushContent(Content next){
    main.addImageToQueue(next, false);
  }
  
  //Forces content to the screen RIGHT NOW
  public void shoveContent(Content betterBeGood){
    main.addImageToQueue(betterBeGood, true);
  }
}





class RedditProvider extends ContentProvider {
  String username;
  String password;
  com.github.jreddit.user.User client;
  
  RedditProvider(ProviderDelegate delegate) {
    super(delegate);
  }
  
  public void run() {
  }
  
  public Content forceNextPicture() {
    return null;
  }
}

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
  public void sizeImage(PImage img) {
    if(img == null){
      debugPrint("Null image fed into sizeImage", "sizeImage");
      return;
    }
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
  public ImageTransition getRandomTranstion() {
    int totalImageTransisitons = ImageTransition.values().length;

    return ImageTransition.FADE;
  }

  //TODO make this do the proper transition
  public void changeImage(PImage next) {
    tempImage = next;
    frameTransitionStarted = frameCount;
    transition = getRandomTranstion();
    isChangingImage = true;
  }
  
  public void immediateChangeImage(PImage next, PImage afterThat){
    nextImage = next;
    tempImage = afterThat;
    frameTransitionStarted = frameCount;
    transition = getRandomTranstion();
    isChangingImage = true;
  }

  //The PApplet arg gives us the ability to draw right to the screen. 
  public void drawMe(PApplet main) {
    //Draw the image depending on whether we're in the process of changing it or not. 
    if (!isChangingImage) {
      tint(color(255), 255);
      main.imageMode(CORNERS);
      main.image(currImage, (width / 2) - (currImage.width / 2), max((height/2) - (currImage.height/2) - iconHeight,iconHeight + 20));
    } else {
      switch(transition) {
      case NONE: //TODO make transition
      case SWIPE://TODO make transition 
      case FADE:
        main.imageMode(CORNERS);
        float percentComplete = (((float)frameCount - (float)frameTransitionStarted) / transitionTime);
        tint(255, percentComplete * 255);
        main.image(nextImage,(width / 2) - (nextImage.width / 2), max((height/2) - (nextImage.height/2) - iconHeight,iconHeight + 20));
        tint(255, (1.0f - percentComplete) * 255);
        main.image(currImage, (width / 2) - (currImage.width / 2), max((height/2) - (currImage.height/2) - iconHeight,iconHeight + 20));
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











//Uses the Jumblr Client library
class TumblrProvider extends ContentProvider {

  PImage loadedPics[];
  JumblrClient client;
  HashMap usedPics = new HashMap();

  TumblrProvider(ProviderDelegate delegate) {    
    super (delegate);
    client = new JumblrClient(
    "IMsypM9lJL3Xhkxn3mNGWbQrm8Pfzb4kE3Z7BDQtQ24T5alp2j", 
    "WEnNITaXYPBdUcPrV1wRAARn9DY3cthtqRfPs6my1SIm3kw6AJ"
      );
    client.setToken(
    "cSuwaPdeLMt3ewCGyamQ5rV6dkw75ZSvwfuZSqtgwtwr9FhpYF", 
    "I1RjJ447nYlMFDDysn23NWIHC1sYsf8Sz887PftJQJ5GyWeHWE"
      );
  }

  //Called at the start of the thread.
  public void run() {
    checkForNewImages();

    while (true)
    {
      try { 
        this.sleep(10000);
      }
      catch (InterruptedException ie) {
      }
    }
  }

  //Force one photo to pull into the queue
  public Content forceNextPicture() {
    debugPrint("Ow!", "TumblrPro");
    List<Post> posts = client.userDashboard();

    for (Post post : posts)
    {
      if (post instanceof PhotoPost)
      {
        List<Photo> photos = ((PhotoPost) post).getPhotos();

        for (Photo pic : photos)
        {
          String url = pic.getSizes().get(0).getUrl();

          if (!usedPics.containsKey(url))
          {
            println("loaded pic at " + url);
            usedPics.put(url, null);
            return new Content(loadImage(url), "", Source.TUMBLR);
          }
        }
      }
    }

    return null;
  }

  public void checkForNewImages()
  { 
    List<Post> posts;
    try {  
      posts = client.userDashboard();
    }
    catch(Exception e) { 
      println("OAuth Exception");  
      return;
    }

    for (Post post : posts)
    {
      if (post instanceof PhotoPost)
      {
        List<Photo> photos = ((PhotoPost) post).getPhotos();

        for (Photo pic : photos)
        {
          String url = pic.getSizes().get(0).getUrl();
          if (!usedPics.containsKey(url))
          {
            delegate.pushContent(new Content(loadImage(url), "", Source.TUMBLR));
          } else
          {
            return;
          }
        }
      }
    }
  }

  public void loadPicsToQueue() {

    PImage[] images = loadPics(); 

    for (PImage image : images)
    {
      delegate.pushContent(new Content(image, null, Source.TUMBLR));
    }
  }

  public PImage[] loadPics() {

    ArrayList<PImage> tempListOfPics = new ArrayList<PImage>();

    //User user = client.user();

    List<Post> posts = client.userDashboard();

    for (Post post : posts)
    {
      if (post instanceof PhotoPost)
      {
        List<Photo> photos = ((PhotoPost) post).getPhotos();

        for (Photo pic : photos)
        {
          String url = pic.getSizes().get(0).getUrl();
          if (!usedPics.containsKey(url))
          {
            tempListOfPics.add(loadImage(url));
            usedPics.put(url, null);
            println("loaded pic at " + url);
          }
        }
      }
    }

    // Usage
    List<Post> posts3 = client.blogPosts("seejohnrun");
    for (Post post : posts3) {
      //System.out.println(post.getShortUrl());
    }


    PImage[] retList = new PImage[tempListOfPics.size()];
    for (int i=0; i<tempListOfPics.size (); i++) {
      retList[i] = tempListOfPics.get(i);
    }

    print("Loaded pictures from HD: ");
    println(retList);
    return retList;
  }
}

abstract class ContentProvider extends Thread{
  ProviderDelegate delegate;
  
  ContentProvider(ProviderDelegate delegate){
    this.delegate = delegate;
  }
  
  //override me!
  //Force a picture to load. Use only at initial load time. 
  public abstract Content forceNextPicture();
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "CherryPic" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
