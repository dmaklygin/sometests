//
//  dmSport.h
//  Vocxod
//
//  Created by Дмитрий on 14.04.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface dmSport : NSManagedObject

@property (nonatomic, assign) NSUInteger id;
@property (nonatomic, assign) NSUInteger group;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, assign) NSUInteger rating;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

+ (NSURLSessionDataTask *)sportsWithBlock:(void (^)(NSArray *sports, NSError *error))block managedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (BOOL)isSportWithoutDraw:(dmSport *)sport;

@end
