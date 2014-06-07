//
//  dmFirstScreenViewController.m
//  Vocxod
//
//  Created by Дмитрий on 08.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmFirstScreenViewController.h"
#import "MBProgressHUD.h"

@interface dmFirstScreenViewController ()

@end

@implementation dmFirstScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.userInteractionEnabled = NO;
    
    MBProgressHUD *progressView = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progressView];
    progressView.labelText = @"Loading";
    progressView.opacity = 0.0f;
    
    [progressView show:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
