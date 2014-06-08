//
//  dmFavouritesViewController.m
//  Vocxod
//
//  Created by Дмитрий on 06.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmFavouritesViewController.h"

@interface dmFavouritesViewController ()

@end

@implementation dmFavouritesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Do any additional setup after loading the view
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
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

@end
