//
//  dmMainViewController.m
//  Vocxod
//
//  Created by Дмитрий on 14.04.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//
#import "UIViewController+ECSlidingViewController.h"
#import "dmMainViewController.h"


@interface dmMainViewController ()

@end

@implementation dmMainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)unwindToMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}
@end
