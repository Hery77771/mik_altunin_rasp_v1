//
//  AMCourse.m
//  TestDHlibxls
//
//  Created by Алтунин Михаил on 09.02.15.
//
//

#import "AMCourse.h"
#import "DHxlsReader.h"


@implementation AMCourse

-(instancetype)initWithCell:(DHcell*) cell andClassroom:(NSString*) room
{
    self = [super init];
    
    if (self) {
        _courseName = [cell str];
        
        NSArray *tempArray = [room componentsSeparatedByString:@"."];
        
        _classroom = [tempArray objectAtIndex:0];
        
        if ((cell.row - 10)%2 == 0) {
            _weak = TWFirstWeak;
        }
        else {
            _weak = TWSecondWeak;
        }
        
        int row = (cell.row - 10) / 12;
        switch (row) {
            case TDMonday:
                _day = TDMonday;
                break;
            case  TDTuesday:
                _day = TDTuesday;
                break;
            case  TDWednesday:
                _day = TDWednesday;
                break;
            case  TDThursday:
                _day = TDThursday;
                break;
            case  TDFriday:
                _day = TDFriday;
                break;
            case  TDSaturday:
                _day = TDSaturday;
                break;
            default:
                break;
        }
        
        row = (cell.row - 9) % 12;
        switch (row) {
            case 1:
            case 2:
                _time = STFirst;
                break;
            case 3:
            case 4:
                _time = STSecond;
                break;
            case  5:
            case  6:
                _time = STThird;
                break;
            case  7:
            case  8:
                _time = STFourth;
                break;
            case  9:
            case  10:
                _time = STFifth;
                break;
            case  11:
            case  0:
                _time = STSixth;
                break;
            default:
                break;
        }
    }
    return self;
}


+(NSArray*)filterCourseArray:(NSArray*) courseArray withWeak:(typeWeak) weak {
    NSMutableArray* returnArray = [NSMutableArray array];
    
    for (AMCourse* course in courseArray) {
        if (course.weak == weak) {
            [returnArray addObject:course];
        }
    }
    return returnArray;
}


+(NSArray*)filterCourseArray:(NSArray*) courseArray witwDay:(typeDay) day {
    NSMutableArray* returnArray = [NSMutableArray array];
    
    for (AMCourse* course in courseArray) {
        if (course.day == day) {
            [returnArray addObject:course];
        }
    }
    return returnArray;
}


-(NSString*)stringStartTime {
    switch (self.time) {
        case STFirst:
            return @"8:30-10:00";
            break;
        case STSecond:
            return @"10:10-11:40";
            break;
        case STThird:
            return @"11:50-13:20";
            break;
        case STFourth:
            return @"13:50-15:20";
            break;
        case STFifth:
            return @"15:30-17:00";
            break;
        case STSixth:
            return @"17:10-18:40";
            break;
    }
}

+(startTime)startTime:(NSString*)strTime {
    
    if([strTime isEqualToString:@"8:30-10:00"]) {
        return STFirst;
    } else if([strTime isEqualToString:@"10:10-11:40"]) {
        return STSecond;
    } else if([strTime isEqualToString:@"11:50-13:20"]) {
        return STThird;
    } else if([strTime isEqualToString:@"13:50-15:20"]) {
        return STFourth;
    } else if([strTime isEqualToString:@"15:30-17:00"]) {
        return STFifth;
    } else if([strTime isEqualToString:@"17:10-18:40"]) {
        return STSixth;
    }
    return INT_MAX;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_courseName forKey:@"courseName"];
    [aCoder encodeObject:_classroom forKey:@"classroom"];
    [aCoder encodeInteger:_weak forKey:@"weak"];
    [aCoder encodeInteger:_day forKey:@"day"];
    [aCoder encodeInteger:_time forKey:@"time"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _courseName = [aDecoder decodeObjectForKey:@"courseName"];
        _classroom = [aDecoder decodeObjectForKey:@"classroom"];
        _weak = [aDecoder decodeIntForKey:@"weak"];
        _day = [aDecoder decodeIntForKey:@"day"];
        _time = [aDecoder decodeIntForKey:@"time"];
    }
    return self;
}

@end
