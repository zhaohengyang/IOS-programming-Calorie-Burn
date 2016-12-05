//
//  StepCounterViewController.h
//  circleProcessView
//
//  Created by mike yang on 11/28/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//


#import "FitnessAlgorithm.h"
#import "CaloryTrackController.h"

@interface StepCounterViewController : UIViewController
@property (nonatomic, assign) int step;
@property (nonatomic, assign) float speed;
//@property (nonatomic, assign) float weight;
@property (nonatomic, assign) float calories;

@property (nonatomic, assign) float averageSpeed;
@property (nonatomic, assign) int currentSecond;

@property (strong,nonatomic) NSTimer* timer;
@property (strong,nonatomic) FitnessAlgorithm* myAlgorithm;
@property (strong,nonatomic) CaloryTrackController* myTrackController;

@property (weak, nonatomic) IBOutlet UILabel *stepNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *CaloriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *walkingLabel;

// Get from MusicPlayerViewController
@property (strong,nonatomic) NSNumber* weight;
-(void) setWeight:(NSNumber *)weight;
@end
