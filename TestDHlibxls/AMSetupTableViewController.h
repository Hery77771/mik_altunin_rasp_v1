//
//  AMSetupTableViewController.h
//  DimlomTest
//
//  Created by Алтунин Михаил on 14.02.15.
//
//

#import <UIKit/UIKit.h>
#import "ServiceConnector.h"
#import "MZDownloadManagerViewController.h"

@interface AMSetupTableViewController : UITableViewController <ServiceConnectorDelegate,MZDownloadDelegate>
@property (weak, nonatomic) IBOutlet UILabel *selectedInstitute;
@property (weak, nonatomic) IBOutlet UILabel *selectedCourse;
@property (weak, nonatomic) IBOutlet UILabel *selectedGroupe;

@property (nonatomic, assign) NSInteger courseIndex;
@property (nonatomic, assign) NSInteger instituteIndex;

@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *UpdateLable;
@property (weak, nonatomic) IBOutlet UISwitch *pushNotificationSwitch;

- (IBAction)ChangeNotificationSwitch:(UISwitch*)sender;

- (void)downloadRequestFinished:(NSString *)fileName;

@end
