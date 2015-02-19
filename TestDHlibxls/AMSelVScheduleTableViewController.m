//
//  AMSelVScheduleTableViewController.m
//  DimlomTest
//
//  Created by Алтунин Михаил on 15.02.15.
//
//

#import "AMSelVScheduleTableViewController.h"
#import "AMWeekTabBarController.h"
#import "AMSetupTableViewController.h"
#import "AMDataManager.h"

@interface AMSelVScheduleTableViewController () <UITableViewDataSource>
@property (strong,nonatomic) AMSetupTableViewController* setup;
@end

@implementation AMSelVScheduleTableViewController

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
    
    UITabBarController* tb = (UITabBarController*)[[self navigationController] parentViewController];
    UINavigationController* nv = (UINavigationController*)[[tb viewControllers]firstObject];
    self.setup = (AMSetupTableViewController*)[[nv childViewControllers]firstObject];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(NSManagedObjectContext*)managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [[AMDataManager sharedManager]managedObjectContext];
    }
    return _managedObjectContext;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AMCustomVSchedule" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"groupName = %@",self.setup.selectedGroupe.text];
    [fetchRequest setPredicate:predicate];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"groupName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.fetchedResultsController = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* indentifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (IBAction)addCustomSchedule:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Создание расписания." message:@"Имя нового расписания:" delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles:@"Используя шаблон mati.ru",@"Пустой шаблон", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1: {
            
            NSString* scheduleName = [[alertView textFieldAtIndex:0]text];
            [[AMDataManager sharedManager]addScheduleWithName:scheduleName groupName:self.setup.selectedGroupe.text andCourseArray:self.setup.courseArray];
            [[AMDataManager sharedManager]saveContext];
            break;
             }
        case 2: {
            
            NSString* scheduleName = [[alertView textFieldAtIndex:0]text];
            [[AMDataManager sharedManager]addScheduleWithName:scheduleName groupName:self.setup.selectedGroupe.text andCourseArray:nil];
            [[AMDataManager sharedManager]saveContext];
            break;
        }
            
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AMWeekTabBarController *dest = [self.storyboard instantiateViewControllerWithIdentifier:@"WeekTabBar"];
    
   
        AMCustomVSchedule* sh = [[[AMDataManager sharedManager]allCustomScheduleWithGroupName:self.setup.selectedGroupe.text]objectAtIndex:indexPath.row];
        [dest setCustomSchedule:sh];
    
        UIViewController* mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    
        [mainVC presentViewController:dest animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
        return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark - Fetched results controller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    AMCustomVSchedule* sh = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    cell.textLabel.text = sh.scheduleName;
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"Нажмите + для добавления расписания.";
}

@end
