//
//  dmOutcomesController.m
//  Vocxod
//
//  Created by Dmitry Maklygin on 23.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmOutcomesController.h"

@implementation dmOutcomesController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.managedObjectContext = managedObjectContext;
    
    return self;
}

- (NSURLSessionDataTask *)loadRemoteOutcomes:(void (^)(id data, NSError *error))block
{
    NSDictionary *params = @{ @"command": @"outcomes" };
    
    return [dmAppAPIClient send:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // Инициализация массива мнемоников, с ключом по outcomeID!
        _mnemonics = [responseObject valueForKey:@"mnemonics"];
        
        NSDictionary *shortNames = [responseObject valueForKey:@"shortNames"];
        NSDictionary *oddsOutcomeIdsByOutcomeId = [responseObject valueForKey:@"oddsOutcomeIdsByOutcomeId"];
        NSMutableDictionary *outcomes = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *bases = [[NSMutableDictionary alloc] init];
        
        for (NSString *outcomeId in _mnemonics) {
            NSString *mnemonicName = [_mnemonics valueForKey:outcomeId];
            NSString *shortName = [shortNames valueForKey:outcomeId];
            if (shortName == nil) {
                shortName = @"-";
            }

            NSMutableDictionary *outcome = [NSMutableDictionary dictionaryWithDictionary:@{@"outcomeId": outcomeId, @"name": shortName}];
            
            NSString *basisOutcomeId = [oddsOutcomeIdsByOutcomeId[outcomeId] stringValue];
            if (basisOutcomeId != nil) {
                NSString *basisMnemonicName = [_mnemonics valueForKey:basisOutcomeId];
                NSDictionary *basis = @{@"outcomeId": basisOutcomeId, @"mnemonicName": basisMnemonicName};
                [outcome setValue:basisMnemonicName forKey:@"basisMnemonicName"];

                [bases setValue:basis forKey:mnemonicName];
            }
            
            [outcomes setObject:outcome forKey:mnemonicName];
        }
        
        // Инициализация хеша ауткомов с ключом по mnemonicName
        _outcomes = outcomes;
        
        // Инициализация хеша ауткомов-базисов с ключом по mnemonicName связанного ауткома
        _bases = bases;
        
        if (block) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (NSString *)getOutcomeName:(NSString *)mnemonicName
{
    NSDictionary *mnemonic = [self.outcomes valueForKey:mnemonicName];
    if (mnemonic != nil) {
        return [mnemonic valueForKey:@"name"];
    }
    return nil;
}

@end
