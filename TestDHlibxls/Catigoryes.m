//
//  NSString+Catigoryes.m
//  DiplomTest
//
//  Created by Алтунин Михаил on 10.03.15.
//
//

#import "Catigoryes.h"

@implementation  NSObject (MyCGFloatCatigory)

+ (CGFloat)heightLabelOfTextForString:(NSString *)aString fontSize:(CGFloat)fontSize widthLabel:(CGFloat)width {
    
    UIFont* font = [UIFont systemFontOfSize:fontSize];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0;
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentLeft];
    
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, paragraph, NSParagraphStyleAttributeName,shadow, NSShadowAttributeName, nil];
    
    CGRect rect = [aString boundingRectWithSize:CGSizeMake(300, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:attributes
                                        context:nil];
    
    return rect.size.height;
}


@end
