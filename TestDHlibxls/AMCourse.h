//
//  AMCourse.h
//  TestDHlibxls
//
//  Created by Алтунин Михаил on 09.02.15.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    TWFirstWeak        =1<<0,
    TWSecondWeak       =1<<1,
} typeWeak;

typedef enum {
    TDMonday      = 0,
    TDTuesday     = 1,
    TDWednesday   = 2,
    TDThursday    = 3,
    TDFriday      = 4,
    TDSaturday    = 5,
} typeDay;


typedef enum {
    STFirst    = 2,
    STSecond   = 4,
    STThird    = 6,
    STFourth   = 8,
    STFifth    = 10,
    STSixth    = 0,
} startTime;

@class DHcell;

@interface AMCourse : NSObject <NSCoding>

@property (nonatomic,strong) NSString* courseName;
@property (nonatomic,strong) NSString* classroom;
//@property (nonatomic,strong) NSString* teacherName;
@property (nonatomic,assign) typeWeak weak;
@property (nonatomic,assign) typeDay day;
@property (nonatomic,assign) startTime time;

-(instancetype)initWithCell:(DHcell*) cell andClassroom:(NSString*) room;
-(NSString*)stringStartTime;

+(NSArray*)filterCourseArray:(NSArray*) courseArray withWeak:(typeWeak) weak;
+(NSArray*)filterCourseArray:(NSArray*) courseArray witwDay:(typeDay) day;
+(startTime)startTime:(NSString*)strTime;

@end
