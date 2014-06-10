//
//  dmFirstScreenViewController.h
//  Vocxod
//
//  Created by Дмитрий on 08.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface dmFirstScreenViewController : UIViewController
@property (nonatomic, strong) MBProgressHUD *progress;

- (void)setProgressTitle:(NSString *)title;
@end
