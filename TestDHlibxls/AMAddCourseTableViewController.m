//
//  AMAddCourseTableViewController.m
//  DimlomTest
//
//  Created by Алтунин Михаил on 17.02.15.
//
//

#import "AMAddCourseTableViewController.h"
#import "AMPickerSetupViewController.h"
#import "AMClassTableViewController.h"
#import "AMCourse.h"

@interface AMAddCourseTableViewController () <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>

@end

@implementation AMAddCourseTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.type == ACChange) {
        self.courseClassroomLable.text = self.changeCourse.classroom;
        self.courseNameLable.text = self.changeCourse.courseName;
        self.courseTimeLable.text = [self.changeCourse stringStartTime];
        
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"pushCourseTimePicker"]) {
        
        AMPickerSetupViewController *dest = [segue destinationViewController];
        [dest setDelegate:self];
        [dest setType:TSVCTime];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)saveAction:(id)sender {
    
    if ([self.courseNameLable.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Введите название предмета." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    } else if ([self.courseClassroomLable.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Введите номер кабинета." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    } else if ([self.courseTimeLable.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Выберите время." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (self.type == ACAdd) {
        AMClassTableViewController* classTV = self.delegate;
        AMCourse* newCourse = [[AMCourse alloc]init];
        newCourse.time = [AMCourse startTime:self.courseTimeLable.text];
        newCourse.courseName = self.courseNameLable.text;
        newCourse.classroom = self.courseClassroomLable.text;
        newCourse.weak = classTV.weak;
        newCourse.day = [classTV typeDay];
        
        NSMutableArray* newcourseArray = [NSMutableArray arrayWithArray:classTV.courseArray];
        [newcourseArray addObject:newCourse];
        classTV.courseArray = newcourseArray;
        
        NSInteger row = [AMCourse filterCourseArray:classTV.courseArray witwDay:newCourse.day].count;
        [self.navigationController popViewControllerAnimated:YES];
        [classTV.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
    } else {
        self.changeCourse.classroom = self.courseClassroomLable.text;
        self.changeCourse.courseName = self.courseNameLable.text;
        self.changeCourse.time = [AMCourse startTime:self.courseTimeLable.text];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [(AMClassTableViewController*)self.delegate setDayCourseArrayChanged:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
