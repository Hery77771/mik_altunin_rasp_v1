//
//  AMDataManager.h
//  DimlomTest
//
//  Created by Алтунин Михаил on 16.02.15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AMCustomVSchedule.h"

@interface AMDataManager : NSObject

+(AMDataManager*)sharedManager;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)printAllObjects;
-(void)deleteAllObjects;
- (NSArray*) allCustomSchedule;
- (NSArray*) allCustomScheduleWithGroupName:(NSString*) groupName;

- (AMCustomVSchedule*) addScheduleWithName:(NSString*) name groupName:(NSString*) groupName andCourseArray:(NSArray*) courseArray;

-(BOOL) updateSchedule:(AMCustomVSchedule*)schedule withCourseArray:(NSArray*)courseArray;

@end
