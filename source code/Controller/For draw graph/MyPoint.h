//
//  MyPoint.h
//  LineChart_4
//
//  Created by mike yang on 11/23/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPoint : NSObject

// ==================================================================
// Properties
@property (nonatomic) NSDate *myDate;
@property (nonatomic) NSNumber *calories;

// ==================================================================
// Public functions
-(NSDate*) getMyDate;
-(NSNumber*) getCalories;
//-(void) setDate:(NSDate*) date;
//-(void) setCalories:(NSNumber*)cal;
@end
