//
//  AMOneNewsTableViewController.h
//  newsTest
//
//  Created by Алтунин Михаил on 09.03.15.
//  Copyright (c) 2015 Altunin Mikhail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Catigoryes.h"

@interface AMOneNewsTableViewController : UITableViewController 
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *date;
@property (strong,nonatomic) NSString* newsLink;
@property (nonatomic, retain) UIActionSheet *actionSheet;

- (IBAction)openMatiCom:(id)sender;

@end
