//
//  AMGroup.h
//  TestDHlibxls
//
//  Created by Алтунин Михаил on 09.02.15.
//
//

#import <Foundation/Foundation.h>

@class DHcell;

@interface AMGroup : NSObject <NSCopying>

@property (nonatomic,strong) NSString* groupName;
@property (nonatomic, assign)  int row;
@property (nonatomic, assign)  int col;
@property (nonatomic, assign)  int sheetIndex;


-(instancetype)initWithName:(NSString*) name andCell:(DHcell*) cell sheetIndex:(int) index;


@end
