//
//  dmLiveTournamentController.m
//  Vocxod
//
//  Created by Дмитрий on 11.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmLiveTournamentController.h"

@implementation dmLiveTournamentController
+ (instancetype)instance
{
    static dmLiveTournamentController *_liveController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _liveController = [[dmLiveTournamentController alloc] initWithParams:@{@"command": @"live"}];
    });
    
    return _liveController;
}

@end
