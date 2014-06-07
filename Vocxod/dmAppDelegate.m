//
//  dmAppDelegate.m
//  Vocxod
//
//  Created by Дмитрий on 13.04.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmSport.h"
#import "dmAppDelegate.h"

#import "dmFirstScreenViewController.h"

#import "dmMainSettings.h"
#import "dmUserSettings.h"

@interface dmAppDelegate()

// Properties for the Core Data stack.
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSString *persistentStorePath;

@property (nonatomic, strong) dmFirstScreenViewController *firstController;

- (NSURL *)applicationDocumentsDirectory;
- (void)showLoadingScreen;
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

    [self.sportController loadData:^(NSArray *sports, NSError *error) {
        
        if (error != nil) {
            [self handleError:error];
            return;
        }
        
        self.outcomesController = [[dmOutcomesController alloc] initWithManagedObjectContext:self.managedObjectContext];
        [self.outcomesController loadRemoteOutcomes:^(NSDictionary *data, NSError *error) {
            NSLog(@"upload outcomesController");
            if (error != nil) {
                [self handleError:error];
                return;
            }
            
            [[dmMainSettings instance] loadSettings:^(NSDictionary *settings, NSError *error) {
                if (error != nil) {
                    [self handleError:error];
                    return;
                }
                
                // Инициализация купона
//                [self coupon];
                
                [self initSuccess];
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

- (dmTournamentController *)prematchTournamentController
{
    if (_prematchTournamentController != nil) {
        return _prematchTournamentController;
    }
    
    _prematchTournamentController = [[dmTournamentController alloc] initWithParams:@{@"command": @"line"}];
    
    return _prematchTournamentController;
}

- (dmTournamentController *)liveTournamentController
{
    if (_liveTournamentController != nil) {
        return _liveTournamentController;
    }
    
    _liveTournamentController = [[dmTournamentController alloc] initWithParams:@{@"command": @"live"}];
    
    return _liveTournamentController;
}

- (dmCoupon *)coupon
{
    if (_coupon != nil) {
        return _coupon;
    }
    
    _coupon = [[dmCoupon alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    [_coupon loadBets];
    
    return _coupon;
}

- (NSString *)persistentStorePath {
    if (_persistentStorePath == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths lastObject];
        _persistentStorePath = [documentsDirectory stringByAppendingPathComponent:@"Tournaments.sqlite"];
    }
    return _persistentStorePath;
}

- (BOOL)checkResponse:(NSHTTPURLResponse *)httpResponse
{
    if ((([httpResponse statusCode]/100) == 2) && [[httpResponse MIMEType] isEqual:@"application/json"]){
        return true;
    }
    return false;
}

- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [self persistentStoreCoordinator];
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *managedObjectModel = [self managedObjectModel];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
    NSURL *storeUrl = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Vocxod.CDBStore"];
    NSError *error;
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"Tournaments" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    
    return _managedObjectModel;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


-(void)handleError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alertView show];
}


@end
