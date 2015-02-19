//
//  AMWeekTabBarController.m
//  DimlomTest
//
//  Created by Алтунин Михаил on 11.02.15.
//
//

#import "AMWeekTabBarController.h"
#import "AMClassTableViewController.h"
#import "AMCourse.h"
#import "AMDataManager.h"

@interface AMWeekTabBarController () <UITabBarControllerDelegate>

@end

@implementation AMWeekTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    NSArray* controllers = self.viewControllers;
    UINavigationController* firstNV = (UINavigationController*)[controllers objectAtIndex:0];
    UINavigationController* secondNV = (UINavigationController*)[controllers objectAtIndex:1];
    
    AMClassTableViewController* firstWeek = [firstNV.viewControllers firstObject];
    AMClassTableViewController* secondWeek = [secondNV.viewControllers firstObject];
    
    NSArray* courseArray = [NSKeyedUnarchiver unarchiveObjectWithData:self.customSchedule.courseArray];
    
    firstWeek.courseArray = [AMCourse filterCourseArray:courseArray withWeak:TWFirstWeak];
    secondWeek.courseArray = [AMCourse filterCourseArray:courseArray withWeak:TWSecondWeak];
    
    firstWeek.weak = TWFirstWeak;
    secondWeek.weak = TWSecondWeak;
    
    UISwipeGestureRecognizer* gr = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:(@selector(swipeRight))];
    gr.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:gr];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)swipeRight {
    
    NSArray* controllers = self.viewControllers;
    UINavigationController* firstNV = (UINavigationController*)[controllers objectAtIndex:0];
    UINavigationController* secondNV = (UINavigationController*)[controllers objectAtIndex:1];
    
    AMClassTableViewController* firstWeek = [firstNV.viewControllers firstObject];
    AMClassTableViewController* secondWeek = [secondNV.viewControllers firstObject];
    
    NSArray* courseArray = [firstWeek.courseArray arrayByAddingObjectsFromArray:secondWeek.courseArray];
    
    [[AMDataManager sharedManager]updateSchedule:self.customSchedule withCourseArray:courseArray];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
