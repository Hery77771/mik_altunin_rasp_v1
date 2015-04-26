//
//  AMNotesNotificationCell.h
//  DiplomTest
//
//  Created by Altunin Mikhail on 23.04.15.
//
//

#import <UIKit/UIKit.h>

@interface AMNotesNotificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *NotificationSwitch;
@property (weak, nonatomic) IBOutlet UILabel *StatusLable;
@property (weak, nonatomic) IBOutlet UILabel *TimeLable;
- (IBAction)NotificationSwithChanged:(id)sender;

@end
