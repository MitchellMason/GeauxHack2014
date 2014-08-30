abstract class ContentProvider extends Thread{
  ProviderDelegate delegate;
  
  ContentProvider(ProviderDelegate delegate){
    this.delegate = delegate;
  }
  
  //override me!
  //Force a picture to load. Use only at initial load time. 
  abstract Content forceNextPicture();
}
