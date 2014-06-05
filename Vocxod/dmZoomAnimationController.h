//
//  dmZoomAnimationController.h
//  Vocxod
//
//  Created by Дмитрий on 05.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECSlidingViewController.h"

@interface dmZoomAnimationController : NSObject <UIViewControllerAnimatedTransitioning,
ECSlidingViewControllerDelegate,
ECSlidingViewControllerLayout>

@end
