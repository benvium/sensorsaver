//
//  CVLocationDataViewController.h
//  LocationRecorder
//
//  Created by Benjamin Clayton on 29/11/2012.
//  Copyright (c) 2012 Calvium Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVLocationDataViewController : UITableViewController {
    NSMutableDictionary* _currentLocation;
    NSMutableDictionary* _currentHeading;
    NSMutableDictionary* _currentAccel;
}

@end
