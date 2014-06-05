//
//  dmMainViewController.h
//  Vocxod
//
//  Created by Дмитрий on 14.04.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

@interface dmMainViewController : UIViewController <ECSlidingViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;
- (IBAction)unwindToMenu:(id)sender;

@end
