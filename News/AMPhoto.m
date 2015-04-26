//
//  AMPhoto.m
//  newsTest
//
//  Created by Алтунин Михаил on 09.03.15.
//  Copyright (c) 2015 Altunin Mikhail. All rights reserved.
//

#import "AMPhoto.h"

@implementation AMPhoto

- (instancetype)initWithURL:(NSURL *) url {
    
    self = [super init];
    if (self) {
        self.photo_url = url;
    }
    return self;
}

@end
