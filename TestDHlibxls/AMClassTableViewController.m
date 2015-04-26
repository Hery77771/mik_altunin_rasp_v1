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
#import "AMWeekTabBarController.h"

#define TIME_LABEL 20

@interface AMClassTableViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSArray* dayCourseArray;
@property (strong,nonatomic) NSIndexPath* clickIndexPath;


@end

@implementation AMClassTableViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.courseArray = [[NSArray alloc]init];
        self.dayCourseArray = [[NSArray alloc]init];
        self.dayCourseArrayChanged = NO;
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
        [self.TableView beginUpdates];
        [self.TableView reloadRowsAtIndexPaths:@[self.clickIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.TableView endUpdates];
        self.clickIndexPath = nil;
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self updateCourseArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

-(void)updateDayCourseArray {
    [self updateCourseArray];
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

- (IBAction)backAction:(id)sender {
    [(AMWeekTabBarController*)self.parentViewController swipeRight];
}

-(void)updateCourseArray {
    if (self.dayCourseArrayChanged) {
        NSMutableArray* array = [NSMutableArray arrayWithArray:self.courseArray];
        NSMutableArray* removedObj = [[NSMutableArray alloc]init];
        typeDay type = [(AMCourse*)[self.dayCourseArray firstObject] day];
        
        for (AMCourse* course in array) {
            
            if (course.day == type) {
                [removedObj addObject:course];
            }
        }
        
        [array removeObjectsInArray:removedObj];
        [array addObjectsFromArray:self.dayCourseArray];
        self.courseArray = array;
        self.dayCourseArrayChanged = NO;
    }
}


- (IBAction)weekSegmetControlChanged:(id)sender {
    [self.TableView reloadData];
}


-(void)edit {
    BOOL isEditing = self.TableView.editing;
    
    [self.TableView setEditing:!isEditing animated:YES];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 40;
    } else {
        return [NSObject heightLabelOfTextForString:[(AMCourse*)[self.dayCourseArray objectAtIndex:indexPath.row - 1] courseName] fontSize:14.f widthLabel:300.f] + TIME_LABEL;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    if (proposedDestinationIndexPath.row == 0) {
        return sourceIndexPath;
    }
    else
        return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.TableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row != 0) {
        AMCourse* changeCourse = [self.dayCourseArray objectAtIndex:indexPath.row - 1];
        AMAddCourseTableViewController *dest = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeCourse"];
        [dest setDelegate:self];
        [dest setType:ACChange];
        [dest setChangeCourse:changeCourse];
        self.clickIndexPath = indexPath;
        [self presentViewController:dest animated:YES completion:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Удалить";
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return indexPath.row == 0 ? UITableViewCellEditingStyleNone : UITableViewCellEditingStyleDelete;
//}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return CGFLOAT_MIN;
    return tableView.sectionHeaderHeight;
}




#pragma mark - UITableViewDataSource

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
        AMClassTableViewCell*  cell = [tableView dequeueReusableCellWithIdentifier:AddStudentIndentifier];
        
        if (!cell) {
            cell = [[AMClassTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddStudentIndentifier];
        }
        cell.delegate = self;
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
        
        CGRect newFrame = cell.courseName.frame;
        newFrame.size.height = [NSObject heightLabelOfTextForString:[(AMCourse*)[self.dayCourseArray objectAtIndex:indexPath.row - 1] courseName] fontSize:14.f widthLabel:300.f];
        cell.courseName.frame = newFrame;
        newFrame = cell.classRoom.frame;
        newFrame.origin.y = cell.courseName.frame.size.height + 5;
        cell.classRoom.frame = newFrame;
        newFrame = cell.startTime.frame;
        newFrame.origin.y = cell.courseName.frame.size.height + 5;
        cell.startTime.frame = newFrame;
        
        return cell;
    }
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
        
        [self.TableView beginUpdates];
        
        [self.TableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        [self.TableView endUpdates];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row > 0;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"pushAddCourse"]) {
        
        AMAddCourseTableViewController *dest = [segue destinationViewController];
        [dest setDelegate:self];
        [dest setType:ACAdd];
    }
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSMutableArray* tempArray = [NSMutableArray arrayWithArray:self.dayCourseArray];
    AMCourse *employee = [tempArray objectAtIndex:sourceIndexPath.row - 1];
    [tempArray removeObject: employee];
    [tempArray insertObject:employee atIndex:destinationIndexPath.row - 1];
   // [tempArray exchangeObjectAtIndex:sourceIndexPath.row - 1 withObjectAtIndex:destinationIndexPath.row - 1];
    self.dayCourseArray = tempArray;
    self.dayCourseArrayChanged = YES;
    [self updateCourseArray];
}



@end
