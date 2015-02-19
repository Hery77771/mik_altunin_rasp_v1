//
//  AMAddCourseTableViewController.h
//  DimlomTest
//
//  Created by Алтунин Михаил on 17.02.15.
//
//

#import <UIKit/UIKit.h>
#import "AMCourse.h"

typedef enum {
    ACAdd       = 1,
    ACChange    = 2,
} ACType;


@interface AMAddCourseTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *courseNameLable;
@property (weak, nonatomic) IBOutlet UITextField *courseClassroomLable;
@property (weak, nonatomic) IBOutlet UITextField *courseTimeLable;
@property (strong, nonatomic) id delegate;
@property (nonatomic,assign) ACType type;
@property (nonatomic,strong) AMCourse* changeCourse;

- (IBAction)saveAction:(id)sender;

@end
