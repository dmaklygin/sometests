//
//  dmCouponTableViewController.h
//  Vocxod
//
//  Created by Dmitry Maklygin on 26.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "Bet.h"

@interface dmCouponTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
