//
//  testDiplom
//
//  Created by Алтунин Михаил on 09.02.15.
//  Copyright (c) 2015 Altunin Mikhail. All rights reserved.
//


#import "ViewController.h"

#import "DHxlsReader.h"
#import "AMGroup.h"
#import "AMCourse.h"

extern int xls_debug;

@interface ViewController ()

@property (strong,nonatomic) NSMutableArray* groupArray;
@property (strong,nonatomic) NSMutableArray* courseArray;

@end

@implementation ViewController
{
	IBOutlet UITextView *textView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.groupArray = [NSMutableArray array];
    self.courseArray = [NSMutableArray array];

	NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"raspis.xls"];
	//NSString *path = @"raspis.xls";

	// xls_debug = 1; // good way to see everything in the Excel file
	
	DHxlsReader *reader = [DHxlsReader xlsReaderWithPath:path];
	assert(reader);

    int row = 8;
    int col = 5;
    int index = 0;

    while (YES) {
        while(YES) {
            DHcell *cell = [reader cellInWorkSheetIndex:index row:row col:col];
            if(cell.type == cellBlank)
                break;
            
            //NSLog(@"\nCell %d %d %d:%@",index,row,col, [cell str]);
            [self.groupArray addObject:[[AMGroup alloc]initWithName:[cell str] andCell:cell sheetIndex:index]];
            col+=2;
        }
        
        col = 5;
        index++;
        
        if ([reader numberOfSheets] == index) {
            break;
        }
    }

    
    AMGroup* test = [self.groupArray firstObject];
    
    row = test.row + 1;
    col = test.col;
    index = test.sheetIndex;
    
    for (int i = row; i <= 82; i++) {
            DHcell *cell = [reader cellInWorkSheetIndex:index row:i col:col];
        if ([cell str]) {
            //NSLog(@"\nCell %d %d %d   :%@",index,i,col, [cell str]);
            DHcell *classroomCell = [reader cellInWorkSheetIndex:index row:i col:col+1];
            [self.courseArray addObject:[[AMCourse alloc]initWithCell:cell andClassroom:[classroomCell str]]];
        }
    }
    
}

- (void)viewDidUnload
{
	textView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@",[[self.courseArray firstObject]courseName]);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
