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
@property (nonatomic, strong) dmMainCoefficientsView *mainCoefficientsView;
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
    
    [self setMainValues];
    
    [self.event addObserver:self forKeyPath:@"coefficients" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.view addSubview:self.mainCoefficientsView];
}

- (void)dealloc
{
    [self.event removeObserver:self forKeyPath:@"coefficients"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMainValues
{
    // Do any additional setup after loading the view.
    self.labelHome.text = [self.event valueForKey:@"home"];
    self.labelAway.text = [self.event valueForKey:@"away"];

    NSString *partTitle = [NSString stringWithFormat:NSLocalizedString(@"%@ TIME", nil), [[self.event getPart] stringValue]];
    self.labelPart.text = partTitle;
    
    // time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    self.labelTime.text = [self getTime];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"event changed. keyPath = %@", keyPath);
    [self.mainCoefficientsView updateCoefficients];
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
- (dmMainCoefficientsView *)mainCoefficientsView
{
    if (_mainCoefficientsView != nil) {
        return _mainCoefficientsView;
    }
    
    dmTournament *tournament = (dmTournament *)self.event.inTournament;
    
    _mainCoefficientsView = [[dmMainCoefficientsView alloc] initWithFrame:self.view.frame forSport:tournament.inSport forEvent:self.event];
    
    CGRect frame = self.eventInfoView.frame;
    
    _mainCoefficientsView.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height + 10, _mainCoefficientsView.bounds.size.width, _mainCoefficientsView.bounds.size.height);
    return _mainCoefficientsView;
}

- (NSString *)getTime
{
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"mm:ss"];
    
    NSDate *eventDate = [NSDate dateWithTimeIntervalSince1970:[self.event.current_second doubleValue]];

    return [df stringFromDate:eventDate];

}

- (IBAction)buttonTap:(id)sender {
}

- (IBAction)onFavouritesButtonClick:(id)sender {
    
}
@end
