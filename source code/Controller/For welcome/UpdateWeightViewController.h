//
//  UpdateWeightViewController.h
//  TrackCaloryBurn
//
//  Created by mike yang on 12/7/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountController.h"
@interface UpdateWeightViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (strong, nonatomic) NSString* userName;
- (void) setUserName:(NSString*) userName;
@end
