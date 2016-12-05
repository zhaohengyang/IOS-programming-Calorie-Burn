//
//  WelcomeViewController.m
//  TrackCaloryBurn
//
//  Created by mike yang on 12/7/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

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
    self.view.layer.contents = (id)[UIImage imageNamed:@"welcomeBackground.jpg"].CGImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setUserName:(NSString*) userName{
    _userName = userName;
    _weight = [AccountController getUserWeight:userName];
    NSLog(@"userName : %@", _userName);
    NSLog(@"weight : %.1f",[_weight floatValue]);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"prepareForSegue called");
    NSLog(@"In music view, weight is:%.1f",[self.weight floatValue]);

    if ([segue.destinationViewController respondsToSelector:@selector(setWeight:)]){
        [segue.destinationViewController performSelector:@selector(setWeight:) withObject:self.weight];
    }
    if ([segue.identifier isEqualToString:@"updateWeight:"]){
        if ([segue.destinationViewController respondsToSelector:@selector(setUserName:)]){
            [segue.destinationViewController performSelector:@selector(setUserName:) withObject:self.userName];
        }
    }
}


- (IBAction)didSwipeRight:(UISwipeGestureRecognizer *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
