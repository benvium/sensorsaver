//
//  CVLocationDataViewController.h
//  LocationRecorder
//
//  Created by Benjamin Clayton on 29/11/2012.
//  Copyright (c) 2012 Calvium Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface CVLocationDataViewController : UITableViewController <MFMailComposeViewControllerDelegate> {
    NSDictionary* _currentLocation;
    NSDictionary* _currentHeading;
    NSDictionary* _currentAccel;
}

@end
