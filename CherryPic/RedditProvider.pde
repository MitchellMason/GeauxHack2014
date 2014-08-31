/*import com.github.*;
//import com.github.jreddit.entity.User;
//import com.github.jreddit.exception.RedditError;
//import com.github.jreddit.exception.RetrievalFailedException;
//import com.github.jreddit.retrieval.ExtendedSubreddits;
//import com.github.jreddit.retrieval.Subreddits;
//import com.github.jreddit.utils.restclient.HttpRestClient;
//import com.github.jreddit.utils.restclient.RestClient;
import java.util.HashMap;
import java.util.List;

class RedditProvider extends ContentProvider {

  PImage loadedPics[];
  HashMap usedPics = new HashMap();
  RestClient restClient;
  User user;

  RedditProvider(ProviderDelegate delegate) {
    super(delegate);

    restClient = new HttpRestClient();
    restClient.setUserAgent("bot/1.0 by name");
     
    user = new User(restClient, "username", "password");
    try {
        user.connect();
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    // Handle to Submissions, which offers the basic API submission functionality
    Submissions subms = new Submissions(restClient, user);
    
    // Retrieve submissions of a submission
    List<Submission> submissionsSubreddit = subms.ofSubreddit("programming", SubmissionSort.TOP, -1, 100, null, null, true);
    
    println(submissionsSubreddit[0]);
    
    //facebookClient = new DefaultFacebookClient("CAACEdEose0cBAFYVInCp7ZAgAAO2EmrGRId6OobhQFOer40aDZAfm0Q0M41PLgne3AAMC7rENi2t2LSyBVhDbnfKwPTu24wkkfZAOuNDQEBqQ0uCZByPeSXer3uo7dbiYxU2Vj0pbSDZAIL4rr0UCa2N2ZCZCdMmcUKlDV7LVQGdwZBIeCw0cNYEWZAg0xKfaDCcMPmekuToQ0mhT7aFfZCB2a");
  }

  //Called at the start of the thread.
  void run() {
   
    checkForNewImages();
    
    Connection<Photo> photos = facebookClient.fetchConnection("me/photos", Photo.class);
    List<Photo> photosList = photos.getData();
    println(photosList);
    
    for(Photo pic : photosList)
    {
       println(pic); 
      
    }
    
    //req.setAttribute("photosList",photosList);
    
    while (true)
    {
      println("thread");

      try { 
        this.sleep(10000);
      }
      catch (InterruptedException ie) {
      }
    }
  }

  //Force one photo to pull into the queue
  Content forceNextPicture() {


    String url = pic.getSizes().get(0).getUrl();

    if (!usedPics.containsKey(url))
    {
      println("loaded pic at " + url);
      usedPics.put(url, null);
      return new Content(loadImage(url), "", Source.TUMBLR);
    }


    return null;
  }

  void checkForNewImages()
  { 
    
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
    
  }

  void loadPicsToQueue() {

   PImage[] images = loadPics(); 

    for (PImage image : images)
    {
      delegate.pushContent(new Content(image, null, Source.TUMBLR));
    }
  }

  PImage[] loadPics() {
return null;

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
    
  }
}
*/
