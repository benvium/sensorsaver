//
//  CVAppDelegate.h
//  LocationRecorder
//
//  Created by Benjamin Clayton on 29/11/2012.
//  Copyright (c) 2012 Calvium Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class DDFileLogger;

@interface CVAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate> {
    NSOperationQueue* queue;
//    DDFileLogger* _fileLogger;

    NSMutableArray* _locationData;
    NSMutableArray* _headingData;
    NSMutableArray* _motionData;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DDFileLogger* fileLogger;

@end
