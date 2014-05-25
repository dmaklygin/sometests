//
//  dmTournamentTableViewCell.h
//  Vocxod
//
//  Created by Dmitry Maklygin on 15.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dmTournamentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTournamentName;

- (void)setActive;

@end
