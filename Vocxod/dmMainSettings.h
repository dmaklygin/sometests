//
//  dmMainSettings.h
//  Vocxod
//
//  Created by Dmitry Maklygin on 27.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//


@interface dmMainSettings : NSObject
@property (nonatomic, strong) NSDictionary *settings;
@property (nonatomic,getter = getMaxCountOfBetsInCoupon) NSNumber *couponMaxLengthEvents;
@property (nonatomic, getter = getCuttedIdRange) NSNumber *cuttedIdRange;
@property (nonatomic, getter = getMaxCountOfVariantsInSystem) NSNumber *maxCountVariantInSystem;

+ (instancetype)instance;
- (NSURLSessionDataTask *)loadSettings:(void (^)(NSDictionary *settings, NSError *error))block;
@end
