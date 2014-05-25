//
//  dmAppAPIClient.m
//  Vocxod
//
//  Created by Дмитрий on 14.04.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmAppAPIClient.h"

static NSString * const dmAppAPIBaseURLString = @"http://vocxod.com/";

@implementation dmAppAPIClient

+ (instancetype)sharedClient {
    static dmAppAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[dmAppAPIClient alloc] initWithBaseURL:[NSURL URLWithString:dmAppAPIBaseURLString]];
    });
    
    return _sharedClient;
}

+ (NSURLSessionDataTask *)send:(NSDictionary *)params success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:params];
    
    [parameters setObject:@"v1.1" forKey:@"version"];
    [parameters setObject:@"{}" forKey:@"auth"];
    
    return [[dmAppAPIClient sharedClient] GET:@"/api/index.php" parameters:parameters success:success failure:failure];
}

@end
