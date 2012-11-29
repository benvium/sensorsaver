//
//  CVAppDelegate.h
//  LocationRecorder
//
//  Created by Benjamin Clayton on 29/11/2012.
//  Copyright (c) 2012 Calvium Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CVAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate> {
    NSOperationQueue* queue;
}

@property (strong, nonatomic) UIWindow *window;

@end
