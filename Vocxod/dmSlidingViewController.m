//
//  dmSlidingViewController.m
//  Vocxod
//
//  Created by Dmitry Maklygin on 06.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmSlidingViewController.h"
#import "dmZoomAnimationController.h"

@interface dmSlidingViewController ()
@property (nonatomic, strong) dmZoomAnimationController *zoomAnimationController;
@end

@implementation dmSlidingViewController

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
    
    self.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    
    self.delegate = self.zoomAnimationController;
    self.customAnchoredGestures = @[];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (dmZoomAnimationController *)zoomAnimationController {
    if (_zoomAnimationController) return _zoomAnimationController;
    
    _zoomAnimationController = [[dmZoomAnimationController alloc] init];
    
    return _zoomAnimationController;
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
