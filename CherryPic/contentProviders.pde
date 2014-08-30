abstract class ContentProvider extends Thread{
  ContentProvider(ProviderDelegate delegate){};
  PImage forceNextPicture(){
    println("Not implemented");
    return null;
  };
}
