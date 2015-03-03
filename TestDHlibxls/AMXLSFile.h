//
//  AMxlsFile.h
//  DiplomTest
//
//  Created by Алтунин Михаил on 03.03.15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AMObjects.h"


@interface AMxlsFile : AMObjects

@property (nonatomic, retain) NSDate * changeDate;
@property (nonatomic, retain) NSString * name;

@end
