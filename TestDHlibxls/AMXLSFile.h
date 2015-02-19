//
//  AMXLSFile.h
//  DimlomTest
//
//  Created by Алтунин Михаил on 18.02.15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AMObjects.h"


@interface AMXLSFile : AMObjects

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * course;
@property (nonatomic, retain) NSString * institute;

@end
