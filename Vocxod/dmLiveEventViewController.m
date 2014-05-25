//
//  dmLiveEventViewController.m
//  Vocxod
//
//  Created by Dmitry Maklygin on 21.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmLiveEventViewController.h"
#import "dmMainCoefficientsView.h"

#import "dmTournament.h"

@interface dmLiveEventViewController ()

@end

@implementation dmLiveEventViewController

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
    self.labelHome.text = [self.event valueForKey:@"home"];
    self.labelAway.text = [self.event valueForKey:@"away"];
    
    dmTournament *tournament = (dmTournament *)self.event.inTournament;
    
    dmMainCoefficientsView *mainCoefficients = [[dmMainCoefficientsView alloc] initWithFrame:self.view.frame forSport:tournament.inSport forEvent:self.event];
    CGRect frame = self.eventInfoView.frame;
    mainCoefficients.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height + 10, mainCoefficients.bounds.size.width, mainCoefficients.bounds.size.height);
    [self.view addSubview:mainCoefficients];
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
