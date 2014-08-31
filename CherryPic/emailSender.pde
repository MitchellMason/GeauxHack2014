class EmailSender extends Thread {
  CherryPic main;
  EmailSender(CherryPic main) {
    this.main = main;
  }

  void run() {
    sendEmail("thefreemason11@gmail.com", "GeauxCherryPic@gmail.com", "This e-mail is sent in response to the picture you have requested.", channelContent.get(contentQueueIndex).getPicture());
  }
  void sendEmail(String rec, String from, String body, PImage attatchment) {
    main.transferringEmail= true;
    main.holdEmailUntil = frameCount + (60*2);
    SendGrid.Email email = new SendGrid.Email();
    email.addTo(rec);
    email.addToName("Best Friend");
    email.setFrom(from);
    email.setHtml("<body style=\"font-family:monospace;\">" + "\r\n" + toAsciiArt(attatchment) + "</body>");
    email.setSubject("Picture request");
    String imageName = Integer.toString((int)random(0f, 10000f)) + ".png";
    File imageFile = new File(sketchPath("") + imageName);
    attatchment.save(imageName);

    try {
      email.addAttachment(imageName, imageFile);
      SendGrid.Response response = sendGrid.send(email);
      System.out.println(response.getMessage());
      imageFile.delete();
    }
    catch (SendGridException e) {
      System.err.println(e);
    }
    catch(IOException e) {
      System.err.println(e);
    }
    catch (Exception e) {
      //whatever
      println("************************************ file didn't delete or something. Oh well");
    }
  }

  String toAsciiArt(PImage img) {
    PImage temp = new PImage(img.width, img.height);
    for (int i=0; i<temp.pixels.length; i++) {
      temp.pixels[i] = img.pixels[i];
    }
    temp.resize(100, 100);
    temp.updatePixels();
    String result = "";
    String TextScale = " .,:;irsXA253hMHGS#9B&@"; //23 chars
    char[] scale = TextScale.toCharArray();
    int[] pix = temp.pixels;
    for (int x=0; x<temp.width; x++) {
      for (int y=0; y<temp.height; y++) {
        int pixel     = getPixelVal(x, y, temp.width, pix);
        float val     = average(red(pixel), green(pixel), blue(pixel));
        float percent = map(val, 0, 255, 22, 0);
        char pixelVal = scale[(int) (percent+.05f)];
        result += pixelVal;
      }
      result += "\n";
    }
    return result;
  }

  float average(float val1, float val2, float val3) {
    return ((float)(val1 + val2 + val3) / 3f);
  }

  int getPixelVal(int x, int y, int width, int[] pixels) {
    return pixels[x*width + y];
  }
}

