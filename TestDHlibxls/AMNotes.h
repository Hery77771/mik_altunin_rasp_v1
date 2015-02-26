//
//  AMNotes.h
//  DiplomTest
//
//  Created by Алтунин Михаил on 23.02.15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AMObjects.h"


@interface AMNotes : AMObjects

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSDate * addTime;

@end
