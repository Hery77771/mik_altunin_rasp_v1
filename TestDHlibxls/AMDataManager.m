//
//  AMDataManager.m
//  DimlomTest
//
//  Created by Алтунин Михаил on 16.02.15.
//
//

#import "AMDataManager.h"
#import "AMNotes.h"
#import "AMxlsFile.h"

@implementation AMDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (AMDataManager*) sharedManager {
    
    static AMDataManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AMDataManager alloc] init];
    });
    
    return manager;
}


- (NSArray*) allObjects {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"AMObjects"
                inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}

- (void) printAllObjects {
    
    NSArray* allObjects = [self allObjects];
    
    [self printArray:allObjects];
}

- (void) deleteAllObjects {
    
    NSArray* allObjects = [self allObjects];
    
    for (id object in allObjects) {
        [self.managedObjectContext deleteObject:object];
    }
    [self.managedObjectContext save:nil];
}


#pragma mark - AMCustomVSchedule

- (NSArray*) allCustomSchedule {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"AMCustomVSchedule"
                inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}

- (NSArray*) allCustomScheduleWithGroupName:(NSString*) groupName {
    
    NSArray* allSchedule = [self allCustomSchedule];
    
    NSMutableArray* returnArray = [NSMutableArray array];
    for (AMCustomVSchedule* sh in allSchedule) {
        if ([sh.groupName isEqualToString:groupName]) {
            [returnArray addObject:sh];
        }
    }
    
    return returnArray;
}


- (void) printArray:(NSArray*) array {
    
    for (id object in array) {
        
        if ([object isKindOfClass:[AMCustomVSchedule class]]) {
            
            AMCustomVSchedule* schedule = (AMCustomVSchedule*) object;
            NSLog(@"AMCustomVSchedule: %@ %@",schedule.scheduleName,schedule.groupName);
        }
    }
}


- (AMCustomVSchedule*) addScheduleWithName:(NSString*) name groupName:(NSString*) groupName andCourseArray:(NSArray*) courseArray {
    
    AMCustomVSchedule* schedule =
    [NSEntityDescription insertNewObjectForEntityForName:@"AMCustomVSchedule"
                                  inManagedObjectContext:self.managedObjectContext];
    
    schedule.groupName = groupName;
    schedule.scheduleName = name;
    
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:courseArray];
    schedule.courseArray = arrayData;
    
    return schedule;
}


-(BOOL) updateSchedule:(AMCustomVSchedule*)schedule withCourseArray:(NSArray*)courseArray {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"AMCustomVSchedule"
                inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"scheduleName = %@", schedule.scheduleName];
    
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"error = %@",[error localizedDescription]);
    }
    
    if (array == nil) {
        return NO;
    } else {
        AMCustomVSchedule* updateSchedule = [array firstObject];
        NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:courseArray];
        updateSchedule.courseArray = arrayData;
        [self saveContext];
        return YES;
    }
}


#pragma mark - AMNotes

- (AMNotes*) addNoteWithName:(NSString*) name {
    
    AMNotes* note =
    [NSEntityDescription insertNewObjectForEntityForName:@"AMNotes"
                                  inManagedObjectContext:self.managedObjectContext];
    note.name = name;
    note.addTime = [[NSDate alloc]init];
    note.endTime = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
    return note;
}

-(BOOL) updateNote:(AMNotes*)note
          withText:(NSString*)text
              name:(NSString*)name
           endDate:(NSDate*)date {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"AMNotes"
                inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@ AND addTime = %@", note.name,note.addTime];
    
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    
    if (error) {
        NSLog(@"error = %@",[error localizedDescription]);
    }
    
    if (array.count != 0) {
        AMNotes* updateNote = [array firstObject];
        updateNote.name = name;
        updateNote.endTime = date;
        updateNote.text = text;
        [self saveContext];
        return YES;
    }
    return YES;
}

#pragma mark - AMxlsFile


-(BOOL) havexlsFileWithName:(NSString*)name andchangeDate:(NSDate*)date {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"AMxlsFile"
                inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@ AND changeDate = %@",name,date];
    
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"error = %@",[error localizedDescription]);
    }
    
    if (array.count!= 0)
        return YES;
    
    return NO;
}

- (AMxlsFile*) addxlsFileWithName:(NSString*) name andChangeDate:(NSDate*) date {
    AMxlsFile* xls =
    [NSEntityDescription insertNewObjectForEntityForName:@"AMxlsFile"
                                  inManagedObjectContext:self.managedObjectContext];
    xls.name = name;
    xls.changeDate = date;
    [self saveContext];
    return xls;
}

-(BOOL) deletexlsFileWithName:(NSString*) name {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"AMxlsFile"
                inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",name];
    
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"error = %@",[error localizedDescription]);
    }
    
    if (array.count!= 0) {
        [self.managedObjectContext deleteObject:[array firstObject]];
        [self saveContext];
        return YES;
    }
    
    return NO;
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    }
    
    return _persistentStoreCoordinator;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil] show];
            
        }
    }
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
