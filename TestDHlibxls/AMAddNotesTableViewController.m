//
//  AMAddNotesTableViewController.m
//  DiplomTest
//
//  Created by Алтунин Михаил on 23.02.15.
//
//

#import "AMAddNotesTableViewController.h"
#import "AMPickerSetupViewController.h"
#import "AMDataManager.h"
#import "AMNotesNameCell.h"
#import "AMNotesTextCell.h"
#import "AMNotesNotificationCell.h"


#define kPickerAnimationDuration    0.40   // duration for the animation to slide the date picker into view
#define kDatePickerTag              99     // view tag identifiying the date picker view

// keep track of which rows have date cells
#define kDateStartRow   1
#define kDateEndRow     2

static NSString *kTimerNameKey = @"kTimerNameKey";
static NSString *kDateCellID = @"dateCell";     // the cells with the start or end date
static NSString *kDatePickerID = @"datePicker";
static NSString *kNameCellID = @"nameCell";     // the cells with the start or end date
static NSString *kTextPickerID = @"textCell"; // the cell containing the date picker
static NSInteger textCellRowHeight = 360;
static NSInteger nameCellRowHeight = 55;

@interface AMAddNotesTableViewController () <UITextFieldDelegate,UITextViewDelegate,UITextViewDelegate>
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) AMNotesNameCell *nameCell;
@property (nonatomic, strong) AMNotesTextCell *textCell;

// keep track which indexPath points to the cell with UIDatePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;

@property (assign) NSInteger pickerCellRowHeight;
@property (assign,nonatomic) BOOL localNotificationSwitch;

@property (nonatomic, strong) IBOutlet UIDatePicker *pickerView;

@property (nonatomic, strong) NSMutableArray *notificationsArray;

// this button appears only when the date picker is shown (iOS 6.1.x or earlier)
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation AMAddNotesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.delegate) {
        self.selectedDate = self.delegate.endTime;
    }
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"dd.MM.yyyy";
    
    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerID];
    self.pickerCellRowHeight = CGRectGetHeight(pickerViewCellToCheck.frame);
    self.title = @"Редактирование";
    
    self.notificationsArray = [[NSMutableArray alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"notificationsKey"]) {
        NSData *data = [defaults objectForKey:@"notificationsKey"];
        self.notificationsArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    // if the local changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    //
    
    [self setlocalNotificationSwitch];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
    
    
    UIBarButtonItem *rbtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNote:)];
    self.navigationItem.rightBarButtonItem = rbtn;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}

#pragma mark - Locale

/*! Responds to region format or locale changes.
 */
- (void)localeChanged:(NSNotification *)notif
{
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    //
    [self.tableView reloadData];
}

#pragma mark - Utilities

/*! Returns the major version of iOS, (i.e. for iOS 6.1.3 it returns 6)
 */

NSUInteger DeviceSystemMajorVersion()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _deviceSystemMajorVersion =
        [[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] integerValue];
    });
    
    return _deviceSystemMajorVersion;
}

#define EMBEDDED_DATE_PICKER (DeviceSystemMajorVersion() >= 7)

/*! Determines if the given indexPath has a cell below it with a UIDatePicker.
 
 @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 */

- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell =
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
    UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:kDatePickerTag];
    
    hasDatePicker = (checkDatePicker != nil);
    return hasDatePicker;
}

/*! Updates the UIDatePicker's value to match with the date of the cell above it.
 */

- (void)updateDatePicker
{
    if (self.datePickerIndexPath != nil)
    {
        UITableViewCell *associatedDatePickerCell = [self.tableView cellForRowAtIndexPath:self.datePickerIndexPath];
        
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
        if (targetedDatePicker != nil)
        {
            // we found a UIDatePicker in this cell, so update it's date value
            //
            [targetedDatePicker setDate:self.selectedDate animated:NO];
        }
    }
}

/*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
 */

- (BOOL)hasInlineDatePicker
{
    return (self.datePickerIndexPath != nil);
}

/*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
 
 @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
 */

- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row);
}

/*! Determines if the given indexPath points to a cell that contains the start/end dates.
 
 @param indexPath The indexPath to check if it represents start/end date cell.
 */

- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath
{
    BOOL hasDate = NO;
    
    if ((indexPath.row == kDateStartRow) ||
        (indexPath.row == kDateEndRow || ([self hasInlineDatePicker] && (indexPath.row == kDateEndRow + 1))))
    {
        hasDate = YES;
    }
    
    return hasDate;
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return ([self indexPathHasPicker:indexPath] ? self.pickerCellRowHeight : self.tableView.rowHeight);
    
    if ([self indexPathHasPicker:indexPath]) {
        return self.pickerCellRowHeight;
    } else if (indexPath.row == 0) {
        return nameCellRowHeight;
    } else if ([self hasInlineDatePicker] && indexPath.row == 3) {
        return textCellRowHeight;
    } else if (![self hasInlineDatePicker] && indexPath.row == 2) {
        return textCellRowHeight;
    } else {
        return self.tableView.rowHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self hasInlineDatePicker])
    {
        // we have a date picker, so allow for it in the number of rows in this section
        NSInteger numRows = 3;
        return ++numRows;
    }
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellID = nil;
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        cellID = kNameCellID;
    } else if ([self hasInlineDatePicker] && indexPath.row == 3) {
        cellID = kTextPickerID;
    } else if (![self hasInlineDatePicker] && indexPath.row == 2) {
        cellID = kTextPickerID;
    } else if ([self indexPathHasPicker:indexPath]) {
        // the indexPath is the one containing the inline date picker
        cellID = kDatePickerID;     // the current/opened date picker cell
    } else if ([self indexPathHasDate:indexPath]) {
        // the indexPath is one that contains the date information
        cellID = kDateCellID;       // the start/end date cells
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (indexPath.row == 0) {
        self.nameCell = (AMNotesNameCell*)cell;
        self.nameCell.noteName.text = self.delegate.name;
        self.nameCell.noteAddDate.text = [self.dateFormatter stringFromDate:self.delegate.addTime];
    } else if ([self hasInlineDatePicker] && indexPath.row == 3) {
        self.textCell = (AMNotesTextCell*)cell;
        self.textCell.noteText.text = self.delegate.text;
    } else if (![self hasInlineDatePicker] && indexPath.row == 2) {
        self.textCell = (AMNotesTextCell*)cell;
        self.textCell.noteText.text = self.delegate.text;
    }
    
    // proceed to configure our cell
    if ([cellID isEqualToString:kDateCellID])
    {
        // we have either start or end date cells, populate their date field
        //
        AMNotesNotificationCell* notCell = cell;
        notCell.NotificationSwitch.on = self.localNotificationSwitch;
        
        if ([notCell.NotificationSwitch isOn]) {
            notCell.StatusLable.text = @"Напомнить";
        }
        
        notCell.TimeLable.text = [self.dateFormatter stringFromDate:self.selectedDate];
    }
    
	return cell;
}

/*! Adds or removes a UIDatePicker cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */

- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    
    // check if 'indexPath' has an attached date picker below it
    if ([self hasPickerForIndexPath:indexPath])
    {
        // found a picker below it, so remove it
        [self.tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        // didn't find a picker below it, so we should insert it
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}

/*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // display the date picker inline with the table content
    [self.tableView beginUpdates];
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    if ([self hasInlineDatePicker])
    {
        before = self.datePickerIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = (self.datePickerIndexPath.row - 1 == indexPath.row);
    
    // remove any date picker cell if it exists
    if ([self hasInlineDatePicker])
    {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
    }
    
    if (!sameCellClicked)
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
}

/*! Reveals the UIDatePicker as an external slide-in view, iOS 6.1.x and earlier, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath used to display the UIDatePicker.
 */

- (void)displayExternalDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // first update the date picker's date value according to our model
    [self.pickerView setDate:self.selectedDate animated:YES];
    
    // the date picker might already be showing, so don't add it to our view
    if (self.pickerView.superview == nil)
    {
        CGRect startFrame = self.pickerView.frame;
        CGRect endFrame = self.pickerView.frame;
        
        // the start position is below the bottom of the visible frame
        startFrame.origin.y = CGRectGetHeight(self.view.frame);
        
        // the end position is slid up by the height of the view
        endFrame.origin.y = startFrame.origin.y - CGRectGetHeight(endFrame);
        
        self.pickerView.frame = startFrame;
        
        [self.view addSubview:self.pickerView];
        
        // animate the date picker into view
        [UIView animateWithDuration:kPickerAnimationDuration animations: ^{ self.pickerView.frame = endFrame; }
                         completion:^(BOOL finished) {
                             // add the "Done" button to the nav bar
                             self.navigationItem.rightBarButtonItem = self.doneButton;
                         }];
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == kDateCellID)
    {
        if ([((AMNotesNotificationCell*)cell).NotificationSwitch isOn]) {
            
            if (EMBEDDED_DATE_PICKER)
                [self displayInlineDatePickerForRowAtIndexPath:indexPath];
            else
                [self displayExternalDatePickerForRowAtIndexPath:indexPath];
        } else {
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark - Actions

/*! User chose to change the date by changing the values inside the UIDatePicker.
 
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)dateAction:(id)sender
{
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlineDatePicker])
    {
        // inline date picker: update the cell's date "above" the date picker cell
        //
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
    }
    else
    {
        // external date picker: update the current "selected" cell's date
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;
    
    self.selectedDate = targetedDatePicker.date;
    
    // update the cell's date string
    
    ((AMNotesNotificationCell*) cell).TimeLable.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
}


/*! User chose to finish using the UIDatePicker by pressing the "Done" button
 (used only for "non-inline" date picker, iOS 6.1.x or earlier)
 
 @param sender The sender for this action: The "Done" UIBarButtonItem
 */

- (IBAction)doneAction:(id)sender
{
    CGRect pickerFrame = self.pickerView.frame;
    pickerFrame.origin.y = CGRectGetHeight(self.view.frame);
    
    // animate the date picker out of view
    [UIView animateWithDuration:kPickerAnimationDuration animations: ^{ self.pickerView.frame = pickerFrame; }
                     completion:^(BOOL finished) {
                         [self.pickerView removeFromSuperview];
                     }];
    
    // remove the "Done" button in the navigation bar
	self.navigationItem.rightBarButtonItem = nil;
    
    // deselect the current table cell
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)saveNote:(id)sender {
    
    NSDate *currentDate = [NSDate date];
    NSIndexPath* idex = [NSIndexPath indexPathForRow:1 inSection:0];
    AMNotesNotificationCell* cell = (AMNotesNotificationCell*)[self.tableView cellForRowAtIndexPath:idex];
    
    if ([[self.selectedDate earlierDate:currentDate] isEqual:self.selectedDate] && [cell.NotificationSwitch isOn]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Некорректная дата напоминания." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    } else {
        [[AMDataManager sharedManager]updateNote:self.delegate withText:self.textCell.noteText.text name:self.nameCell.noteName.text endDate:self.selectedDate];
        
        [self disableNotification];
        [self enableNotification];
    
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextView *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)done:(UIBarButtonItem*)item {
    
    [self.textCell.noteText resignFirstResponder];
    UIBarButtonItem *rbtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNote:)];
    self.navigationItem.rightBarButtonItem = rbtn;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    UIBarButtonItem *rbtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = rbtn;
    
    return YES;
}

#pragma mark - Notifications

-(void)enableNotification
{
    
    NSIndexPath* idex = [NSIndexPath indexPathForRow:1 inSection:0];
    
    if ([((AMNotesNotificationCell*)[self.tableView cellForRowAtIndexPath:idex]).NotificationSwitch isOn]) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = self.selectedDate;
        notification.alertBody = self.nameCell.noteName.text;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.nameCell.noteName.text forKey:kTimerNameKey];
        notification.userInfo = userInfo;
        
        [self.notificationsArray addObject:notification];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.notificationsArray];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"notificationsKey"];
    [defaults synchronize];
    
    BOOL enabledNotifications = YES;
    if ([defaults objectForKey:@"notificationSwitch"]) {
        enabledNotifications = [defaults boolForKey:@"notificationSwitch"];
    }
    
    if (enabledNotifications) {
        [UIApplication sharedApplication].scheduledLocalNotifications = self.notificationsArray;
    }
}

-(void)setlocalNotificationSwitch {
    for (UILocalNotification *notification in self.notificationsArray){
        NSDictionary *userInfo = notification.userInfo;
        if ([self.delegate.name isEqualToString:[userInfo objectForKey:kTimerNameKey]]) {
            self.localNotificationSwitch = YES;
            return;
        }
    }
    
    self.localNotificationSwitch = NO;
}

-(void)disableNotification {
    NSDate *currentDate = [NSDate date];
    for (UILocalNotification *notification in self.notificationsArray){
        NSDictionary *userInfo = notification.userInfo;
        if ([self.nameCell.noteName.text isEqualToString:[userInfo objectForKey:kTimerNameKey]]) {
            [self.notificationsArray removeObject:notification];
            break;
        } else if ([[self.selectedDate earlierDate:currentDate] isEqual:self.selectedDate]) {
            [self.notificationsArray removeObject:notification];
        }
    }
}

@end
