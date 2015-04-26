//
//  AMReaderManager.m
//  DimlomTest
//
//  Created by Алтунин Михаил on 10.02.15.
//
//

#import "AMReaderManager.h"
#import "AMGroup.h"
#import "AMCourse.h"

@interface AMReaderManager ()

@property (strong,nonatomic) NSString* filePath;
@property (strong,nonatomic) DHxlsReader* reader;

@end

@implementation AMReaderManager

extern int xls_debug;

- (instancetype)initWithPath:(NSString*) path
{
    self = [super init];
    if (self) {
        self.filePath = [[NSString alloc]initWithString:path];
        DHxlsReader* reader = [DHxlsReader xlsReaderWithPath:path];
        
        if (!reader) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Скачайте расписание в меню \"Настройки\"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        } else {
            assert(reader);
            self.reader = reader;
            [self initGroupArray];
        }
    }
    return self;
}


-(void)initGroupArray {
    
    self.groupArray = [[NSMutableArray alloc]init];
    
    int row = 8;
    int col = 5;
    int index = 0;
    
    while (YES) {
        while(YES) {
            DHcell *cell = [self.reader cellInWorkSheetIndex:index row:row col:col];
            if(cell.type == cellBlank)
                break;
            
            //NSLog(@"\nCell %d %d %d:%@",index,row,col, [cell str]);
            [self.groupArray addObject:[[AMGroup alloc]initWithName:[cell str] andCell:cell sheetIndex:index]];
            col+=2;
        }
        
        col = 5;
        index++;
        
        if ([self.reader numberOfSheets] == index) {
            break;
        }
    }
}

-(NSArray*)getCourseArrayOfGroup:(AMGroup*) group {
    NSMutableArray* courseArray = [NSMutableArray array];
    int row = group.row + 1;
    int col = group.col;
    int  index = group.sheetIndex;
    
    for (int i = row; i <= 82; i++) {
        DHcell *cell = [self.reader cellInWorkSheetIndex:index row:i col:col];
        if ([cell str]) {
            DHcell *classroomCell = [self.reader cellInWorkSheetIndex:index row:i col:col+1];
            [courseArray addObject:[[AMCourse alloc]initWithCell:cell andClassroom:[classroomCell str]]];
        }
    }
    
    return courseArray;
}

-(NSArray*)getCourseArrayOfGroupName:(NSString*) groupName {
    AMGroup* group = nil;
    for (AMGroup* mGroup in self.groupArray) {
        if ([mGroup.groupName isEqual:groupName]) {
            group = mGroup;
            break;
        }
    }
    
    if (group) {
        NSMutableArray* courseArray = [NSMutableArray array];
        int row = group.row + 1;
        int col = group.col;
        int  index = group.sheetIndex;
        
        for (int i = row; i <= 82; i++) {
            DHcell *cell = [self.reader cellInWorkSheetIndex:index row:i col:col];
            if ([cell str]) {
                DHcell *classroomCell = [self.reader cellInWorkSheetIndex:index row:i col:col+1];
                [courseArray addObject:[[AMCourse alloc]initWithCell:cell andClassroom:[classroomCell str]]];
            }
        }
        
        return courseArray;
    }
    
    else {
        return nil;
    }
}

@end
