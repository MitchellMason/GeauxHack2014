//CAACEdEose0cBAFYVInCp7ZAgAAO2EmrGRId6OobhQFOer40aDZAfm0Q0M41PLgne3AAMC7rENi2t2LSyBVhDbnfKwPTu24wkkfZAOuNDQEBqQ0uCZByPeSXer3uo7dbiYxU2Vj0pbSDZAIL4rr0UCa2N2ZCZCdMmcUKlDV7LVQGdwZBIeCw0cNYEWZAg0xKfaDCcMPmekuToQ0mhT7aFfZCB2a

//import com.google.gson.JsonObject;
//import com.google.gson.JsonParser;
import java.util.HashMap;
import java.util.List;
//import com.restfb.BinaryAttachment;
//import com.restfb.DefaultFacebookClient;
//import com.restfb.FacebookClient;
//import com.restfb.Parameter;
import com.restfb.*;

class FacebookProvider extends ContentProvider {

  PImage loadedPics[];
  HashMap usedPics = new HashMap();
  FacebookClient facebookClient;

  FacebookProvider(ProviderDelegate delegate) {
    super(delegate);
    facebookClient = new DefaultFacebookClient("CAACEdEose0cBAOmZCZAq6WmoTcXzXhMkNsRBt4gqzuwZCLmaYcS1XiSQt1mk7yQGY91v4hSrC1zuIAZB9GA6HlarZCUCCRrjwI18L0gmp3Q5QQFiOjXp4GWFwgiGO9ph3aZClCSZClLXr1R2nzXZCR8e59ZACZBtEVvZBF9ZC4Jd8d8ZAuwQ0ZBvbIlPGYZCF2Ji2OcHapeJ7ZBbHIx3l8g1w5NvXa2w");  
  }

  //Called at the start of the thread.
  void run() {
   
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
  Content forceNextPicture() {

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

  void checkForNewImages()
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

  void loadPicsToQueue() {
/*
    PImage[] images = loadPics(); 

    for (PImage image : images)
    {
      delegate.pushContent(new Content(image, null, Source.TUMBLR));
    }
  */}

  PImage[] loadPics() {
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

