//
//  dmFavouritesViewController.m
//  Vocxod
//
//  Created by Дмитрий on 06.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmFavouritesViewController.h"

@implementation dmFavouritesViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)setPredicate:(NSFetchRequest *)fetchRequest
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"in_favourites == %@", @YES];
    [fetchRequest setPredicate:predicate];
}

- (IBAction)onMenuButtonClick:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}
@end
