//
//  CircleProcessViewController.m
//  circleProcessView
//
//  Created by mike yang on 11/17/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import "CircleProcessViewController.h"

@interface CircleProcessViewController ()

@end

@implementation CircleProcessViewController

static int const AverageWeight = 70;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // ================================================================
    // Setup background image
    self.view.layer.contents = (id)[UIImage imageNamed:@"runningBackground.jpg"].CGImage;

    UIColor *backColor = [UIColor colorWithRed:236.0/255.0
                                         green:236.0/255.0
                                          blue:236.0/255.0
                                         alpha:1.0];
    UIColor *progressColor = [UIColor colorWithRed:82.0/255.0
                                             green:135.0/255.0
                                              blue:237.0/255.0
                                             alpha:1.0];

    //alloc CircularProgressView instance
    self.myOvalProcessView = [[OvalProcessView alloc] initWithFrame:CGRectMake(41, 57, 238, 238)
                                                                  backColor:backColor
                                                              progressColor:progressColor
                                                                  lineWidth:20];
    [self.view addSubview:self.myOvalProcessView];

    
    self.myAlgorithm = [[FitnessAlgorithm alloc] init];
    self.myTrackController = [[CaloryTrackController alloc]init];

    // ================================================================
    // Hide exercising bar button
    self.runningBarLabel.title = @"";

    // ======================================================================
    // Initialize properties
    self.speed = 0;
    self.distance = 0;
    self.calories = 0;
    self.circles = 0;
    
}


- (IBAction)StartRunning:(id)sender {
    // ================================================================
    // Show exercising bar button
    self.runningBarLabel.title = @"Running...";

    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(updateSpeed) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0.25]];
    [self.myAlgorithm startSpeedTracer];
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"finishRunning:"]){
        // ================================================================
        // Hide exercising bar button
        self.runningBarLabel.title = @"";
        
        [self.timer invalidate];
        [self.myAlgorithm stopStepAndSpeedTracer];

        self.speed = 0;
        self.distance = 0;
        self.circles = 0;

        self.currentSpeedLabel.text = [NSString stringWithFormat:@"%.1f",self.speed];
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1f", self.distance];
        self.caloriesBurnLabel.text = [NSString stringWithFormat:@"%.1f", 0.0];
        self.circlesLabel.text = [NSString stringWithFormat:@"%d",self.circles];

        self.currentSecond = 0;
        self.averageSpeed = 0;

        // =====================================================================
        // Add into CoreData
        //[self.myTrackController deleteAllTracks];
        //[self.myTrackController createSevealNewTracks];
        [self.myTrackController updateCaloriesToCoreData: self.calories];
        
    }
}
// ======================================================================
// The speed and step tracer we are using is 100HZ
// We setup the frequency of updating speed and distance in 20 HZ
// This means every five number generate from tracer we take 1 number from it
// Also we setup the update of averageSpeed and calories as 0.2 HZ, which means
// we calculate the average speed in every 100 speed and use it to update calories
static int const Frequency = 20; // 20HZ


- (void) updateSpeed{
    //NSLog(@"In updateSpeed in runing view, weight is :%.1f",[self.weight floatValue]);
    self.speed = [self.myAlgorithm getSpeed];
    self.currentSecond++;
    self.averageSpeed = self.averageSpeed + self.speed;

    //NSLog(@"%d",[self.myAlgorithm getStep]);
    //NSLog(@"%.1f",[self.myAlgorithm getSpeed]);

    // ======================================================================
    // Get the distance achieved in this time interval and add it to the whole distance
    float distanceOfRunningInCurrentFrequency = (self.speed * 1609 / 3600) / Frequency;
    self.distance = self.distance + distanceOfRunningInCurrentFrequency; // Change distance to meters
    self.circles = self.distance / 400;

    // ======================================================================
    // Get distance in current circle and redraw ovalProcessView
    float d = fmod(self.distance, 400);
    [self.myOvalProcessView updateProgressCircle:d];

    // ======================================================================
    // Update averageSpeed and calories every five seconds
    if (self.currentSecond >= 100) {
        self.averageSpeed = self.averageSpeed / 100;
        float met = [self.myAlgorithm calculateMetByAverageSpeed:self.averageSpeed];
        self.calories = self.calories + [self.myAlgorithm calculateCaloriesBurnByRunningPerMinit_weightInPound:[self.weight floatValue] met:met] * 100 / Frequency;

        self.currentSpeedLabel.text = [NSString stringWithFormat:@"%.1f",self.averageSpeed];
        
        self.currentSecond = 0;
        self.averageSpeed = 0;
    }

    // ======================================================================
    // Update labels
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1f", self.distance];
    self.caloriesBurnLabel.text = [NSString stringWithFormat:@"%.1f", self.calories];
    self.circlesLabel.text = [NSString stringWithFormat:@"%d",self.circles];
}

// =====================================================================
// Finish running before dismiss
- (void)viewDidDisappear:(BOOL)animated
{
    if (self.parentViewController == nil) {
        NSLog(@"CircleProcess view pops up");
        //release stuff here
        [self.timer invalidate];
        [self.myAlgorithm stopStepAndSpeedTracer];
    } else {
        NSLog(@"CircleProcess view just hidden");
    }
}

-(void) setWeight:(NSNumber *)weight{
    _weight = weight;
}

- (IBAction)didSwipeRight:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
@end
