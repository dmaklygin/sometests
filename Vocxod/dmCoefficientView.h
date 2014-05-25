//
//  dmCoefficientView.h
//  Vocxod
//
//  Created by Dmitry Maklygin on 22.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "Coefficient.h"

@interface dmCoefficientView : UIView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) Coefficient *coefficient;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *titleView;

@property (nonatomic, strong) UIImage *background;

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withCoefficient:(Coefficient *)coefficient;

@end
