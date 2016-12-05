//
//  myViewController.m
//  TrackCaloryBurn2
//
//  Created by mike yang on 11/29/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import "myViewController.h"

@implementation myViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;

    NSNumber *n1 = [NSNumber numberWithFloat:230.22];
    NSNumber *n2 = [NSNumber numberWithFloat:50.67];
    NSDate* d1 = [NSDate dateWithTimeIntervalSinceNow:3600*24];
    NSDate* d2 = [NSDate dateWithTimeIntervalSinceNow:3600*48];

    [self createNewCaloryTrackWithCalories:n1 lastName:d1];
    [self createNewCaloryTrackWithCalories:n2 lastName:d2];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    /* Here is the entity whose contents we want to read */
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CaloryTrack" inManagedObjectContext:managedObjectContext];
    /* Tell the request that we want to read the contents of the Person entity */
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    /* And execute the fetch request on the context */
    NSArray *caloryTracks =
    [managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    /* Make sure we get the array */
    if ([caloryTracks count] > 0){
        /* Go through the track array one by one */
        NSUInteger counter = 1;
        for (CaloryTrack *thisTrack in caloryTracks){
            NSLog(@"%lu:\t calories = %.1f, Date = %@",
                  (unsigned long)counter, [thisTrack.calories floatValue], thisTrack.date.description);
            counter++;
        }
    } else {
        NSLog(@"Could not find any CaloryTrack entities in the context.");
    }
    
}


- (BOOL)createNewCaloryTrackWithCalories:(NSNumber*)calories lastName:(NSDate*)date{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    bool result = NO;
    if (date == nil) {
        return NO;
    }
    CaloryTrack *newTrack = [NSEntityDescription insertNewObjectForEntityForName:@"CaloryTrack"
                                                          inManagedObjectContext:managedObjectContext];
    if (newTrack == nil){
        NSLog(@"Failed to create a new calory record.");
        return NO;
    }
    newTrack.calories = calories;
    newTrack.date = date;
    NSError *savingError = nil;
    if ([managedObjectContext save:&savingError]){
        return YES;
    } else {
        NSLog(@"Failed to save the new calory record. Error = %@", savingError);
    }
    return result;
}

@end
