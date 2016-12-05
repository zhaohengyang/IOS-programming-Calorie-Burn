//
//  SignUpViewController.m
//  TrackCaloryBurn
//
//  Created by mike yang on 11/30/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

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
    self.view.layer.contents = (id)[UIImage imageNamed:@"signUpBackground.jpg"].CGImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)processSignUp:(id)sender {

    //[self.myController deleteAllAccounts];
    NSNumber* weight;
    BOOL doReturn = true;
    NSLog(@"processing user sign up");
    // =======================================================================
    // Check if any input is empty
    if ([_userNameLabel.text isEqualToString:@""] || [_passwordLabel.text isEqualToString: @""] ||
        [_passwordRepeatLabel.text isEqualToString: @""] ||
        [_weightLabel.text isEqualToString:@""]
        ) {


        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty textfield"
            message:@"Please fill all the text field"
            delegate:nil
            cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        doReturn = false;
    }
    // =======================================================================
    // Check if the username is already exist
    else if([AccountController isUserNameExist:_userNameLabel.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UserName"
                                                        message:@"The username is already exist, please input another one"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        doReturn = false;
    }
    // =======================================================================
    // Check if two password field are same
    else if(!([_passwordLabel.text isEqualToString:_passwordRepeatLabel.text])){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password are not same"
                                                        message:@"Please input same password twice"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        doReturn = false;
    }
    else{
        // =======================================================================
        // Check if the input weight only contains numbers and "." charactor
        NSString *weightString = [NSString stringWithString:_weightLabel.text];
        NSCharacterSet *decimalSet = [NSCharacterSet decimalDigitCharacterSet];
        BOOL stringIsValid = ([[weightString stringByTrimmingCharactersInSet:decimalSet] isEqualToString:@""] ||
                              [[weightString stringByTrimmingCharactersInSet:decimalSet] isEqualToString:@"."]);
        if (!stringIsValid) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong type of input"
                                                            message:@"Please input a number as your weight"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];

            doReturn = false;
        }
        // =======================================================================
        // Check if the input weight is 0
        else if([weightString floatValue] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Weight is 0"
                                                            message:@"Please input a nonzero number"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            doReturn = false;
        }
        else{
            weight = [NSNumber numberWithFloat:[weightString floatValue]];
        }
    }
    if (doReturn) {
        [AccountController createNewAccountWithUserName:_userNameLabel.text password:_passwordLabel.text weight:weight];
        [AccountController printOutEachAccount];
        [self performSegueWithIdentifier:@"unwindToLogIn:" sender:self];
    }
     

}
- (IBAction)backgroundTouched:(id)sender {
    [_userNameLabel resignFirstResponder];
    [_passwordLabel resignFirstResponder];
    [_passwordRepeatLabel resignFirstResponder];
    [_weightLabel resignFirstResponder];
}

- (IBAction)hideKeyboard:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)didSwipeRight:(UISwipeGestureRecognizer *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
