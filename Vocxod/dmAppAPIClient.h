//
//  dmAppAPIClient.h
//  Vocxod
//
//  Created by Дмитрий on 14.04.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface dmAppAPIClient : AFHTTPSessionManager
+ (instancetype)sharedClient;
+ (NSURLSessionDataTask *)send:(NSDictionary *)params success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end
