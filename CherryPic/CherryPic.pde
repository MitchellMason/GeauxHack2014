//App vars
final int screenWidth  = 1280;
final int screenHeight = 720;

//Net vars


//Content Providers
ProviderDelegate delegate;
HardDriveProvider hdPro;

void setup(){
  //Init graphics
  size(screenWidth, screenHeight);
  
  //Init providers
  delegate = new ProviderDelegate(this);
  hdPro = new HardDriveProvider(delegate);
  hdPro.start();
}
void draw(){
  background(0);
}

//Called when the app exits. Use this to quit all threads, close all network jobs, etc.
void exit(){}

