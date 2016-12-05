//
//  AccountController.m
//  TrackCaloryBurn
//
//  Created by mike yang on 11/30/13.
//  Copyright (c) 2013 mike yang. All rights reserved.
//

#import "AccountController.h"

@implementation AccountController

+ (void) createSevealNewAccountsAndPrintOut{

    NSString *userName = [NSString stringWithFormat:@"user%d",1];
    NSString *password = [NSString stringWithFormat:@"user%d",1234];
    NSNumber *weight = [NSNumber numberWithFloat:75];

    [AccountController createNewAccountWithUserName:userName password:password weight:weight];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Account" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    NSArray *accounts =
    [managedObjectContext executeFetchRequest:fetchRequest error:&requestError];


    if ([accounts count] > 0){
        // =================================================================
        // Print out each track
        NSUInteger counter = 1;
        for (Account *thisAccount in accounts){
            NSLog(@"\n username: %@ \t password = %@ \t weight = %.1f",
                  thisAccount.userName,
                  thisAccount.password,
                  [thisAccount.weight floatValue]);
            counter++;
        }
    }

}

+ (BOOL)createNewAccountWithUserName:(NSString*) userName password:(NSString*)password weight:(NSNumber*) weight{

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;

    Account *newAccount = (Account*)[NSEntityDescription insertNewObjectForEntityForName:@"Account"
                                                          inManagedObjectContext:managedObjectContext];
    if (newAccount == nil){
        NSLog(@"Failed to create a new Account.");
        return NO;
    }
    else{
        newAccount.userName = [NSString stringWithString:userName];
        newAccount.password = [NSString stringWithString:password];
        newAccount.weight = [NSNumber numberWithFloat:[weight floatValue]];
        NSError *savingError = nil;
        if ([managedObjectContext save:&savingError]){
            return YES;
            NSLog(@"New account create sucessfully");
        }
        else {
            NSLog(@"Failed to save the new Account. Error = %@", savingError);
            return NO;
        }
    }
}

+ (BOOL)isUserNameExist:(NSString*)username{

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Account" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    NSArray *accounts =
    [managedObjectContext executeFetchRequest:fetchRequest error:&requestError];


    if ([accounts count] > 0){
        // =================================================================
        // Print out each track
        NSUInteger counter = 1;
        for (Account *thisAccount in accounts){
            if ([thisAccount.userName isEqualToString:username]) {
                return true;
            }
            counter++;
        }
    }
    return false;
}

+ (BOOL)isAccountExist:(NSString*)username password:(NSString*) password{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Account" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    NSArray *accounts =
    [managedObjectContext executeFetchRequest:fetchRequest error:&requestError];


    if ([accounts count] > 0){
        // =================================================================
        // Print out each track
        NSUInteger counter = 1;
        for (Account *thisAccount in accounts){
            if ([thisAccount.userName isEqualToString:username]) {
                if ([thisAccount.password isEqualToString:password]) {
                    return true;
                }
                else
                    return false;
            }
            counter++;
        }
    }
    return false;
}

+ (NSNumber*) getUserWeight:(NSString*)username{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Account" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    NSArray *accounts =
    [managedObjectContext executeFetchRequest:fetchRequest error:&requestError];


    if ([accounts count] > 0){
        // =================================================================
        // Check each track's username
        NSUInteger counter = 1;
        for (Account *thisAccount in accounts){
            if ([thisAccount.userName isEqualToString:username]) {
                return thisAccount.weight;
            }
            counter++;
        }
    }
    return Nil;
}

+ (void) updateUserWeight:(NSString*)username weight:(NSNumber*) weight{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Account" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    NSArray *accounts =
    [managedObjectContext executeFetchRequest:fetchRequest error:&requestError];


    if ([accounts count] > 0){
        // =================================================================
        // Check each track's username
        NSUInteger counter = 1;
        for (Account *thisAccount in accounts){
            if ([thisAccount.userName isEqualToString:username]) {
                // =================================================================
                // Update weight and save context
                thisAccount.weight = weight;

                NSError *savingError = nil;
                if ([managedObjectContext save:&savingError]){
                    NSLog(@"Successfully saved the context.");
                }
                else {
                    NSLog(@"Failed to save the context.");
                }
                return;
            }
            counter++;
        }
        NSLog(@"Couldn't find user name, logic could be wrong!");
    }
}

+ (void) printOutEachAccount{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Account" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    NSArray *accounts =
    [managedObjectContext executeFetchRequest:fetchRequest error:&requestError];


    if ([accounts count] > 0){
        // =================================================================
        // Print out each track
        NSUInteger counter = 1;
        for (Account *thisAccount in accounts){
            NSLog(@"\n username: %@ \t password = %@ \t weight = %.1f",
                  thisAccount.userName,
                  thisAccount.password,
                  [thisAccount.weight floatValue]);
            counter++;
        }
    }
}
+ (void) deleteAllAccounts{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Account" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    NSArray *accounts =
    [managedObjectContext executeFetchRequest:fetchRequest error:&requestError];

    if ([accounts count] > 0){
        // =================================================================
        // Print out each track
        NSUInteger counter = 1;
        for (Account *thisAccount in accounts){
            [managedObjectContext deleteObject:thisAccount];
            counter++;
        }
        NSLog(@"All accounts deleted");
        NSError *savingError = nil;
        if ([managedObjectContext save:&savingError]){
            NSLog(@"Successfully saved the context.");
        }
        else {
            NSLog(@"Failed to save the context.");
        }
    }
    else{
        NSLog(@"Nothing to deleted");
    }
}

@end
