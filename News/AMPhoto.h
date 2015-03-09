//
//  AMPhoto.h
//  newsTest
//
//  Created by Алтунин Михаил on 09.03.15.
//  Copyright (c) 2015 Altunin Mikhail. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMPhoto : NSObject

@property (assign,nonatomic) NSInteger width;
@property (assign,nonatomic) NSInteger height;
@property (strong,nonatomic) NSURL *photo_url;

- (instancetype)initWithURL:(NSURL *) url;

@end
