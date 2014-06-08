//
//  dmManagedObjectContext.m
//  Vocxod
//
//  Created by Дмитрий on 08.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmModelController.h"

@implementation dmModelController

+ (NSManagedObjectContext *)managedObjectContext {
    static NSManagedObjectContext *_managedObjectContext = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [dmModelController persistentStoreCoordinator];
        
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
        
    });
    
    return _managedObjectContext;
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    static NSPersistentStoreCoordinator *_persistentStoreCoordinator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSManagedObjectModel *managedObjectModel = [dmModelController managedObjectModel];
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
        NSURL *documentDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeUrl = [documentDirectory URLByAppendingPathComponent:@"Vocxod.CDBStore"];
        
        NSError *error;
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
            NSLog(@"dmModelController error %@, %@", error, [error userInfo]);
            abort();
        }
    });
    
    return _persistentStoreCoordinator;
}

+ (NSManagedObjectModel *)managedObjectModel {
    
    static NSManagedObjectModel *_managedObjectModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"Tournaments" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    });
    
    return _managedObjectModel;
}



@end
