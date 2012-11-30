//
//  CVAppDelegate.m
//  LocationRecorder
//
//  Created by Benjamin Clayton on 29/11/2012.
//  Copyright (c) 2012 Calvium Ltd. All rights reserved.
//

#import "CVAppDelegate.h"
#import <CoreMotion/CoreMotion.h>
#import "DDLog.h"
#import "DDFileLogger.h"
#import "DDTTYLogger.h"
#import "NSDictionary+bv_flatDictionaryDescription.h"

@implementation CVAppDelegate

static CLLocationManager* locationManager;
static CMMotionManager* motionManager;

static const int ddLogLevel = LOG_LEVEL_INFO;

static int motionCounter = 0;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure fast logger...
    _fileLogger = [[DDFileLogger alloc] init];
    _fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    _fileLogger.logFileManager.maximumNumberOfLogFiles = 7; // a weeks worth
    [DDLog addLogger:_fileLogger];
//    [DDLog addLogger:[DDTTYLogger sharedInstance]]; this is log to xcode window.

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
    
    queue = [[NSOperationQueue alloc] init];
    motionManager = [[CMMotionManager alloc] init];
    
    motionManager.deviceMotionUpdateInterval = 0.05; // 20 times a second.
    [motionManager startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion *motion, NSError *error) {
        
        motionCounter = (motionCounter + 1) % 5;
        
        NSDictionary* data = @{
        @"gravity x":[NSNumber numberWithDouble:motion.gravity.x],
        @"gravity y":[NSNumber numberWithDouble:motion.gravity.y],
        @"gravity z":[NSNumber numberWithDouble:motion.gravity.z],
        @"roll (radians)":[NSNumber numberWithDouble:motion.attitude.roll],
        @"pitch (radians)":[NSNumber numberWithDouble:motion.attitude.pitch],
        @"yaw (radians)":[NSNumber numberWithDouble:motion.attitude.yaw],
        @"rotation rate x (r/s)":[NSNumber numberWithDouble:motion.rotationRate.x],
        @"rotation rate y (r/s)":[NSNumber numberWithDouble:motion.rotationRate.y],
        @"rotation rate z (r/s)":[NSNumber numberWithDouble:motion.rotationRate.z],
        @"mag field accuracy":[NSNumber numberWithDouble:motion.magneticField.accuracy],
        @"mag field x":[NSNumber numberWithDouble:motion.magneticField.field.x],
        @"mag field y":[NSNumber numberWithDouble:motion.magneticField.field.y],
        @"mag field z":[NSNumber numberWithDouble:motion.magneticField.field.z],
        };
        
        // Ok to log here as DDLog is thread-safe
        DDLogInfo( @"%.0f,%@", motion.timestamp, [data bv_flatDictionaryDescription] );
        
        // update interface occasionally.
        if (motionCounter == 0) {            
            [self performSelectorOnMainThread:@selector(sendAccelUpdateInMainThread:) withObject:data waitUntilDone:NO];
        }
    }];
    
    return YES;
}

-(void) sendAccelUpdateInMainThread:(NSDictionary*) dict {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CVNewAccel" object:nil userInfo:dict];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    NSDictionary* data = @{@"latitude" : [NSNumber numberWithDouble:newLocation.coordinate.latitude],
    @"longitude" : [NSNumber numberWithDouble:newLocation.coordinate.longitude],
    @"altitude" : [NSNumber numberWithDouble:newLocation.altitude],
    @"horizontal accuracy": [NSNumber numberWithDouble:newLocation.horizontalAccuracy],
    @"vertical accuracy": [NSNumber numberWithDouble:newLocation.verticalAccuracy],
    @"course (degrees)": [NSNumber numberWithDouble:newLocation.course],
    @"speed (meters/sec)": [NSNumber numberWithDouble:newLocation.speed] };
    
    DDLogInfo( @"%@,%@", newLocation.timestamp, [data bv_flatDictionaryDescription] );
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CVNewLocation" object:nil userInfo:data];
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading {
    NSDictionary* data = @{
    @"headingAccuracy": [NSNumber numberWithDouble:newHeading.headingAccuracy],
    @"magneticHeading": [NSNumber numberWithDouble:newHeading.magneticHeading],
    @"trueHeading": [NSNumber numberWithDouble:newHeading.trueHeading],
    @"x": [NSNumber numberWithDouble:newHeading.x],
    @"y": [NSNumber numberWithDouble:newHeading.y],
    @"z": [NSNumber numberWithDouble:newHeading.z]
    };
    
    DDLogInfo( @"%@,%@", newHeading.timestamp, [data bv_flatDictionaryDescription] );
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CVNewHeading" object:nil userInfo:data];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
