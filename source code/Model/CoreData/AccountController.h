//
//  AccountController.h
//  TrackCaloryBurn
//
//  Created by mike yang on 11/30/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Account.h"
#import "AppDelegate.h"
@interface AccountController : NSObject

+ (BOOL)createNewAccountWithUserName:(NSString*) userName password:(NSString*)password weight:(NSNumber*) weight;
+ (BOOL)isUserNameExist:(NSString*)username;
+ (BOOL)isAccountExist:(NSString*)username password:(NSString*) password;
+ (NSNumber*) getUserWeight:(NSString*)username;
+ (void) updateUserWeight:(NSString*)username weight:(NSNumber*) weight;

+ (void) deleteAllAccounts;
+ (void) createSevealNewAccountsAndPrintOut;
+ (void) printOutEachAccount;
@end
