//
//  dmEventViewController.m
//  Vocxod
//
//  Created by Дмитрий on 18.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmLineEventViewController.h"

@interface dmLineEventViewController ()

@end

@implementation dmLineEventViewController

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
    // Do any additional setup after loading the view.
    dmEventView *view = (dmEventView *)self.view;
    view.labelHome.text = [self.event valueForKey:@"home"];
    view.labelAway.text = [self.event valueForKey:@"away"];
    NSLog(@"view = %@", self.view);
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
