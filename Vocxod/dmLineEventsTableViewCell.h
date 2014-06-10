//
//  dmLineEventsTableViewCell.h
//  Vocxod
//
//  Created by Дмитрий on 09.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface dmLineEventsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelHome;
@property (strong, nonatomic) IBOutlet UILabel *labelAway;
@property (strong, nonatomic) IBOutlet UILabel *labelDate;

- (void)configureCell:(Event *)event;
@end
