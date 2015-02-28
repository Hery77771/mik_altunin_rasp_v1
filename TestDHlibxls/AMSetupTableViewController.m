//
//  AMSetupTableViewController.m
//  DimlomTest
//
//  Created by Алтунин Михаил on 14.02.15.
//
//

#import "AMSetupTableViewController.h"
#import "AMPickerSetupViewController.h"
#import "AMGroupsTableViewController.h"
#import "AMReaderManager.h"

@interface AMSetupTableViewController () <UITableViewDelegate>


@end

@implementation AMSetupTableViewController

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
    [self loadInUserDefaults];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:70/255.0f green:150/255.0f blue:240/255.0f alpha:0.9f]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self saveInUserDefaults];
}


- (void)saveInUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.selectedInstitute.text forKey:@"selectedInstitute"];
    [defaults setObject:self.selectedCourse.text forKey:@"selectedCourse"];
    [defaults setObject:self.selectedGroupe.text forKey:@"selectedGroupe"];
    [defaults setInteger:self.courseIndex forKey:@"courseIndex"];
    [defaults setInteger:self.instituteIndex forKey:@"instituteIndex"];
    [defaults setObject:self.selectedCourse.text forKey:@"selectedCourse"];
    [defaults synchronize];
}

- (void)loadInUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"selectedInstitute"]) {
        self.instituteIndex = [defaults integerForKey:@"instituteIndex"];
        self.selectedInstitute.text = [defaults objectForKey:@"selectedInstitute"];
    }
    if ([defaults objectForKey:@"selectedCourse"]) {
        self.selectedCourse.text = [defaults objectForKey:@"selectedCourse"];
        self.courseIndex = [defaults integerForKey:@"courseIndex"];
    }
    if ([defaults objectForKey:@"selectedGroupe"])
        self.selectedGroupe.text = [defaults objectForKey:@"selectedGroupe"];
}

//-(void)loadCourseArray {
//    if ([self.selectedCourse.text isEqualToString:@"Выберите курс"] || [self.selectedInstitute.text isEqualToString:@"Выберите институт"] || [self.selectedInstitute.text isEqualToString:@"Выберите  группу"]) {
//        return;
//    } else {
//        NSLog(@"%@",[NSString stringWithFormat:@"%ld_%ld.xls",(long)self.instituteIndex,(long)self.courseIndex]);
//        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld_%ld.xls",(long)self.instituteIndex,(long)self.courseIndex]];
//        AMReaderManager* reader = [[AMReaderManager alloc]initWithPath:path];
//        self.courseArray = [reader getCourseArrayOfGroupName:self.selectedGroupe.text];
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2) {
        if ([self.selectedCourse.text isEqualToString:@"Выберите курс"] || [self.selectedInstitute.text isEqualToString:@"Выберите институт"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Выберите курс и институт." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        else {
            AMGroupsTableViewController *dest = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectGroup"];
            [dest setDelegate:self];
            [dest setSelectedGroup:self.selectedGroupe.text];
            [self.navigationController pushViewController:dest animated:YES];
        }
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"pushCourseSetup"]) {
        
        AMPickerSetupViewController *dest = [segue destinationViewController];
        [dest setDelegate:self];
        [dest setType:TSVCCourse];
    } else if ([[segue identifier] isEqualToString: @"pushInstituteSetup"]) {
        
        AMPickerSetupViewController *dest = [segue destinationViewController];
        [dest setDelegate:self];
        [dest setType:TSVCInstitute];
    }
}

@end
