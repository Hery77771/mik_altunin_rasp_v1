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

@class  AMNotes;
@class  AMxlsFile;

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
- (AMNotes*) addNoteWithName:(NSString*) name;
- (AMxlsFile*) addxlsFileWithName:(NSString*) name andChangeDate:(NSDate*) date;

-(BOOL) updateSchedule:(AMCustomVSchedule*)schedule withCourseArray:(NSArray*)courseArray;
-(BOOL) updateNote:(AMNotes*)note withText:(NSString*)text name:(NSString*)name endDate:(NSDate*)date;
-(BOOL) havexlsFileWithName:(NSString*)name andchangeDate:(NSDate*)date;
-(BOOL) deletexlsFileWithName:(NSString*) name;

@end
