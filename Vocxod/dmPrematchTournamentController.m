//
//  dmPrematchTournamentController.m
//  Vocxod
//
//  Created by Дмитрий on 11.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmPrematchTournamentController.h"

@implementation dmPrematchTournamentController

+ (instancetype)instance
{
    static dmPrematchTournamentController *_prematchController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _prematchController = [[dmPrematchTournamentController alloc] initWithParams:@{@"command": @"line"}];
    });
    
    return _prematchController;
}

@end
