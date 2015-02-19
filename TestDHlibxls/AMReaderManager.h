//
//  AMReaderManager.h
//  DimlomTest
//
//  Created by Алтунин Михаил on 10.02.15.
//
//

#import <Foundation/Foundation.h>
#import "DHxlsReader.h"

@class AMGroup;

@interface AMReaderManager : NSObject

@property (strong,nonatomic) NSMutableArray* groupArray;

- (instancetype)initWithPath:(NSString*) path;
-(NSArray*)getCourseArrayOfGroup:(AMGroup*) group;
-(NSArray*)getCourseArrayOfGroupName:(NSString*) groupName;

@end
