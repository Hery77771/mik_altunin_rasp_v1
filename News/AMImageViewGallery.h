//
//  AMImageViewGallery.h
//  newsTest
//
//  Created by Алтунин Михаил on 09.03.15.
//  Copyright (c) 2015 Altunin Mikhail. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AMImageViewGalleryDelegete;

@interface AMImageViewGallery : UIView

@property (weak,nonatomic) id <AMImageViewGalleryDelegete> delegate;

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSMutableArray *framesArray;

- (instancetype) initWithImageArray:(NSArray *)imageArray startPoint:(CGPoint)point;

@end


@protocol AMImageViewGalleryDelegete <NSObject>

@end

