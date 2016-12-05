//
//  UpdateWeightViewController.m
//  TrackCaloryBurn
//
//  Created by mike yang on 12/7/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import "UpdateWeightViewController.h"

@interface UpdateWeightViewController ()

@end

@implementation UpdateWeightViewController

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
    self.view.layer.contents = (id)[UIImage imageNamed:@"updateWeightBackground.jpg"].CGImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)updateUserWeight:(id)sender {
    NSString *weightString = [NSString stringWithString:_weightTextField.text];
    NSCharacterSet *decimalSet = [NSCharacterSet decimalDigitCharacterSet];
    BOOL stringIsValid = ([[weightString stringByTrimmingCharactersInSet:decimalSet] isEqualToString:@""] ||
                          [[weightString stringByTrimmingCharactersInSet:decimalSet] isEqualToString:@"."]);
    if (!stringIsValid) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong type of input"
                                                        message:@"Please input a number as your weight"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    // =======================================================================
    // Check if the input weight is 0
    else if([weightString floatValue] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Weight is 0"
                                                        message:@"Please input a nonzero number"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else{
        NSNumber* weight = [NSNumber numberWithFloat:[weightString floatValue]];
        [AccountController updateUserWeight:_userName weight:weight];
        NSNumber* result = [AccountController getUserWeight:_userName];
        _resultLabel.text = [NSString stringWithFormat:@"Your weight is %.1f",[result floatValue]];

    }
    [sender resignFirstResponder];
}


- (IBAction)backgroundTouched:(id)sender {
    [_weightTextField resignFirstResponder];
}


- (void) setUserName:(NSString*) userName{
    _userName = userName;
    NSLog(@"userName is %@ in updateWeightViewController", _userName);
}
- (IBAction)didSwipeRight:(UISwipeGestureRecognizer *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
