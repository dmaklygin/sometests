//
//  dmLineEventsTableViewCell.m
//  Vocxod
//
//  Created by Дмитрий on 09.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmLineEventsTableViewCell.h"

@implementation dmLineEventsTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(Event *)event
{
    self.labelAway.text = [event valueForKey:@"away"];
    self.labelHome.text = [event valueForKey:@"home"];
    self.labelDate.text = [event getFormatterDate];
}

@end
