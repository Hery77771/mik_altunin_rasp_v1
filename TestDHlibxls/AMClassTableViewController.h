//
//  AMClassTableViewController.h
//  DimlomTest
//
//  Created by Алтунин Михаил on 10.02.15.
//
//

#import <UIKit/UIKit.h>
#import "AMCourse.h"
@class AMGroup;

@interface AMClassTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UISegmentedControl *weekdaySegmentedControl;

@property (strong,nonatomic) NSArray* courseArray;
@property (nonatomic,assign) typeWeak weak;

- (IBAction)weekSegmetControlChanged:(id)sender;
-(typeDay)typeDay;

@end
