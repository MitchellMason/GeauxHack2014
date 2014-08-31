import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.tumblr.jumblr.JumblrClient;
import com.tumblr.jumblr.types.Blog;
import com.tumblr.jumblr.types.Photo;
import com.tumblr.jumblr.types.PhotoPost;
import com.tumblr.jumblr.types.Post;
import java.util.HashMap;
import java.util.List;

//Uses the Jumblr Client library
class TumblrProvider extends ContentProvider {

  PImage loadedPics[];
  JumblrClient client;
  HashMap usedPics = new HashMap();

  TumblrProvider(ProviderDelegate delegate) {
    super(delegate);

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
  void run() {
    checkForNewImages();
    
    while(true)
    {
      println("thread");
      
      try { this.sleep(10000); }
      catch (InterruptedException ie) {}
    }
  }

  //Force one photo to pull into the queue
  Content forceNextPicture() {

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

  void checkForNewImages()
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
          }
          else
          {
            return;
          }
        }
      }
    }
  }

  void loadPicsToQueue() {

    PImage[] images = loadPics(); 

    for (PImage image : images)
    {
      delegate.pushContent(new Content(image, null, Source.TUMBLR));
    }
  }

  PImage[] loadPics() {

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
    for (int i=0; i<tempListOfPics.size(); i++) {
      retList[i] = tempListOfPics.get(i);
    }

    print("Loaded pictures from HD: ");
    println(retList);
    return retList;
  }
}

