/******************************************************************************\
* Copyright (C) 2012-2013 Leap Motion, Inc. All rights reserved.               *
* Leap Motion proprietary and confidential. Not for distribution.              *
* Use subject to the terms of the Leap Motion SDK Agreement available at       *
* https://developer.leapmotion.com/sdk_agreement, or another agreement         *
* between Leap Motion and you, your company or other organization.             *
\******************************************************************************/

import java.io.IOException;
import java.lang.Math;
import com.leapmotion.leap.*;
import com.leapmotion.leap.Gesture.State;
import java.util.Vector;

class SampleListener extends Listener {
	int framesStat1 = 0;
	int framesStat2 = 0;
	int framesStat3 = 0;
	int framesStat4 = 0;
	int status = 0;
	int lastType = 0;
	
	int lowVelocityPush = 110;
	int highVelocityPush = 130;
	int lowVelocitySwipe = 50;
	int highVelocitySwipe = 100;
	
    public void onInit(Controller controller) {
        System.out.println("Initialized");
    }

    public void onConnect(Controller controller) {
        System.out.println("Connected");
        controller.enableGesture(Gesture.Type.TYPE_KEY_TAP);
		controller.enableGesture(Gesture.Type.TYPE_SCREEN_TAP);
		controller.enableGesture(Gesture.Type.TYPE_CIRCLE);
    }

    public void onDisconnect(Controller controller) {
        //Note: not dispatched when running in a debugger.
        System.out.println("Disconnected");
    }

    public void onExit(Controller controller) {
        System.out.println("Exited");
    }

    public void onFrame(Controller controller) {
		Frame frame = controller.frame();
		GestureList gestures = frame.gestures();
		
		if (frame.hands().count() > 0) {
			HandList allHandsinFrame = frame.hands();
			switch (status) {

				//No gesture detected
				case 0:
					// X-axis Swipe
					if (allHandsinFrame.get(0).palmVelocity().getX() > highVelocitySwipe
					&& allHandsinFrame.get(0).palmVelocity().getY() < lowVelocitySwipe) {
						status = 1;}
					// Y-axis Push
					else if (allHandsinFrame.get(0).palmVelocity().getX() < lowVelocityPush
					&& allHandsinFrame.get(0).palmVelocity().getY() > highVelocityPush){
						status = 3;}
				
				//If coming from case 0, starts gesture
				//If coming from case 1 or case 2, continue detecting gesture
				case 1:
					if (allHandsinFrame.get(0).palmVelocity().getX() > highVelocitySwipe
					&& allHandsinFrame.get(0).palmVelocity().getY() < lowVelocitySwipe) {
						status = 1;
						framesStat1++;
					} else {
						status = 2;
						framesStat2++;
					}

				case 2:
					//If velocity falls below 150 mm/s for more than three frames, then end gesture
					if (framesStat2 > 3) {
						if (framesStat1 > 5) {
							System.out.println("Swipe");
						}
						status = 0;
						framesStat1 = 0;
						framesStat2 = 0;
					//If velocity has only been below 150 mm/s for less than three frames, then keep detecting gesture
					} else {
						status = 1;
					}
					
				case 3:
					if (allHandsinFrame.get(0).palmVelocity().getX() < lowVelocityPush
					&& allHandsinFrame.get(0).palmVelocity().getY() > highVelocityPush) {
						status = 3;
						framesStat3++;
					} else {
						status = 4;
						framesStat4++;}
							
				case 4:
				//If velocity falls below limit for more than three frames, then end gesture
				if (framesStat4 > 3) {
					if (framesStat3 > 5) {
						System.out.println("Push");
					}
					status = 0;
					framesStat3 = 0;
					framesStat4 = 0;
				//If velocity has only been below limit for less than three frames, then keep detecting gesture
				} else {
					status = 3;
					}
			}
		}
	}
}

class Sample3 {
    public static void main(String[] args) {
		// Create a sample listener and controller
        SampleListener listener = new SampleListener();
        Controller controller = new Controller();

        // Have the sample listener receive events from the controller
        controller.addListener(listener);

        // Keep this process running until Enter is pressed
        System.out.println("Press Enter to quit...");
        try {
            System.in.read();
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Remove the sample listener when done
        controller.removeListener(listener);
    }
}
