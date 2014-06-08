//
//  dmLiveEventsTableViewController.h
//  Vocxod
//
//  Created by Дмитрий on 19.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

//#import <CoreData/CoreData.h>
#import "dmTournament.h"
//#import "Event.h"
#import "dmEventsTableViewController.h"


@interface dmLiveEventsTableViewController : dmEventsTableViewController
@property (nonatomic,strong) dmTournament *tournament;
@end
