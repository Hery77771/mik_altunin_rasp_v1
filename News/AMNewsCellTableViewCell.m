//
//  AMNewsCellTableViewCell.m
//  newsTest
//
//  Created by Алтунин Михаил on 06.03.15.
//  Copyright (c) 2015 Altunin Mikhail. All rights reserved.
//

#import "AMNewsCellTableViewCell.h"

@implementation AMNewsCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
