//
//  AMNewsTableViewController.h
//  newsTest
//
//  Created by Алтунин Михаил on 06.03.15.
//  Copyright (c) 2015 Altunin Mikhail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNMBottomPullToRefreshManager.h"

@interface AMNewsTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, MNMBottomPullToRefreshManagerClient>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
