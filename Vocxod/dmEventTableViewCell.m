//
//  dmEventTableViewCell.m
//  Vocxod
//
//  Created by Dmitry Maklygin on 14.04.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmEventTableViewCell.h"

@implementation dmEventTableViewCell

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

@end
