//
//  Timeline.h
//  Vocxod
//
//  Created by Дмитрий on 23.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Timeline : NSManagedObject

@property (nonatomic, retain) NSNumber * balance;
@property (nonatomic, retain) NSNumber * closed;
@property (nonatomic, retain) NSDate * closeDate;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * finishDate;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * stake;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * winSum;

@end
