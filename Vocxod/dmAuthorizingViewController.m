//
//  dmAuthorizingViewController.m
//  Vocxod
//
//  Created by Дмитрий on 24.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmAuthorizingViewController.h"

@interface dmAuthorizingViewController ()

@end

@implementation dmAuthorizingViewController

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
    // Do any additional setup after loading the view from its nib.
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
}

- (IBAction)onValueChanged:(id)sender {
    NSLog(@"value changed");
}

- (IBAction)sendPhone:(id)sender {
    
    if (!self.phoneTextField.text.length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter the Phone" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self.phoneTextField resignFirstResponder];
}
@end
