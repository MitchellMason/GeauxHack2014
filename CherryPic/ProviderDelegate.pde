class ProviderDelegate{
  PApplet main;
  ProviderDelegate(PApplet main){
    this.main = main;
  }
  
  //Pushes content casually
  void pushContent(Content next){
    main.addImageToQueue(next, false);
  }
  
  //Forces content to the screen RIGHT NOW
  void shoveContent(Content betterBeGood){
    main.addImageToQueue(betterBeGood, true);
  }
}
