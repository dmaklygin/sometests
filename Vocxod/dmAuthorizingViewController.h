//
//  dmAuthorizingViewController.h
//  Vocxod
//
//  Created by Дмитрий on 24.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dmAuthorizingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
- (IBAction)onValueChanged:(id)sender;
- (IBAction)sendPhone:(id)sender;

@end
