//
//  AMSetupCourseViewController.m
//  DimlomTest
//
//  Created by Алтунин Михаил on 14.02.15.
//
//

#import "AMPickerSetupViewController.h"
#include "AMSetupTableViewController.h"
#include "AMAddCourseTableViewController.h"

@interface AMPickerSetupViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation AMPickerSetupViewController

@synthesize pickerView;
@synthesize dataSource;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if (self.type == TSVCCourse) {
        self.dataSource = [NSArray arrayWithObjects:
                           @"Первый курс",
                           @"Второй курс",
                           @"Третий курс",
                           @"Четвертый курс",
                           @"Первый курс (магистратура)",nil];

    }
    else if (self.type == TSVCInstitute) {
        self.dataSource = [NSArray arrayWithObjects:
                           @"1 институт",
                           @"2 институт",
                           @"3 институт",
                           @"4 институт",nil];
    } else if (self.type == TSVCTime) {
        self.dataSource = [NSArray arrayWithObjects:
                           @"8:30-10:00",
                           @"10:10-11:40",
                           @"11:50-13:20",
                           @"13:50-15:20",
                           @"15:30-17:00",
                           @"17:10-18:40",nil];
    }
    [self selectPicker];
}


-(void)selectPicker {
    
    if (self.type == TSVCCourse) {
        AMSetupTableViewController* setupVC = self.delegate;
        if (![setupVC.selectedCourse.text isEqualToString:@"Выберите курс"]) {
        [self.pickerView selectRow:[self.dataSource indexOfObject:setupVC.selectedCourse.text] inComponent:nil animated:YES];
        }
        
    }
    else if (self.type == TSVCInstitute) {
        AMSetupTableViewController* setupVC = self.delegate;
        if (![setupVC.selectedInstitute.text isEqualToString:@"Выберите институт"]) {
        [self.pickerView selectRow:[self.dataSource indexOfObject:setupVC.selectedInstitute.text] inComponent:nil animated:YES];
        }
    }
    else if (self.type == TSVCTime) {
        AMAddCourseTableViewController* addVC = self.delegate;
        if (![addVC.courseTimeLable.text isEqualToString:@""]) {
        [self.pickerView selectRow:[self.dataSource indexOfObject:addVC.courseTimeLable.text] inComponent:nil animated:YES];
        }
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView
numberOfRowsInComponent:(NSInteger)component
{
    return dataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [dataSource objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (self.type == TSVCCourse) {
        AMSetupTableViewController* setupVC = self.delegate;
        setupVC.selectedCourse.text = [dataSource objectAtIndex:row];
        setupVC.courseIndex = row + 1;
        
    }
    else if (self.type == TSVCInstitute) {
        AMSetupTableViewController* setupVC = self.delegate;
        setupVC.selectedInstitute.text = [dataSource objectAtIndex:row];
        setupVC.instituteIndex = row + 1;
    }
    else if (self.type == TSVCTime) {
        AMAddCourseTableViewController* addVC = self.delegate;
        addVC.courseTimeLable.text = [dataSource objectAtIndex:row];
    }
}


@end
