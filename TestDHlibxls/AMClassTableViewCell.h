//
//  AMClassTableViewCell.h
//  DimlomTest
//
//  Created by Алтунин Михаил on 10.02.15.
//
//

#import <UIKit/UIKit.h>

@interface AMClassTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet UILabel *classRoom;
@property (weak, nonatomic) IBOutlet UILabel *startTime;

@end
