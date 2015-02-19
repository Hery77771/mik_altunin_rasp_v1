//
//  AMGroup.m
//  TestDHlibxls
//
//  Created by Алтунин Михаил on 09.02.15.
//
//

#import "AMGroup.h"
#import "DHxlsReader.h"


@implementation AMGroup

-(instancetype)initWithName:(NSString*) name andCell:(DHcell*) cell sheetIndex:(int) index {
    self = [super init];
    if (self) {
        self.groupName = name;
        
        _row = [cell row];
        _col = [cell col];
        _sheetIndex = index;
    }
    return self;
}


- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        [copy setRow:self.row];
        [copy setCol:self.col];
        [copy setSheetIndex:self.sheetIndex];
        [copy setGroupName:self.groupName];
    }
    
    return copy;
}

@end
