
import com.github.jreddit.*;
import java.util.HashMap;
import java.util.List;

class RedditProvider extends ContentProvider {
  String username;
  String password;
  com.github.jreddit.user.User client;
  
  RedditProvider(ProviderDelegate delegate) {
    super(delegate);
  }
  
  void run() {
  }
  
  Content forceNextPicture() {
    return null;
  }
}
*/
