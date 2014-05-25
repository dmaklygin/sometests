//
//  dmMainCoefficientsView.h
//  Vocxod
//
//  Created by Dmitry Maklygin on 22.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmSport.h"
#import "Event.h"
#import "Coefficient.h"

@interface dmMainCoefficientsView : UIView

@property (nonatomic, strong) dmSport *sport;
@property (nonatomic, strong) Event *event;
@property (nonatomic) BOOL sportWithoutDraw;
- (id)initWithFrame:(CGRect)frame forSport:(dmSport *)sport forEvent:(Event *)event;
@end
