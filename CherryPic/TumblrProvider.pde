import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.tumblr.jumblr.JumblrClient;
import com.tumblr.jumblr.types.Blog;
import com.tumblr.jumblr.types.PhotoPost;
import com.tumblr.jumblr.types.Post;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

class TumblrProvider extends ContentProvider {

  String pathToPics = "/images";
  PImage loadedPics[];

  TumblrProvider(ProviderDelegate delegate) {
    super(delegate);
  }

  //Called at the start of the thread.
  void start() {
    loadedPics = loadPics();
  }

  Content forceNextPicture() {
    //return null;
    return new Content(loadedPics[(int)random(0, loadedPics.length)], "", Source.TUMBLR);
  }

  PImage[] loadPics() {
    
    ArrayList<PImage> tempListOfPics = new ArrayList<PImage>();
    
    JumblrClient client = new JumblrClient(
      "IMsypM9lJL3Xhkxn3mNGWbQrm8Pfzb4kE3Z7BDQtQ24T5alp2j",
      "WEnNITaXYPBdUcPrV1wRAARn9DY3cthtqRfPs6my1SIm3kw6AJ"
    );
    client.setToken(
      "cSuwaPdeLMt3ewCGyamQ5rV6dkw75ZSvwfuZSqtgwtwr9FhpYF",
      "I1RjJ447nYlMFDDysn23NWIHC1sYsf8Sz887PftJQJ5GyWeHWE"
    );

    //User user = client.user();
    
    List<Post> posts = client.userDashboard();
    
    for(Post post : posts)
    {
      if(post instanceof PhotoPost)
      {
        List<Photo> photos = ((PhotoPost) post).getPhotos();
        
        for(Photo pic : photos)
        {
           String url = pic.getSizes().get(0).getUrl();
           tempListOfPics.add(loadImage(url));
           println("loaded pic at " + url);
          
        }
      }
    }
    
    // Usage
        List<Post> posts3 = client.blogPosts("seejohnrun");
        for (Post post : posts3) {
            //System.out.println(post.getShortUrl());
        }
        
    
    PImage[] retList = new PImage[tempListOfPics.size()];
    for(int i=0; i<tempListOfPics.size(); i++){
      retList[i] = tempListOfPics.get(i);
    }
    
    print("Loaded pictures from HD: ");
    println(retList);
    return retList; 
  }
}

