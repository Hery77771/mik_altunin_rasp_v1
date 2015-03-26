//
//  AMPickerSetupViewController.h
//  DimlomTest
//
//  Created by Алтунин Михаил on 14.02.15.
//
//

#import <UIKit/UIKit.h>


typedef enum {
    TSVCCourse        =1<<0,
    TSVCInstitute     =1<<1,
    TSVCTime          =1<<2,
} typeSetupViewController;


@interface AMPickerSetupViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *dataSource;
@property (weak, nonatomic) id delegate;
@property (nonatomic,assign) typeSetupViewController type;

@end
