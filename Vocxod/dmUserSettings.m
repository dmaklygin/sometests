//
//  dmUserSettings.m
//  Vocxod
//
//  Created by Дмитрий on 04.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmUserSettings.h"

@implementation dmUserSettings

+ (instancetype)standartSettings
{
    static dmUserSettings *_userSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userSettings = [[dmUserSettings alloc] init];
    });
    
    return _userSettings;
}

- (NSUserDefaults *)userDefaults
{
    if (_userDefaults) {
        return _userDefaults;
    }
    
//    NSString *defaultPrefsFile = [[NSBundle mainBundle] pathForResource:@"defaultPrefs" ofType:@"plist"];
//    NSDictionary *defaultPreferences = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];

    _userDefaults = [NSUserDefaults standardUserDefaults];
    
//    [_userDefaults registerDefaults:defaultPreferences];
    
    return  _userDefaults;
}

- (int)getId
{
    return [self.userDefaults integerForKey:@"userId"];
}

- (void)setId:(int)userId
{
    [self.userDefaults setObject:[NSNumber numberWithInt:userId] forKey:@"userId"];
    [self.userDefaults synchronize];
}

- (NSString *)getLogin
{
    return [self.userDefaults stringForKey:@"login"];
}

- (void)setLogin:(NSString *)login
{
    [self.userDefaults setObject:login forKey:@"login"];
    [self.userDefaults synchronize];
}

- (BOOL)isLogin
{
    int userId = [self getId];
    if (!userId) {
        return NO;
    }
    return YES;
}

- (void)synchronize
{
    [self.userDefaults synchronize];
}

@end
