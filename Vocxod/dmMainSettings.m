//
//  dmMainSettings.m
//  Vocxod
//
//  Created by Dmitry Maklygin on 27.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmMainSettings.h"
#import "dmAppAPIClient.h"

@implementation dmMainSettings

+ (instancetype)instance {
    static dmMainSettings *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[dmMainSettings alloc] init];
    });
    
    return _instance;
}

// Максимальное количество ставок внутри купона
- (NSNumber *)getMaxCountOfBetsInCoupon
{
    if (_couponMaxLengthEvents != nil) {
        return _couponMaxLengthEvents;
    }
    _couponMaxLengthEvents = self.settings[@"COUPON_MAX_LENGTH_EVENTS"];
    return _couponMaxLengthEvents;
}

// Ранг для rolled_id
- (NSNumber *)getCuttedIdRange
{
    if (_cuttedIdRange != nil) {
        return _cuttedIdRange;
    }
    _cuttedIdRange = self.settings[@"CUTTED_ID_RANGE"];
    
    return _cuttedIdRange;
}

// Максимальное количество вариантов в системе
- (NSNumber *)getMaxCountOfVariantsInSystem
{
    if (_maxCountVariantInSystem != nil) {
        return _maxCountVariantInSystem;
    }
    _maxCountVariantInSystem = self.settings[@"MAX_COUNT_VARIANTS_IN_SYSTEM"];
    
    return _maxCountVariantInSystem;
}

- (NSURLSessionDataTask *)loadSettings:(void (^)(NSDictionary *settings, NSError *error))block
{
    
    return [dmAppAPIClient send:@{@"command": @"settings"} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.settings = [responseObject valueForKey:@"settings"];
        
        if (block) {
            block(self.settings, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end
