//
//  dmCouponSingleCellViewTableViewCell.h
//  Vocxod
//
//  Created by Дмитрий on 29.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dmCouponSingleViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelOutcomeName;
@property (strong, nonatomic) IBOutlet UILabel *labelHome;
@property (strong, nonatomic) IBOutlet UILabel *labelAway;
@property (strong, nonatomic) IBOutlet UILabel *labelMin;
@property (strong, nonatomic) IBOutlet UILabel *labelMax;
@property (strong, nonatomic) IBOutlet UILabel *labelCoefficientValue;
@property (strong, nonatomic) IBOutlet UITextField *textFieldBetValue;
- (IBAction)betValueChanged:(id)sender;

@end
