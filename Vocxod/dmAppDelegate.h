//
//  dmAppDelegate.h
//  Vocxod
//
//  Created by Дмитрий on 13.04.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dmSportController.h"
#import "dmOutcomesController.h"
#import "dmTournamentController.h"

@interface dmAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) dmSportController *sportController;
@property (nonatomic, strong) dmOutcomesController *outcomesController;
@property (nonatomic, strong) dmTournamentController *prematchTournamentController;
@property (nonatomic, strong) dmTournamentController *liveTournamentController;
@end
