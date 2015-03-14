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
#import "AMDataManager.h"

@interface AMSetupTableViewController () <UITableViewDelegate>
@property (strong, nonatomic) NSDictionary* changeDateDictionary;
@property (strong, nonatomic) NSMutableArray *availableDownloadsArray;
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
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:160/255.0f green:160/255.0f blue:160/255.0f alpha:0.9f]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];
    [self updateXLSFiles];
    self.changeDateDictionary = [[NSDictionary alloc]init];
    self.availableDownloadsArray = [[NSMutableArray alloc]init];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self saveInUserDefaults];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    if (self.availableDownloadsArray.count == 0) {
        self.updateButton.hidden = YES;
        [[self.UpdateLable objectAtIndex:1] setHidden:YES];
        [[self.UpdateLable objectAtIndex:0] setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

- (IBAction)ChangeNotificationSwitch:(UISwitch*)sender {
    if (!sender.isOn) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

- (void)saveInUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.selectedInstitute.text forKey:@"selectedInstitute"];
    [defaults setObject:self.selectedCourse.text forKey:@"selectedCourse"];
    [defaults setObject:self.selectedGroupe.text forKey:@"selectedGroupe"];
    [defaults setInteger:self.pushNotificationSwitch.isOn forKey:@"notificationSwitch"];
    [defaults setInteger:self.courseIndex forKey:@"courseIndex"];
    [defaults setInteger:self.instituteIndex forKey:@"instituteIndex"];
    [defaults setObject:self.selectedCourse.text forKey:@"selectedCourse"];
    [defaults synchronize];
}

- (void)loadInUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"notificationSwitch"]) {
        BOOL isOn = [defaults boolForKey:@"notificationSwitch"];
        [self.pushNotificationSwitch setOn:isOn];
    }
    
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

-(void)deleteFile:(NSString*)path {
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [docPath stringByAppendingPathComponent:path];
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
}

- (void)updateXLSFiles { //perform get request
    ServiceConnector *serviceConnector = [[ServiceConnector alloc] init];
    serviceConnector.delegate = self;
    [serviceConnector updateChangeDate];
}

-(void)updateFile:(NSDictionary*)changeDate {
    AMDataManager* data = [AMDataManager sharedManager];
    NSDateFormatter* dateFormater = [[NSDateFormatter alloc]init];
    dateFormater.dateFormat = @"dd MM yyyy H:m:s";
    
    for (int i = 1; i < 5; i++) {
        for (int j = 1; j < 6; j++ ) {
            NSDate* date = [dateFormater dateFromString:[changeDate objectForKey:[NSString stringWithFormat:@"%d_%d",i,j]]];
            NSString* name = [NSString stringWithFormat:@"%d_%d.xls",i,j];
            if (![data havexlsFileWithName:name andchangeDate:date]) {
                NSLog(@"Файл %@ нужно обновить",name);
                [self.availableDownloadsArray addObject:[NSString stringWithFormat:@"http://www.mati-sched.tk/xlsFile/%d/%d_%d.xls",i,i,j]];
                if ([self.updateButton isHidden]) {
                    self.updateButton.hidden = NO;
                    [[self.UpdateLable objectAtIndex:1] setHidden:NO];
                    [[self.UpdateLable objectAtIndex:0] setHidden:YES];
                }
            }
        }
    }
}


#pragma mark - UITableViewDelegate

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
    else if ([[segue identifier] isEqualToString: @"downloadRasp"]) {
        
        MZDownloadManagerViewController *dest = [segue destinationViewController];
        [dest setDelegate:self];
        dest.downloadingArray = [[NSMutableArray alloc]init];
        dest.sessionManager = [dest backgroundSession];
        [dest populateOtherDownloadTasks];
        
        for (NSString* url in self.availableDownloadsArray) {
            NSString *name = [[url componentsSeparatedByString:@"/"] lastObject];
            [[AMDataManager sharedManager] deletexlsFileWithName:name];
            [self deleteFile:name];
            [dest addDownloadTask:name fileURL:url];
            NSLog(@"%@",name);
        }
    }
}




#pragma mark - ServiceConnectorDelegate

-(void)requestReturnedData:(NSData *)data{ //activated when data is returned
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithJSONData:data];
    self.changeDateDictionary = dictionary;
    NSLog(@"%@",dictionary);
    [self updateFile:dictionary];
}


- (void)downloadRequestFinished:(NSString *)fileName {
    NSString *name = [[fileName componentsSeparatedByString:@"."] firstObject];
    NSDateFormatter* dateFormater = [[NSDateFormatter alloc]init];
    dateFormater.dateFormat = @"dd MM yyyy H:m:s";
    NSLog(@"%@",name);
    [[AMDataManager sharedManager]addxlsFileWithName:fileName andChangeDate:[dateFormater dateFromString:[self.changeDateDictionary objectForKey:name]]];
    [self.availableDownloadsArray removeObject:[NSString stringWithFormat:@"http://www.mati-sched.tk/xlsFile/%@/%@",[[name componentsSeparatedByString:@"_"] firstObject],fileName]];
}

@end
