//
//  CaloryTrackController.h
//  TrackCaloryBurn
//
//  Created by mike yang on 11/29/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CaloryTrack.h"
#import "AppDelegate.h"

@interface CaloryTrackController : NSObject

- (void) createSevealNewTracks;
- (void) updateCaloriesToCoreData:(float) calories;
- (void) deleteAllTracks;
- (BOOL) createNewCaloryTrackWithCalories:(NSNumber*)calories lastName:(NSDate*)date;
- (BOOL) isEqualToday:(NSDate*) date;
@end
