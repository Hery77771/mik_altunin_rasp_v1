//
//  AMSetupTableViewController.h
//  DimlomTest
//
//  Created by Алтунин Михаил on 14.02.15.
//
//

#import <UIKit/UIKit.h>

@interface AMSetupTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *selectedInstitute;
@property (weak, nonatomic) IBOutlet UILabel *selectedCourse;
@property (weak, nonatomic) IBOutlet UILabel *selectedGroupe;
@property (strong,nonatomic) NSArray* courseArray;

@property (nonatomic, assign) NSInteger courseIndex;
@property (nonatomic, assign) NSInteger instituteIndex;

@end
