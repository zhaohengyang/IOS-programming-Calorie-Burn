//
//  LogInViewController.h
//  TrackCaloryBurn
//
//  Created by mike yang on 11/30/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountController.h"
@interface LogInViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (strong, nonatomic) NSString* userName;
@end
