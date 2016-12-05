//
//  CircleProcessViewController.h
//  circleProcessView
//
//  Created by mike yang on 11/17/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OvalProcessView.h"
#import "FitnessAlgorithm.h"

#import "CaloryTrackController.h"

@interface CircleProcessViewController : UIViewController

@property (nonatomic) OvalProcessView *myOvalProcessView;
@property (strong,nonatomic) FitnessAlgorithm* myAlgorithm;
@property (strong,nonatomic) CaloryTrackController* myTrackController;

@property (weak, nonatomic) IBOutlet UILabel *currentSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *circlesLabel;
@property (weak, nonatomic) IBOutlet UILabel *caloriesBurnLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *runningBarLabel;

@property (nonatomic) NSTimer *timer;

@property (nonatomic) float speed; // miles per hour
@property (nonatomic) float distance; // meter
                                      //@property (nonatomic) float weight; // Kg
@property (nonatomic) float calories;
@property (nonatomic) int circles;

@property (nonatomic,assign) int currentSecond;
@property (nonatomic,assign) float averageSpeed;

- (IBAction)StartRunning:(id)sender;
- (IBAction)takeABreak:(id)sender;
- (IBAction)StopRunning:(id)sender;

// Get from MusicPlayerViewController
@property (strong,nonatomic) NSNumber* weight;

-(void) setWeight:(NSNumber *)weight;
@end
