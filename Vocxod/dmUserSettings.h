//
//  dmUserSettings.h
//  Vocxod
//
//  Created by Дмитрий on 04.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dmUserSettings : NSObject

@property (nonatomic, strong) NSUserDefaults *userDefaults;

+ (instancetype)standartSettings;

- (int)getId;
- (void)setId:(int)userId;

- (NSString *)getLogin;
- (void)setLogin:(NSString *)login;

- (void)synchronize;

- (BOOL)isLogin;
@end
