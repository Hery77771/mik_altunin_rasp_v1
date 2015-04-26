//
//  AMNotes.h
//  DiplomTest
//
//  Created by Алтунин Михаил on 03.03.15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AMObjects.h"


@interface AMNotes : AMObjects

@property (nonatomic, retain) NSDate * addTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * text;

@end
