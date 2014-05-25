//
//  dmFirstView.m
//  Vocxod
//
//  Created by Dmitry Maklygin on 14.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmFirstView.h"
#import "MBProgressHUD.h"

@implementation dmFirstView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
       
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView: self];
        //HUD.graceTime = 0.5;
        //HUD.minShowTime = 5.0;
        
        // Add HUD to screen
        [self addSubview:HUD];
        
        [HUD show:YES];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
