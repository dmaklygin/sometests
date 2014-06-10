//
//  dmLiveEventsTableViewCell.h
//  Vocxod
//
//  Created by Дмитрий on 09.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface dmLiveEventsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelHome;
@property (strong, nonatomic) IBOutlet UILabel *labelAway;
@property (strong, nonatomic) IBOutlet UILabel *labelTime;
@property (strong, nonatomic) IBOutlet UILabel *labelScore;

- (void)configureCell:(Event *)event;
@end
