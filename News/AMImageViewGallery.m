//
//  AMImageViewGallery.m
//  newsTest
//
//  Created by Алтунин Михаил on 09.03.15.
//  Copyright (c) 2015 Altunin Mikhail. All rights reserved.
//

#import "AMImageViewGallery.h"
#import "AMPhoto.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "MHFacebookImageViewer.h"


static CGSize CGSizeResizeToHeight(CGSize size, CGFloat height) {
    size.width *= height / size.height;
    size.height = height;
    return size;
}

@interface AMImageViewGallery () <MHFacebookImageViewerDatasource>

@property (strong,nonatomic) UIScrollView *contentView;
@property (assign,nonatomic) CGPoint point;

@end

@implementation AMImageViewGallery

- (instancetype) initWithImageArray:(NSArray *)imageArray startPoint:(CGPoint)point {
    
    self = [super init];
    if (self) {
        self.images = imageArray;
        
        [self addSubview:self.contentView];
        
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        self.imageViews = [NSMutableArray array];
        self.framesArray = [NSMutableArray array];
        
        self.point = point;
        int i = 0;
        for (id Obj in self.images) {
            
            if ([Obj isKindOfClass:[AMPhoto class]]) {
                
                AMPhoto *imageObj = (AMPhoto *)Obj;
                
                UIImageView *imageView = [[UIImageView alloc]init];
                
                imageView.backgroundColor = [UIColor grayColor];
                
                
                NSURLRequest *request = [[NSURLRequest alloc]initWithURL:imageObj.photo_url];
                
                __weak UIImageView *weakImageView = imageView;
                
                [imageView setImageWithURLRequest:request
                                 placeholderImage:nil
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              
                                              weakImageView.image = image;
                                              [self displayImage:weakImageView withImage:image withImageURL:imageObj.photo_url index:i];
                                              
                                          }
                                          failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                              
                                          }];
                i++;
                [self.framesArray addObject:imageObj];
                [self.imageViews addObject:imageView];
                
            }
        }
        
        CGSize newSize = [self setFramesToImageViews:self.imageViews imageFrames:self.framesArray toFitSize:CGSizeMake(302, 400)];
        
        self.frame = CGRectMake(self.point.x, self.point.y, newSize.width, newSize.height);
    }
    
    return self;
}


- (void) displayImage:(UIImageView*)imageView withImage:(UIImage *)image  withImageURL:(NSURL *)imageURL index:(NSInteger)index {
    
    [imageView setImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [imageView setupImageViewerWithDatasource:self initialIndex:index onOpen:^{
        
    } onClose:^{
        
    }];
}

- (NSInteger) numberImagesForImageViewer:(MHFacebookImageViewer *)imageViewer {
    return [self.images count];
}

-  (NSURL*) imageURLAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer {
    
    if ([[self.images objectAtIndex:index] isKindOfClass:[AMPhoto class]]) {
        AMPhoto *photo = [self.images objectAtIndex:index];
        
        return photo.photo_url;
        
    } else {
        return 0;
    }
}

- (UIImage *) imageDefaultAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer{
    return nil;
}

- (CGSize)setFramesToImageViews:(NSArray *)imageViews imageFrames:(NSArray *)imageFrames toFitSize:(CGSize)frameSize {
    
    int N = (int)imageViews.count;
    CGRect newFrames[N];
    
    float ideal_height = MAX(frameSize.height, frameSize.width) / N;
    float seq[N];
    float total_width = 0;
    for (int i = 0; i < [imageFrames count]; i++) {
        
        if ([[imageFrames objectAtIndex:i] isKindOfClass:[AMPhoto class]]) {
            AMPhoto *image = [imageFrames objectAtIndex:i];
            CGSize size = CGSizeMake(image.width, image.height);
            CGSize newSize = CGSizeResizeToHeight(size, ideal_height);
            newFrames[i] = (CGRect) {{0, 0}, newSize};
            seq[i] = newSize.width;
            total_width += seq[i];
            
        }
    }
    
    int K = (int)roundf(total_width / frameSize.width);
    
    float M[N][K];
    float D[N][K];
    
    for (int i = 0 ; i < N; i++)
        for (int j = 0; j < K; j++)
            D[i][j] = 0;
    
    for (int i = 0; i < K; i++)
        M[0][i] = seq[0];
    
    for (int i = 0; i < N; i++)
        M[i][0] = seq[i] + (i ? M[i-1][0] : 0);
    
    float cost;
    for (int i = 1; i < N; i++) {
        for (int j = 1; j < K; j++) {
            M[i][j] = INT_MAX;
            
            for (int k = 0; k < i; k++) {
                cost = MAX(M[k][j-1], M[i][0]-M[k][0]);
                if (M[i][j] > cost) {
                    M[i][j] = cost;
                    D[i][j] = k;
                }
            }
        }
    }
    
    int k1 = K-1;
    int n1 = N-1;
    int ranges[N][2];
    while (k1 >= 0) {
        ranges[k1][0] = D[n1][k1]+1;
        ranges[k1][1] = n1;
        
        n1 = D[n1][k1];
        k1--;
    }
    ranges[0][0] = 0;
    
    float cellDistance = 5;
    float heightOffset = cellDistance, widthOffset;
    float frameWidth;
    for (int i = 0; i < K; i++) {
        float rowWidth = 0;
        frameWidth = frameSize.width - ((ranges[i][1] - ranges[i][0]) + 2) * cellDistance;
        
        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
            rowWidth += newFrames[j].size.width;
        }
        
        float ratio = frameWidth / rowWidth;
        widthOffset = 0;
        
        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
            newFrames[j].size.width *= ratio;
            newFrames[j].size.height *= ratio;
            newFrames[j].origin.x = widthOffset + (j - (ranges[i][0]) + 1) * cellDistance;
            newFrames[j].origin.y = heightOffset;
            
            widthOffset += newFrames[j].size.width;
        }
        heightOffset += newFrames[ranges[i][0]].size.height + cellDistance;
    }
    
    if ([imageViews count] > 0) {
        for (int i = 0; i < N; i++) {
            UIImageView *imgView = imageViews[i];
            imgView.frame = newFrames[i];
            
            [self addSubview:imgView];
        }
    }
    
    return CGSizeMake(frameSize.width, heightOffset);
}


@end
