//
//  GroupsTableViewController.m
//  DimlomTest
//
//  Created by Алтунин Михаил on 10.02.15.
//
//

#import "AMGroupsTableViewController.h"
#include "AMGroupTableViewCell.h"
#import "AMClassTableViewController.h"
#import "DHxlsReader.h"
#import "AMGroup.h"
#import "AMCourse.h"
#import "AMReaderManager.h"
#import "AMWeekTabBarController.h"
#import "AMSetupTableViewController.h"


extern int xls_debug;

@interface AMGroupsTableViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSArray* groupArray;
@property (strong,nonatomic) AMReaderManager* reader;
@property (nonatomic, retain) NSIndexPath* checkedIndexPath;

@end

@implementation AMGroupsTableViewController

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
    self.groupArray = [NSMutableArray array];
    AMSetupTableViewController* setup = self.delegate;
    NSLog(@"%@",[NSString stringWithFormat:@"%ld_%ld.xls",(long)setup.instituteIndex,(long)setup.courseIndex]);
	NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld_%ld.xls",(long)setup.instituteIndex,(long)setup.courseIndex]];
    
	// xls_debug = 1; // good way to see everything in the Excel file
	
    self.reader = [[AMReaderManager alloc]initWithPath:path];
    self.groupArray = self.reader.groupArray;
    [self selectRowAtGroupName];
}

//- (void)viewDidDisappear:(BOOL)animated {
//    AMSetupTableViewController* setup = self.delegate;
//    setup.courseArray = [self.reader getCourseArrayOfGroupName:setup.selectedGroupe.text];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

-(void)selectRowAtGroupName {
    NSInteger row = nil;
    
    for (AMGroup* group in self.groupArray) {
        if ([group.groupName isEqual:self.selectedGroup]) {
            row = [self.groupArray indexOfObject:group];
            break;
        }
    }
    
    if (row) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        UITableViewCell* uncheckCell = [self.tableView cellForRowAtIndexPath:indexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.checkedIndexPath = indexPath;
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    self.courseArray = [[AMReaderManager sharedReaderManager] getCourseArrayOfGroup:[self.groupArray objectAtIndex:indexPath.row]];
    //
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //
    //    AMWeekTabBarController *dest = [self.storyboard instantiateViewControllerWithIdentifier:@"WeekTabBar"];
    //    dest.courseArray = self.courseArray;
    //
    //    UIViewController* mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    //
    //    [mainVC presentViewController:dest animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.checkedIndexPath) {
        UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:self.checkedIndexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if([self.checkedIndexPath isEqual:indexPath])
    {
        self.checkedIndexPath = nil;
        AMSetupTableViewController* setup = self.delegate;
        setup.selectedGroupe.text = @"Выберите  группу";
        
    }
    
    else {
        UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:indexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.checkedIndexPath = indexPath;
        AMSetupTableViewController* setup = self.delegate;
        AMGroup* group = [self.groupArray objectAtIndex:indexPath.row];
        setup.selectedGroupe.text = [group groupName];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.groupArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* indentifier = @"GroupCell";
    
    AMGroupTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (!cell) {
        cell = [[AMGroupTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    
    AMGroup* group = [self.groupArray objectAtIndex:indexPath.row];
    cell.groupName.text = group.groupName;
    
    if([self.checkedIndexPath isEqual:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}



@end
