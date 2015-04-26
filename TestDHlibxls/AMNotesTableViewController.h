//
//  AMNotesTableViewController.h
//  DiplomTest
//
//  Created by Алтунин Михаил on 23.02.15.
//
//

#import <UIKit/UIKit.h>
#import "AMDataManager.h"

@interface AMNotesTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

- (IBAction)addCustomNotes:(id)sender;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
