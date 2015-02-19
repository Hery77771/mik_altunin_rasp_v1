//
//  AMCustomVSchedule.h
//  DimlomTest
//
//  Created by Алтунин Михаил on 16.02.15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AMCustomVSchedule : NSManagedObject

@property (nonatomic, retain) NSString * scheduleName;
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSData * courseArray;

@end
