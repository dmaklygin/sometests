//
//  dmFirstScreenViewController.m
//  Vocxod
//
//  Created by Дмитрий on 08.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmFirstScreenViewController.h"

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
    
    self.progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.progress];
    [self setProgressTitle:@"Loading..."];
    self.progress.opacity = 0.0f;
    
    [self.progress show:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setProgressTitle:(NSString *)title
{
    self.progress.labelText = title;
}

@end
