//
//  dmTournamentTableViewCell.m
//  Vocxod
//
//  Created by Dmitry Maklygin on 15.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmTournamentTableViewCell.h"

@implementation dmTournamentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setActive
{
    [self setBackgroundColor:[UIColor redColor]];
}

@end
