//
//  GroupsTableViewController.h
//  DimlomTest
//
//  Created by Алтунин Михаил on 10.02.15.
//
//

#import <UIKit/UIKit.h>


@interface AMGroupsTableViewController : UITableViewController

@property (weak,nonatomic) id delegate;
@property (strong,nonatomic) NSString *selectedGroup;

@end
