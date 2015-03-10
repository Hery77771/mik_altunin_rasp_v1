//
//  AMClassTableViewCell.m
//  DimlomTest
//
//  Created by Алтунин Михаил on 10.02.15.
//
//

#import "AMClassTableViewCell.h"
#import "AMClassTableViewController.h"

@implementation AMClassTableViewCell

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

- (IBAction)editMode:(id)sender {
    AMClassTableViewController* vc = self.delegate;
    [vc edit];
}
@end
