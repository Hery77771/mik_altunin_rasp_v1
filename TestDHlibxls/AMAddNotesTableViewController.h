//
//  AMAddNotesTableViewController.h
//  DiplomTest
//
//  Created by Алтунин Михаил on 23.02.15.
//
//

#import <UIKit/UIKit.h>
#import "AMNotes.h"

@interface AMAddNotesTableViewController : UITableViewController

@property (strong, nonatomic) AMNotes* delegate;

@end
