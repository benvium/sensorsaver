//
//  CVLocationDataViewController.m
//  LocationRecorder
//
//  Created by Benjamin Clayton on 29/11/2012.
//  Copyright (c) 2012 Calvium Ltd. All rights reserved.
//

#import "CVLocationDataViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface CVLocationDataViewController ()

@end

@implementation CVLocationDataViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _currentLocation = [[NSMutableDictionary alloc] initWithCapacity:5];
    _currentHeading = [[NSMutableDictionary alloc] initWithCapacity:5];
    _currentAccel = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChanged:) name:@"CVNewLocation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headingChanged:) name:@"CVNewHeading" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accelChanged:) name:@"CVNewAccel" object:nil];
}

-(void) headingChanged:(NSNotification*) note {        
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(actuallyUpdateHeading) object:nil];
    [self performSelector:@selector(actuallyUpdateHeading:) withObject:note.userInfo afterDelay:0.1];
}

-(void) accelChanged:(NSNotification*) note {
    _currentAccel = [note.userInfo copy];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
}

-(void) locationChanged:(NSNotification*) note {
    [_currentLocation addEntriesFromDictionary:note.userInfo];

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

-(void) actuallyUpdateHeading:(NSDictionary*) dict {
    _currentHeading = [dict copy];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [_currentLocation count];
        case 1:
            return [_currentHeading count];
        case 2:
            return [_currentAccel count];
    }
    
    return 0;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Location";
        case 1:
            return @"Heading";
        case 2:
            return @"Acceleration";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSString* name;
    double value;
    
    NSDictionary* data;
    switch (indexPath.section) {
        case 0:
            data = _currentLocation;
            break;
        case 1:
            data = _currentHeading;
            break;
        case 2:
            data = _currentAccel;
            break;
    }
    
    name = [data allKeys][indexPath.row];
    value = [(NSNumber*)data[ name ] doubleValue];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.5f", value];
    cell.textLabel.text = name;

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
