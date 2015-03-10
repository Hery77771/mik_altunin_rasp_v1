//
//  AMClassTableViewController.h
//  DimlomTest
//
//  Created by Алтунин Михаил on 10.02.15.
//
//

#import <UIKit/UIKit.h>
#import "AMCourse.h"
#import "Catigoryes.h"

@class AMGroup;

@interface AMClassTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UISegmentedControl *weekdaySegmentedControl;

@property (strong,nonatomic) NSArray* courseArray;
@property (nonatomic,assign) typeWeak weak;
@property (assign,nonatomic) BOOL dayCourseArrayChanged;

- (IBAction)weekSegmetControlChanged:(id)sender;
-(void)edit;
-(typeDay)typeDay;

@end
