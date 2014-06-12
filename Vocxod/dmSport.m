//
//  dmSport.m
//  Vocxod
//
//  Created by Дмитрий on 14.04.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmSport.h"
#import "dmAppAPIClient.h"
#import "dmAppDelegate.h"

@implementation dmSport

@dynamic id, group, name, slug, rating;

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.id = (NSUInteger)[[attributes valueForKeyPath:@"id"] integerValue];
    self.group = (NSUInteger)[[attributes valueForKeyPath:@"group"] integerValue];
    self.name = [attributes valueForKeyPath:@"name"];
    self.slug = [attributes valueForKeyPath:@"slug"];
    self.rating = (NSUInteger)[[attributes valueForKeyPath:@"rating"] integerValue];
    
    return self;
}

+ (NSURLSessionDataTask *)sportsWithBlock:(void (^)(NSArray *sports, NSError *error))block managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    return [[dmAppAPIClient sharedClient] GET:@"/api/index.php" parameters:@{@"command": @"sports"} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *data = (NSArray *)responseObject;
        NSMutableArray *sports = [NSMutableArray arrayWithCapacity:[data count]];
        for (NSDictionary *attributes in data) {
            dmSport *sport = [dmSport insertNewSport:attributes managedObjectContext:managedObjectContext];
            [sports addObject: sport];
        }
        if (block) {
            block([NSArray arrayWithArray:sports], nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
    
}

+ (dmSport *) insertNewSport:(NSDictionary *)attributes managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    dmSport *newSport = [NSEntityDescription insertNewObjectForEntityForName:@"Sport" inManagedObjectContext:managedObjectContext];
    
    [newSport setValue:[attributes valueForKey:@"id"] forKey:@"id"];
    [newSport setValue:[attributes valueForKey:@"group"] forKey:@"group"];
    @try {
        [newSport setValue:[attributes valueForKey:@"name"] forKey:@"name"];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [newSport setValue:@"noname" forKey:@"name"];
    }
    [newSport setValue:[attributes valueForKey:@"slug"] forKey:@"slug"];
    [newSport setValue:[attributes valueForKey:@"rating"] forKey:@"rating"];
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Insert New Sport Model error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return newSport;
}

+ (BOOL)isSportWithoutDraw:(dmSport *)sport
{
    NSArray *sportsWithoutDraw = @[@"tennis", @"volleyball", @"football", @"baseball",
                                   @"skating", @"luge", @"biathlon", @"bobsled", @"alpine_skiing", @"curling", @"nordic_combined",
                                   @"cross_country_skiing", @"ski_jumping", @"skeleton", @"snowboard", @"figure_skating",
                                   @"freestyle", @"auto_motosport", @"snooker", @"table_tennis", @"badminton"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", sport.name];
    if ([[sportsWithoutDraw filteredArrayUsingPredicate:predicate] count]) {
        return YES;
    }
    return NO;
}


//+ (NSArray *)loadSports:(NSManagedObjectContext *)managedObjectContext {
//    
//    
//    
//}

@end
