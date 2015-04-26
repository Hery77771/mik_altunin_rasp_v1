//
//  AMNotesNotificationCell.m
//  DiplomTest
//
//  Created by Altunin Mikhail on 23.04.15.
//
//

#import "AMNotesNotificationCell.h"

@implementation AMNotesNotificationCell

- (IBAction)NotificationSwithChanged:(UISwitch*)sender {
    if (sender.isOn) {
        self.StatusLable.text = @"Напомнить";
        [self.TimeLable setHidden:NO];
    } else {
        self.StatusLable.text = @"Напоминание";
        [self.TimeLable setHidden:YES];
    }
}
@end
