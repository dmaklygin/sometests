//
//  dmLiveEventViewController.h
//  Vocxod
//
//  Created by Dmitry Maklygin on 21.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "Event.h"

@interface dmLiveEventViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *labelHome;
@property (weak, nonatomic) IBOutlet UILabel *labelAway;
@property (weak, nonatomic) IBOutlet UIView *eventInfoView;
@property (strong, nonatomic) IBOutlet UILabel *labelPart;
@property (nonatomic,strong) Event *event;
@end
