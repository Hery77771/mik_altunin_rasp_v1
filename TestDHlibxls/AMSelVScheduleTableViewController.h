//
//  AMSelVScheduleTableViewController.h
//  DimlomTest
//
//  Created by Алтунин Михаил on 15.02.15.
//
//

#import <UIKit/UIKit.h>
#import "AMDataManager.h"

@interface AMSelVScheduleTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>


- (IBAction)addCustomSchedule:(id)sender;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
