//
//  StepCounterViewController.m
//  circleProcessView
//
//  Created by mike yang on 11/28/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import "StepCounterViewController.h"

@interface StepCounterViewController ()

@end

@implementation StepCounterViewController

static int const AverageWeight = 70;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // ================================================================
    // Setup background image
    self.view.layer.contents = (id)[UIImage imageNamed:@"walkingBackground.jpg"].CGImage;

    // ================================================================
    // Hide exercising bar button
    self.walkingLabel.title = @"";

    // ================================================================
    // Initialize properties
	self.step = 0;
    self.speed = 0;
    self.calories = 0;
    self.myAlgorithm = [[FitnessAlgorithm alloc] init];
    self.myTrackController = [[CaloryTrackController alloc]init];

    self.stepNumberLabel.text = [NSString stringWithFormat:@"%d",self.step];
    self.CaloriesLabel.text = [NSString stringWithFormat:@"%.1f",self.calories];
    self.speedLabel.text = [NSString stringWithFormat:@"%.1f",self.speed];

    self.averageSpeed = 0;
    self.currentSecond = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)StartWalking:(id)sender {
    // ================================================================
    // Show exercising bar button
    self.walkingLabel.title = @"Walking..";
    // ================================================================
    // Start timer to updateStep
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(updateStep) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0.25]];
    [self.myAlgorithm startStepTracer];
}

// =====================================================================
// FinishWalking
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"finishWalking:"]){
        // ================================================================
        // Hide exercising bar button
        self.walkingLabel.title = @"";

        [self.timer invalidate];
        [self.myAlgorithm stopStepAndSpeedTracer];
        self.step = 0;
        self.speed = 0;
        
        self.stepNumberLabel.text = [NSString stringWithFormat:@"%d",self.step];
        self.CaloriesLabel.text = [NSString stringWithFormat:@"%.1f",0.0];
        self.speedLabel.text = [NSString stringWithFormat:@"%.1f",self.speed];

        // =====================================================================
        // Add into CoreData
        //[self.myTrackController deleteAllTracks];
        //[self.myTrackController createSevealNewTracks];
        [self.myTrackController updateCaloriesToCoreData: self.calories];

    }
}


// ======================================================================
// The speed and step tracer we are using is 100HZ
// We setup the frequency of updating speed and step here is 20 HZ
// Which means every five number generate from tracer we take 1 number from it
// Also we setup the update of averageSpeed and calories as 0.2 HZ, which means
// we calculate the average speed in every 100 speed and use it to update calories
static int const Frequency = 20; // 20HZ
- (void) updateStep{
    //NSLog(@"In updateStep in waling view, weight is :%.1f",[self.weight floatValue]);
    self.step = [self.myAlgorithm getStep];
    self.speed = [self.myAlgorithm getSpeed];
    self.stepNumberLabel.text = [NSString stringWithFormat:@"%d",self.step];

    self.currentSecond++;
    self.averageSpeed = self.averageSpeed + self.speed;

    if (self.currentSecond >= 100) {
        // ======================================================================
        // Update averageSpeed every five seconds
        self.averageSpeed = self.averageSpeed / 100;
        self.speedLabel.text = [NSString stringWithFormat:@"%.1f",self.averageSpeed];

        // ======================================================================
        // Update calories
        float met = [self.myAlgorithm calculateMetByAverageSpeed:self.averageSpeed];
        float caloriesPerSecond = [self.myAlgorithm calculateCaloriesBurnByRunningPerMinit_weightInPound:[self.weight floatValue] met:met];
        self.calories = self.calories + caloriesPerSecond * 100 / Frequency;
        self.CaloriesLabel.text = [NSString stringWithFormat:@"%.1f",self.calories];

        self.averageSpeed = 0;
        self.currentSecond = 0;
    }
}

// =====================================================================
// FinishWalking before dismiss
- (void)viewDidDisappear:(BOOL)animated
{
    if (self.parentViewController == nil) {
        NSLog(@"StepCounter view pops up");
        //release stuff here
        [self.timer invalidate];
        [self.myAlgorithm stopStepAndSpeedTracer];
    } else {
        NSLog(@"StepCounter view just hidden");
    }
}

-(void) setWeight:(NSNumber *)weight{
    _weight = weight;
}


- (IBAction)didSwipeRight:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
