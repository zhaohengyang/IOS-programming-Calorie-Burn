//
//  Account.h
//  TrackCaloryBurn
//
//  Created by mike yang on 12/1/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSString * password;

@end
