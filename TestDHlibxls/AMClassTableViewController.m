//
//  AMClassTableViewController.m
//  DimlomTest
//
//  Created by Алтунин Михаил on 10.02.15.
//
//

#import "AMClassTableViewController.h"
#import "AMClassTableViewCell.h"
#include "AMAddCourseTableViewController.h"

@interface AMClassTableViewController () <UITableViewDelegate>

@property (strong,nonatomic) NSArray* dayCourseArray;
@property (strong,nonatomic) NSIndexPath* clickIndexPath;

@end

@implementation AMClassTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.courseArray = [[NSArray alloc]init];
        self.dayCourseArray = [[NSArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.clickIndexPath) {
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[self.clickIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        self.clickIndexPath = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self updateDayCourseArray];
    return self.dayCourseArray.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        static NSString* AddStudentIndentifier = @"addClass";
        UITableViewCell*  cell = [tableView dequeueReusableCellWithIdentifier:AddStudentIndentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddStudentIndentifier];
        }
        return cell;
    }
    
    else {
        static NSString* indentifier = @"classCell";
        
        AMClassTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        
        if (!cell) {
            cell = [[AMClassTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        }
        
        
        AMCourse* course = [self.dayCourseArray objectAtIndex:indexPath.row - 1];
        cell.courseName.text = course.courseName;
        cell.classRoom.text = course.classroom;
        cell.startTime.text = [course stringStartTime];
        
        return cell;
    }
}

-(void)updateDayCourseArray {
    switch(self.weekdaySegmentedControl.selectedSegmentIndex){
        case 0:
            self.dayCourseArray = [AMCourse filterCourseArray:self.courseArray witwDay:TDMonday];
            break;
        case 1:
            self.dayCourseArray = [AMCourse filterCourseArray:self.courseArray witwDay:TDTuesday];
            break;
        case 2:
            self.dayCourseArray = [AMCourse filterCourseArray:self.courseArray witwDay:TDWednesday];
            break;
        case 3:
            self.dayCourseArray = [AMCourse filterCourseArray:self.courseArray witwDay:TDThursday];
            break;
        case 4:
            self.dayCourseArray = [AMCourse filterCourseArray:self.courseArray witwDay:TDFriday];
            break;
        case 5:
            self.dayCourseArray = [AMCourse filterCourseArray:self.courseArray witwDay:TDSaturday];
            break;
    }
}

-(typeDay)typeDay {
    switch(self.weekdaySegmentedControl.selectedSegmentIndex){
        case 0:
            return TDMonday;
        case 1:
            return TDTuesday;
        case 2:
            return TDWednesday;
        case 3:
            return TDThursday;
        case 4:
            return TDFriday;
        case 5:
            return TDSaturday;
        default:
            return INT_MAX;
    }
}


- (IBAction)weekSegmetControlChanged:(id)sender {
    [self.tableView reloadData];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return NO;
    else
        return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AMCourse* course = [self.dayCourseArray objectAtIndex:indexPath.row - 1];
        NSMutableArray* tempCourseArray = [NSMutableArray arrayWithArray:self.courseArray];
        [tempCourseArray removeObject:course];
        self.courseArray = tempCourseArray;
        
        [self.tableView beginUpdates];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        [self.tableView endUpdates];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 40;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        AMCourse* changeCourse = [self.dayCourseArray objectAtIndex:indexPath.row - 1];
        AMAddCourseTableViewController *dest = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeCourse"];
        [dest setDelegate:self];
        [dest setType:ACChange];
        [dest setChangeCourse:changeCourse];
        self.clickIndexPath = indexPath;
        [self.navigationController pushViewController:dest animated:YES];
    }
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"pushAddCourse"]) {
        
        AMAddCourseTableViewController *dest = [segue destinationViewController];
        [dest setDelegate:self];
        [dest setType:ACAdd];
    }
}

@end
