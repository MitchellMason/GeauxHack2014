import de.voidplus.leapmotion.*;
import development.*;

class LeapDelegate{
  CherryPic main;
  LeapMotion leap;
  LeapDelegate(CherryPic main){
    this.main = main;
    leap = new LeapMotion(main).withGestures();
  }
  
  void swipe(){
    main.proceedToNextImage(true);
  }
  void buttonPush(){
    main.changeChannel();
  }
}
