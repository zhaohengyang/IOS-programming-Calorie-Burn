//
//  CaloryTrack.h
//  TrackCaloryBurn
//
//  Created by mike yang on 11/29/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CaloryTrack : NSManagedObject

@property (nonatomic, retain) NSNumber * calories;
@property (nonatomic, retain) NSDate * date;

@end
