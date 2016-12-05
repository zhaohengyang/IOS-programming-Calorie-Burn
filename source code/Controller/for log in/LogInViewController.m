//
//  LogInViewController.m
//  TrackCaloryBurn
//
//  Created by mike yang on 11/30/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

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
    self.view.layer.contents = (id)[UIImage imageNamed:@"logInBackground.jpg"].CGImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userDidSignUp:(UIStoryboardSegue* )segue {
    NSLog(@"user's information will be writen into database");
}
- (IBAction)processLogIn:(id)sender {
    BOOL doSegue = true;
    if ([_userNameLabel.text isEqualToString:@""] || [_passwordLabel.text isEqualToString: @""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty textfield"
                                                        message:@"Please input your username and password"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        doSegue = false;
    }
    else if(![AccountController isAccountExist:_userNameLabel.text password:_passwordLabel.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try agian"
                                                        message:@"Sorry, username or password is not correct"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        doSegue = false;
    }
    else{
        self.userName = _userNameLabel.text;
        [self performSegueWithIdentifier:@"didLogIn:" sender:self];
    }

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"prepareForSegue called");
    if ([segue.identifier isEqualToString:@"didLogIn:"]){
        if ([segue.destinationViewController respondsToSelector:@selector(setUserName:)]){
            [segue.destinationViewController performSelector:@selector(setUserName:) withObject:self.userName];
        }
    }

}

- (IBAction)backgroundTouched:(id)sender {
    [_userNameLabel resignFirstResponder];
    [_passwordLabel resignFirstResponder];
}
@end
