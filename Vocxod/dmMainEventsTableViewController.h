//
//  dmMainTournamentsTableViewController.h
//  Vocxod
//
//  Created by Дмитрий on 15.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmEventsTableViewController.h"
#import "dmSport.h"

@interface dmMainEventsTableViewController : dmEventsTableViewController

@property (nonatomic,strong) dmSport *sport;

- (instancetype)initWithSport:(dmSport *)sport;

@end
