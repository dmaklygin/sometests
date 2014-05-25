//
//  dmOutcomesController.h
//  Vocxod
//
//  Created by Dmitry Maklygin on 23.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmAppAPIClient.h"

@interface dmOutcomesController : NSObject
// Хеш мнемоников с ключом по ауткому!
@property (nonatomic, strong) NSDictionary *mnemonics;
// Хеш ауткомов с названиями с ключом по имени мнемоника
@property (nonatomic, strong) NSDictionary *outcomes;
// Хеш ауткомов-базисов для ауткома, с ключом по имени мнемоника связанного ауткома
@property (nonatomic, strong) NSDictionary *bases;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (NSURLSessionDataTask *)loadRemoteOutcomes:(void (^)(id data, NSError *error))block;

- (NSString *)getOutcomeName:(NSString *)mnemonicName;

@end
