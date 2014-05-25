//
//  dmEventTableViewCell.h
//  Vocxod
//
//  Created by Dmitry Maklygin on 14.04.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dmEventTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelHome;
@property (weak, nonatomic) IBOutlet UILabel *labelAway;
@property (weak, nonatomic) IBOutlet UILabel *labelScore;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@end
