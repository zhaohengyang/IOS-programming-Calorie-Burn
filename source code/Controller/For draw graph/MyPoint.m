//
//  MyPoint.m
//  LineChart_4
//
//  Created by mike yang on 11/23/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import "MyPoint.h"

@implementation MyPoint

// =================================================================
// Initialize date and calories
- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

// =================================================================
// return myDate
-(NSDate*) getMyDate{
    return self.myDate;
}

// =================================================================
// return calories
-(NSNumber*) getCalories{
    return self.calories;
}
/*
-(void) setDate:(NSDate*) date{
    self.myDate = date;
}
-(void) setCalories:(NSNumber*) cal{
    self.calories = cal;
}
 */
@end
