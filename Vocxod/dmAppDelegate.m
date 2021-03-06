//
//  dmAppDelegate.m
//  Vocxod
//
//  Created by Дмитрий on 13.04.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//
#import "dmAppDelegate.h"
#import "dmModelController.h"

#import "dmMainSettings.h"
#import "dmPrematchTournamentController.h"
#import "dmLiveTournamentController.h"


@interface dmAppDelegate()

@end


@implementation dmAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self showLoadingScreen];
    
    [self initApplication];
    
    return YES;
}

- (void)initApplication
{    
    self.sportController = [[dmSportController alloc] initWithManagedObjectContext:self.managedObjectContext];
    [self.firstController setProgressTitle:@"Loading Sports"];
    [self.sportController loadData:^(NSArray *sports, NSError *error) {
        
        if (error != nil) {
            [self handleError:error];
            return;
        }
        
        self.outcomesController = [[dmOutcomesController alloc] initWithManagedObjectContext:self.managedObjectContext];
        [self.firstController setProgressTitle:@"Loading Outcomes"];
        [self.outcomesController loadRemoteOutcomes:^(NSDictionary *data, NSError *error) {

            if (error != nil) {
                [self handleError:error];
                return;
            }
            
            [self.firstController setProgressTitle:@"Loading Settings"];
            [[dmMainSettings instance] loadSettings:^(NSDictionary *settings, NSError *error) {
                if (error != nil) {
                    [self handleError:error];
                    return;
                }
                
                // Loading Prematch Tournaments
                [self.firstController setProgressTitle:@"Loading Prematch"];
                [[dmPrematchTournamentController instance] loadRemoteTournaments:^(NSArray *tournaments, NSError *error) {
                    if (error != nil) {
                        [self handleError:error];
                        return;
                    }
                    
                    // Loading Live Tournaments
                    [self.firstController setProgressTitle:@"Loading Live"];
                    [[dmLiveTournamentController instance] loadRemoteTournaments:^(NSArray *tournaments, NSError *error) {
                        if (error != nil) {
                            [self handleError:error];
                            return;
                        }
                        
                        [self initSuccess];
                        
                    } inManagedObjectContext:self.managedObjectContext];
                } inManagedObjectContext:self.managedObjectContext];
            }];
        }];
    }];
}

- (void)initSuccess {
    [self hideLoadingScreen];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)showLoadingScreen
{
    self.firstController = [[dmFirstScreenViewController alloc] initWithNibName:@"dmFirstScreenViewController" bundle:nil];
    
    UIViewController *mainUIViewController = (UIViewController *)self.window.rootViewController;
    
    [mainUIViewController.view addSubview:self.firstController.view];
    
}

- (void)hideLoadingScreen
{
    [self.firstController.view removeFromSuperview];
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    _managedObjectContext = [dmModelController managedObjectContext];
    return _managedObjectContext;
}

-(void)handleError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alertView show];
}

@end
