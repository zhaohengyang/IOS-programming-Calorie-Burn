//
//  FitnessAlgorithm.h
//  circleProcessView
//
//  Created by mike yang on 11/28/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>



@interface FitnessAlgorithm : NSObject
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, assign) int step;
@property (nonatomic, assign) float speed;

- (float) calculateMetByAverageSpeed:(float) speed;
- (float)calculateCaloriesBurnByRunningPerMinit_weightInPound:(float) weight met:(float) met;
- (void)startSpeedTracer;
- (void)startStepTracer;
- (void)pauseStepAndSpeedTracer;
- (void)stopStepAndSpeedTracer;
- (float) getSpeed;
- (int) getStep;
@end
