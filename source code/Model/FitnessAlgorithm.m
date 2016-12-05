//
//  FitnessAlgorithm.m
//  circleProcessView
//
//  Created by mike yang on 11/28/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import "FitnessAlgorithm.h"

@implementation FitnessAlgorithm

- (id)init{
    self = [super init];
    if (self) {
        self.step = 0;
        self.speed = 0;
        self.motionManager = [[CMMotionManager alloc] init];
    }
    return self;
}

/* ---------------------------------------------------------------------------
 Forumla from : http://www.buchholzmedgroup.com/new_content/CA_PREVENTION/MET%20table%20Exercise.pdf

 Met table: create relationship between speed and Met
 ---------------------------------------------------------------------------*/
- (float) calculateMetByAverageSpeed:(float) speed{ //mph
    float lowerBoundMet;
    float upperBoundMet;
    float realMet;
    if (speed > 14) {
        speed = 14;
    }

    int lowerBound = floor(speed);
    switch (lowerBound) {
        case 0:
            lowerBoundMet = 0; upperBoundMet = 0;
            break;
        case 1:
            lowerBoundMet = 2.0; upperBoundMet = 2.0;
            break;
        case 2:
            lowerBoundMet = 4.5; upperBoundMet = 4.5;
            break;
        case 3:
            lowerBoundMet = 4.5; upperBoundMet = 6.0;
            break;
        case 4:
            lowerBoundMet = 6.0; upperBoundMet = 8.3;
            break;
        case 5:
            lowerBoundMet = 8.3; upperBoundMet = 9.8;
            break;
        case 6:
            lowerBoundMet = 9.8; upperBoundMet = 11;
            break;
        case 7:
            lowerBoundMet = 11; upperBoundMet = 11.8;
            break;
        case 8:
            lowerBoundMet = 11.8; upperBoundMet = 12.8;
            break;
        case 9:
            lowerBoundMet = 12.8; upperBoundMet = 14.5;
            break;
        case 10:
            lowerBoundMet = 14.5; upperBoundMet = 16;
            break;
        case 11:
            lowerBoundMet = 16; upperBoundMet = 19;
            break;
        case 12:
            lowerBoundMet = 19; upperBoundMet = 19.8;
            break;
        case 13:
            lowerBoundMet = 19.8; upperBoundMet = 23;
            break;
        case 14:
            lowerBoundMet = 23; upperBoundMet = 23;
            break;
    }
    realMet = (upperBoundMet - lowerBoundMet) * (speed - lowerBound) + lowerBoundMet;
    return realMet;
}

/* ---------------------------------------------------------------------------
 Forumla from : http://calcnexus.com/calories-burned-calculator.php?calc=1&cat=run&t=30&weight=165

 Calories Burned = Duration in second x ((MET x 3.5 x weight in kg)/200).
 ---------------------------------------------------------------------------*/
- (float)calculateCaloriesBurnByRunningPerMinit_weightInPound:(float) weight met:(float) met{
    float weightInKG = weight * 0.453592;
    return (met * 3.5 * weightInKG / 200.0)/60.0;
}

- (void)startSpeedTracer{
    // The speed and step tracer is stepup as 100HZ
    self.motionManager.accelerometerUpdateInterval = 0.01;

    if ([self.motionManager isAccelerometerAvailable]){
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                                 withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                     [self speedTracer:accelerometerData.acceleration];
                                                     if(error){

                                                         NSLog(@"%@", error);
                                                     }
                                                 }];
    }
    else {
        NSLog(@"Accelerometer is not available.");
    }
}

- (void)startStepTracer{
    // The speed and step tracer is stepup as 100HZ
    self.motionManager.accelerometerUpdateInterval = 0.01;

    if ([self.motionManager isAccelerometerAvailable]){
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                                 withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                     [self stepTracer:accelerometerData.acceleration];
                                                     if(error){

                                                         NSLog(@"%@", error);
                                                     }
                                                 }];
    }
    else {
        NSLog(@"Accelerometer is not available.");
    }
}

- (void)pauseStepAndSpeedTracer{
    [self.motionManager stopAccelerometerUpdates];
}

- (void)stopStepAndSpeedTracer{
    [self.motionManager stopAccelerometerUpdates];
    self.speed = 0;
    self.step = 0;
}

// ========================================================
// Count the number of output points and the number of steps
int numberOfOutput = 0;
int numberOfStep = 0;

// ========================================================
// Compare last value and current value to know up, down or even
float last = 0;

// ========================================================
// Define each states
static int const UP = 0;
static int const DOWN = 1;
static int const EVEN = 2;

// ========================================================
// Initialize state with EVEN state
int state = EVEN;

// ========================================================
// The time duration in each states
int upTime = 0;
int downTime = 0;
int evenTime = 0;

// ========================================================
// The max time duration in each states
int maxUpTime = 0;
int maxdownTime = 0;

// ========================================================
// The max time duration in each states
int stepTime = 0;

// ========================================================
// The top value durting each steps
float topValue = 1;

// ========================================================
// single up calculate each single duration
// Use single up to erase high requency changes
int singleUp = 0;
int singleDown = 0;

// ========================================================
// check if stops
int stopTimer = 0;

// ========================================================
// Define a Coefficient to calculate speed
static float const K = 1.414;

// ========================================================
// The output of this function is step number and current speed
// This variable indicate the function generate output in this round or not

-(void)speedTracer:(CMAcceleration)acceleration
{
    float current = (acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z);

    // Unmove for 1 second, speed reset to 0
    stopTimer++;
    if (stopTimer >= 100) {
        self.speed = 0;
        stopTimer = 0;
    }

    

    if (last !=  0) {
        //NSLog(@"compare last:%f and current:%f",last, current);
        if (current <= last + 0.01 && current >= last - 0.01) { // even line
            last = current;
        }
        if (current == last) {
            //NSLog(@"%d's even",numberOfOutput++);
            evenTime++;
            // Four even in sequence
            if (evenTime > 3) {
                // ==========================================================
                // reset stepTime and top value
                topValue = 1;
                stepTime = 0;
                maxdownTime = 0;
                maxUpTime = 0;
                upTime = 0;
                downTime = 0;
                singleUp = 0;
                singleDown = 0;

                // ==========================================================
                // Change state to even
                state = EVEN;
                evenTime = 0;
            }
        }
        else if (current > last) {
            // ======================================================
            // When up appear reset single down and evenTime
            singleDown = 0;
            evenTime = 0;

            // ======================================================
            // Duration extend by one
            singleUp++;
            upTime++;

            switch (state) {
                case UP:{// start climbing
                         // ==========================================================
                         // reset down time when singleUp >= 3
                    if (singleUp >= 3) {
                        downTime = 0;
                    }

                    // ==========================================================
                    // reset max down time
                    stepTime = (maxdownTime != 0) ? stepTime + maxdownTime : 0;
                    maxdownTime = 0;

                    //NSLog(@"In up state, stepTime is: %d",stepTime);
                    //NSLog(@"top value is: %f",topValue);
                    //=========================================================
                    // Check the last climb time and update foot step
                    if (stepTime >= 20 && topValue >= 1.50) {
                        //=========================================================
                        // Generate output which will return at the end of this function
                        self.speed = topValue * stepTime * K / 30.0;
                        self.step++;

                        //=========================================================
                        // Reset stop sener and variable for counting speed
                        stopTimer = 0;
                        topValue = 1;
                        stepTime = 0;
                    }

                    // ==========================================================
                    // count max uptime
                    maxUpTime = maxUpTime > upTime ? maxUpTime : upTime;

                    //NSLog(@"%d's UpTime in up state: %d",numberOfOutput++,upTime);

                    // ==========================================================
                    // count top value
                    topValue = current > topValue ? current : topValue;
                    break;
                }
                case DOWN:{
                    if (upTime > 5) {  // Found six up in sequence
                        state = UP;
                    }
                    //NSLog(@"%d's UpTime in down state: %d",numberOfOutput++,upTime);
                    break;
                }
                case EVEN:
                    // ==========================================================
                    // reset down time when singleUp >= 3
                    if (singleUp >= 3) {
                        downTime = 0;
                    }
                    if (upTime > 5) {  // Found six up in sequence
                        state = UP;
                    }
                    //NSLog(@"%d's UpTime in even state: %d",numberOfOutput++,upTime);
                    break;
            }
        }
        else{
            // ======================================================
            // When down appear reset single up and evenTime
            singleUp = 0;
            evenTime = 0;

            // ======================================================
            // Duration extend by one
            singleDown++;
            downTime++;

            switch (state) {
                case UP:{
                    if (downTime > 5) { // Found six down in sequence
                        state = DOWN;
                    }
                    //NSLog(@"%d's downTime in up state: %d",numberOfOutput++,downTime);
                    break;
                }
                case DOWN:{// start dropping
                           // ==========================================================
                           // reset up time when single down >= 3
                    if (singleDown >= 3) {
                        upTime = 0;
                    }

                    // ==========================================================
                    // count max downtime
                    maxdownTime = maxdownTime > downTime ? maxdownTime :downTime;

                    // ==========================================================
                    // reset max up time
                    stepTime = stepTime < maxUpTime ? maxUpTime : stepTime; // keep stepTime equal to old max up time
                    maxUpTime = 0;
                    //NSLog(@"In down state, stepTime is: %d",stepTime);

                    //NSLog(@"%d's downTime in down state: %d",numberOfOutput++,downTime);
                    break;
                }
                case EVEN:{
                    // ==========================================================
                    // reset up time when single down >= 3
                    if (singleDown >= 3) {
                        upTime = 0;
                    }
                    if (downTime > 5) { // Found six down in sequence
                        state = DOWN;
                    }
                    //NSLog(@"%d's downTime in even state: %d",numberOfOutput++,downTime);
                    break;
                }
            }
        }
        last = current;
    }
    else{
        last = current;
    }
}

// ==========================================
// For walking the topValue smaller than 4.0
-(void)stepTracer:(CMAcceleration)acceleration
{
    float current = (acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z);

    // Unmove for 1 second, speed reset to 0
    stopTimer++;
    if (stopTimer >= 100) {
        self.speed = 0;
        stopTimer = 0;
    }



    if (last !=  0) {
        //NSLog(@"compare last:%f and current:%f",last, current);
        if (current <= last + 0.01 && current >= last - 0.01) { // even line
            last = current;
        }
        if (current == last) {
            //NSLog(@"%d's even",numberOfOutput++);
            evenTime++;
            // Four even in sequence
            if (evenTime > 3) {
                // ==========================================================
                // reset stepTime and top value
                topValue = 1;
                stepTime = 0;
                maxdownTime = 0;
                maxUpTime = 0;
                upTime = 0;
                downTime = 0;
                singleUp = 0;
                singleDown = 0;

                // ==========================================================
                // Change state to even
                state = EVEN;
                evenTime = 0;
            }
        }
        else if (current > last) {
            // ======================================================
            // When up appear reset single down and evenTime
            singleDown = 0;
            evenTime = 0;

            // ======================================================
            // Duration extend by one
            singleUp++;
            upTime++;

            switch (state) {
                case UP:{// start climbing
                         // ==========================================================
                         // reset down time when singleUp >= 3
                    if (singleUp >= 3) {
                        downTime = 0;
                    }

                    // ==========================================================
                    // reset max down time
                    stepTime = (maxdownTime != 0) ? stepTime + maxdownTime : 0;
                    maxdownTime = 0;

                    //NSLog(@"In up state, stepTime is: %d",stepTime);
                    //NSLog(@"top value is: %f",topValue);
                    //=========================================================
                    // Check the last climb time and update foot step
                    if (stepTime >= 20 && topValue >= 1.50 && topValue <= 4.0) {
                        //=========================================================
                        // Generate output which will return at the end of this function
                        self.speed = topValue * stepTime * K / 30.0;
                        self.step++;

                        //=========================================================
                        // Reset stop sener and variable for counting speed
                        stopTimer = 0;
                        topValue = 1;
                        stepTime = 0;
                    }

                    // ==========================================================
                    // count max uptime
                    maxUpTime = maxUpTime > upTime ? maxUpTime : upTime;

                    //NSLog(@"%d's UpTime in up state: %d",numberOfOutput++,upTime);

                    // ==========================================================
                    // count top value
                    topValue = current > topValue ? current : topValue;
                    break;
                }
                case DOWN:{
                    if (upTime > 5) {  // Found six up in sequence
                        state = UP;
                    }
                    //NSLog(@"%d's UpTime in down state: %d",numberOfOutput++,upTime);
                    break;
                }
                case EVEN:
                    // ==========================================================
                    // reset down time when singleUp >= 3
                    if (singleUp >= 3) {
                        downTime = 0;
                    }
                    if (upTime > 5) {  // Found six up in sequence
                        state = UP;
                    }
                    //NSLog(@"%d's UpTime in even state: %d",numberOfOutput++,upTime);
                    break;
            }
        }
        else{
            // ======================================================
            // When down appear reset single up and evenTime
            singleUp = 0;
            evenTime = 0;

            // ======================================================
            // Duration extend by one
            singleDown++;
            downTime++;

            switch (state) {
                case UP:{
                    if (downTime > 5) { // Found six down in sequence
                        state = DOWN;
                    }
                    //NSLog(@"%d's downTime in up state: %d",numberOfOutput++,downTime);
                    break;
                }
                case DOWN:{// start dropping
                           // ==========================================================
                           // reset up time when single down >= 3
                    if (singleDown >= 3) {
                        upTime = 0;
                    }

                    // ==========================================================
                    // count max downtime
                    maxdownTime = maxdownTime > downTime ? maxdownTime :downTime;

                    // ==========================================================
                    // reset max up time
                    stepTime = stepTime < maxUpTime ? maxUpTime : stepTime; // keep stepTime equal to old max up time
                    maxUpTime = 0;
                    //NSLog(@"In down state, stepTime is: %d",stepTime);

                    //NSLog(@"%d's downTime in down state: %d",numberOfOutput++,downTime);
                    break;
                }
                case EVEN:{
                    // ==========================================================
                    // reset up time when single down >= 3
                    if (singleDown >= 3) {
                        upTime = 0;
                    }
                    if (downTime > 5) { // Found six down in sequence
                        state = DOWN;
                    }
                    //NSLog(@"%d's downTime in even state: %d",numberOfOutput++,downTime);
                    break;
                }
            }
        }
        last = current;
    }
    else{
        last = current;
    }
}

- (float) getSpeed{
    return self.speed;
}
- (int) getStep{
    return self.step;
}
@end
