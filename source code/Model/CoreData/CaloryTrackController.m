//
//  CaloryTrackController.m
//  TrackCaloryBurn
//
//  Created by mike yang on 11/29/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import "CaloryTrackController.h"

@implementation CaloryTrackController

- (void) createSevealNewTracks{
    for (int k = 10; k > 0; k--) {
        NSNumber *n = [NSNumber numberWithFloat:200];
        NSDate *d = [NSDate dateWithTimeIntervalSinceNow:-3600*24*k];
        [self createNewCaloryTrackWithCalories:n lastName:d];
    }

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CaloryTrack" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    NSArray *caloryTracks =
    [managedObjectContext executeFetchRequest:fetchRequest error:&requestError];


    if ([caloryTracks count] > 0){
        // =================================================================
        // Print out each track
        NSUInteger counter = 1;
        for (CaloryTrack *thisTrack in caloryTracks){
            NSLog(@"\n%lu:\t calories = %.1f, Date = %@",
                  (unsigned long)counter, [thisTrack.calories floatValue], thisTrack.date.description);
            counter++;
        }
    }
}

- (void) updateCaloriesToCoreData:(float) calories{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CaloryTrack" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    NSArray *caloryTracks =
    [managedObjectContext executeFetchRequest:fetchRequest error:&requestError];


    if ([caloryTracks count] > 0){
        // =================================================================
        // Print out each track
        NSUInteger counter = 1;
        for (CaloryTrack *thisTrack in caloryTracks){
            NSLog(@"\n%lu:\t calories = %.1f, Date = %@",
                  (unsigned long)counter, [thisTrack.calories floatValue], thisTrack.date.description);
            counter++;
        }

        // =================================================================
        // Delete track which is too old
        while ([caloryTracks count] >= 5) {
            NSLog(@"Track number in database is :%lu",[caloryTracks count]);
            CaloryTrack *oldestTrack = [caloryTracks firstObject];
            [managedObjectContext deleteObject:oldestTrack];

            // =================================================================
            // Save context
            NSError *savingError = nil;
            if ([managedObjectContext save:&savingError]){
                NSLog(@"Successfully saved the context.");
            }
            else {
                NSLog(@"Failed to save the context.");
            }

            // =================================================================
            // fetch again
            caloryTracks =
            [managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
            NSLog(@"Track number in database is :%lu",[caloryTracks count]);
        }

        // =================================================================
        // Print out each track
        counter = 1;
        for (CaloryTrack *thisTrack in caloryTracks){
            NSLog(@"\n%lu:\t calories = %.1f, Date = %@",
                  (unsigned long)counter, [thisTrack.calories floatValue], thisTrack.date.description);
            counter++;
        }

        CaloryTrack *track = [caloryTracks lastObject];
        // =================================================================
        // Add calory value to today's track
        if ([self isEqualToday:track.date]) {
            float newCalories = [track.calories floatValue] + calories;
            track.calories = [ NSNumber numberWithFloat:newCalories];

            // =================================================================
            // Save context
            NSError *savingError = nil;
            if ([managedObjectContext save:&savingError]){
                NSLog(@"Successfully saved the context.");
            }
            else {
                NSLog(@"Failed to save the context.");
            }
        }
        else{
            [self createNewCaloryTrackWithCalories:[NSNumber numberWithFloat:calories] lastName:[NSDate dateWithTimeIntervalSinceNow:0]];
        }

        // =================================================================
        // Print out each track
        counter = 1;
        caloryTracks =
        [managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
        for (CaloryTrack *thisTrack in caloryTracks){
            NSLog(@"\n%lu:\t calories = %.1f, Date = %@",
                  (unsigned long)counter, [thisTrack.calories floatValue], thisTrack.date.description);
            counter++;
        }
    }
    else {
        NSLog(@"Could not find any CaloryTrack entities in the context.");
        [self createNewCaloryTrackWithCalories:[NSNumber numberWithFloat:calories] lastName:[NSDate dateWithTimeIntervalSinceNow:0]];
    }
}

- (void) deleteAllTracks{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CaloryTrack" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    NSArray *caloryTracks =
    [managedObjectContext executeFetchRequest:fetchRequest error:&requestError];

    if ([caloryTracks count] > 0){
        // =================================================================
        // Print out each track
        NSUInteger counter = 1;
        for (CaloryTrack *thisTrack in caloryTracks){
            [managedObjectContext deleteObject:thisTrack];
            counter++;
        }
        NSLog(@"All tracks deleted");
        NSError *savingError = nil;
        if ([managedObjectContext save:&savingError]){
            NSLog(@"Successfully saved the context.");
        }
        else {
            NSLog(@"Failed to save the context.");
        }
    }
    else{
        NSLog(@"Nothing to deleted");
    }
}

- (BOOL) isEqualToday:(NSDate*) date{
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);

    NSDateComponents *dateComponents = [calendar components:comps
                                                   fromDate: date];
    NSDateComponents *todayComponents = [calendar components:comps
                                                    fromDate: today];

    NSDate* date1 = [calendar dateFromComponents:dateComponents];
    NSDate* date2 = [calendar dateFromComponents:todayComponents];
    return [date1 isEqualToDate:date2];
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
