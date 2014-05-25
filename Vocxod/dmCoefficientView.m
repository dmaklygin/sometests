//
//  dmCoefficientView.m
//  Vocxod
//
//  Created by Dmitry Maklygin on 22.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmCoefficientView.h"

@interface dmCoefficientView ()


- (UIColor *)getColorOfCoefficient;

@end



@implementation dmCoefficientView

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withCoefficient:(Coefficient *)coefficient
{
    self.title = title;
    self.coefficient = coefficient;
    
    self = [self initWithFrame:frame];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, 44, 60);
        
        [self addSubview:self.button];
		[self addSubview:self.titleView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)updateCoefficient:(Coefficient *)coefficient
{
    
}

- (UILabel *)titleView
{
    if (_titleView != nil) {
        return _titleView;
    }
    
    CGRect frame = [self bounds];
    
    _titleView = [[UILabel alloc] init];
    _titleView.textColor = [UIColor blackColor];
    _titleView.highlightedTextColor = [UIColor whiteColor];
    _titleView.backgroundColor = [UIColor clearColor];
    _titleView.font = [UIFont systemFontOfSize:12];
    _titleView.text = self.title;
    _titleView.textAlignment = NSTextAlignmentCenter;
    _titleView.frame = CGRectMake(frame.origin.x, frame.origin.y + self.button.frame.size.height + 6, frame.size.width, 12.0f);
    
    return _titleView;
}

- (UIButton *)button
{
    if (_button != nil) {
        return _button;
    }
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setBackgroundColor:[self getColorOfCoefficient]];
    [_button setTitle:[self getValueOfCoefficient] forState:UIControlStateNormal];
    [_button setFrame:CGRectMake(0, 0, 44, 44)];
    _button.clipsToBounds = YES;
    _button.layer.cornerRadius = 22;

    return _button;
}

- (UIColor *)getColorOfCoefficient
{
    switch ([self.coefficient.direction compare:[NSNumber numberWithInt:0]]) {
        case NSOrderedAscending:
            return [UIColor redColor];
        case NSOrderedDescending:
            return [UIColor greenColor];
        default:
            return [UIColor yellowColor];
    }
}

- (NSString *)getValueOfCoefficient
{
    return [self.coefficient.value stringValue];
}



@end
