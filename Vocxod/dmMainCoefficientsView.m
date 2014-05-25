//
//  dmMainCoefficientsView.m
//  Vocxod
//
//  Created by Dmitry Maklygin on 22.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//
#import "dmAppDelegate.h"

#import "dmMainCoefficientsView.h"
#import "dmCoefficientView.h"

@implementation dmMainCoefficientsView

- (id)initWithFrame:(CGRect)frame forSport:(dmSport *)sport forEvent:(Event *)event
{
    self.event = event;
    self.sport = sport;
    
    return [self initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect frame = [self bounds];
        
        NSArray *mainCoefficients = [self getMainCoefficientsOfSport];
        
        dmCoefficientView *coefficientView;
        for (int i = 0; i < [mainCoefficients count]; i++) {
            Coefficient *currentCoefficient = [mainCoefficients objectAtIndex:i];
            
            coefficientView = [[dmCoefficientView alloc] initWithFrame:self.frame withTitle:[currentCoefficient getOutcomeName] withCoefficient:currentCoefficient];
            coefficientView.frame = CGRectMake(frame.origin.x + (coefficientView.bounds.size.width + 6) * i, frame.origin.y, coefficientView.bounds.size.width, coefficientView.bounds.size.height);
            [self addSubview:coefficientView];
        }
    }
    return self;
}

- (void)updateCoefficients
{
    NSArray *mainCoefficients = [self getMainCoefficientsOfSport];
    
    dmCoefficientView *coefficientView;
    Coefficient *currentCoefficient;
    
    for (int i = 0; i < [mainCoefficients count]; i++) {
        currentCoefficient = [mainCoefficients objectAtIndex:i];
        coefficientView = [[self subviews] objectAtIndex:i];
        [coefficientView updateCoefficient:currentCoefficient];
    }
}

- (BOOL)sportWithoutDraw
{
    if (_sportWithoutDraw != nil) {
        return _sportWithoutDraw;
    }
    
    _sportWithoutDraw = [dmSport isSportWithoutDraw:self.sport];
    
    return _sportWithoutDraw;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (NSArray *)getMainCoefficientsOfSport
{
    NSDictionary *mainCoefficientsNames = [self getCoefficientsNamesOfSport];
    NSLog(@"mainCoefficientsNames = %@", mainCoefficientsNames);
    
    NSArray *coefficients = [self.event.coefficients allObjects];
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        Coefficient *tempCoefficient = (Coefficient *)evaluatedObject;
        if (mainCoefficientsNames[tempCoefficient.name]) {
            return YES;
        }
        return NO;
    }];
    NSArray *filteredCoefficients = [coefficients filteredArrayUsingPredicate:predicate];
    
    return filteredCoefficients;
}

- (NSDictionary *)getCoefficientsNamesOfSport
{
    switch (self.sportWithoutDraw) {
        case YES:
            return @{
                     @"coeff_CW_P1": @YES,
                     @"coeff_CW_P2": @YES,
                     @"coeff_ODDS_FT_0ODDS_H": @{@"isFora": @YES, @"bases": @"coeff_ODDS_FT_0ODDS"},
                     @"coeff_ODDS_FT_0ODDS_A": @{@"isFora": @YES, @"invert": @YES, @"bases": @"coeff_ODDS_FT_0ODDS"},
                     @"coeff_FT_TL": @{@"bases": @"coeff_FT_T"},
                     @"coeff_FT_TG": @{@"bases": @"coeff_ODDS_FT_0ODDS"}
            };
        default:
            if ([self.sport.slug compare:@"basketball"]) {
                return @{
                         @"coeff_CW_P1": @YES,
                         @"coeff_CW_P2": @YES,
                         @"coeff_ODDS_FT_0ODDS_H": @{@"isFora": @YES, @"bases": @"coeff_ODDS_FT_0ODDS"},
                         @"coeff_ODDS_FT_0ODDS_A": @{@"isFora": @YES, @"invert": @YES, @"bases": @"coeff_ODDS_FT_0ODDS"},
                         @"coeff_FT_TL": @{@"bases": @"coeff_FT_T"},
                         @"coeff_FT_TG": @{@"bases": @"coeff_ODDS_FT_0ODDS"}
                         
                };
            }
            return @{
                     @"coeff_FT_1": @YES,
                     @"coeff_FT_X": @YES,
                     @"coeff_FT_2": @YES,
                     @"coeff_DCFT_1X": @YES,
                     @"coeff_DCFT_12": @YES,
                     @"coeff_DCFT_X2": @YES
            };
    }
}

@end
