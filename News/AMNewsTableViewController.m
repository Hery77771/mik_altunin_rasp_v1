//
//  AMNewsTableViewController.m
//  newsTest
//
//  Created by Алтунин Михаил on 06.03.15.
//  Copyright (c) 2015 Altunin Mikhail. All rights reserved.
//

#import "AMNewsTableViewController.h"
#import "HTMLParser.h"
#import "AMNewsCellTableViewCell.h"
#import "AMOneNewsTableViewController.h"
#import "AMPhoto.h"

#define DELTA_LABEL 30

@interface AMNewsTableViewController ()
@property (nonatomic,assign) int pageIndex;
@property (strong,nonatomic) NSMutableArray* newsArray;
@property (assign,nonatomic) BOOL loadingData;
@property (assign,nonatomic) BOOL emptyTable;
@property (strong,nonatomic) MNMBottomPullToRefreshManager *pullToRefreshManager_;
@end

@implementation AMNewsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.newsArray = [NSMutableArray array];
    //self.loadingData = YES;
    //[self getNewsFromServer];
    self.emptyTable = YES;
    self.pageIndex = 0;
    
    self.pullToRefreshManager_ = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:self.tableView withClient:self];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadTable {
    
    if (!self.loadingData)
    {
        self.loadingData = YES;
        [self getNewsFromServer];
    }
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [self.pullToRefreshManager_ relocatePullToRefreshView];
}


#pragma mark - API

-(void)getNewsFromServer {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        if (self.emptyTable) {
            self.emptyTable = NO;
            NSMutableArray *newPaths = [NSMutableArray array];
            [newPaths addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
            [newPaths addObject:[NSIndexPath indexPathForRow:1 inSection:0]];
            [newPaths addObject:[NSIndexPath indexPathForRow:2 inSection:0]];
            [newPaths addObject:[NSIndexPath indexPathForRow:3 inSection:0]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            });
        }
        
        
        NSMutableArray *newPaths = [NSMutableArray array];
        NSArray* news = [self loadNextNewsPage];
        
        [self.newsArray addObjectsFromArray:news];
        
        
        for (int i = (int)[self.newsArray count] - (int)[news count]; i < [self.newsArray count]; i++) {
            [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            self.loadingData = NO;
            [self.pullToRefreshManager_ tableViewReloadFinished];
        });
    });
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.emptyTable) {
        return 4;
    } else {
        return [self.newsArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.emptyTable) {
        static NSString* indentifier;
        switch (indexPath.row) {
            case 1:
                indentifier = @"logo1";
                break;
            case 2:
                indentifier = @"logo2";
                break;
            default:
                indentifier = @"cell";
                break;
        }
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
        }
        
        if (indexPath.row == 3) {
            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:10.0], NSFontAttributeName,[UIColor grayColor],NSForegroundColorAttributeName,nil];
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Для загрузки новостей потяните вверх" attributes:attributesDictionary];
            cell.detailTextLabel.attributedText = string;
        }
        
        return cell;
        
    } else {
        static NSString* indentifier = @"newsCell";
        
        AMNewsCellTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        
        if (!cell) {
            cell = [[AMNewsCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        }
        
        NSDictionary* news = [self.newsArray objectAtIndex:indexPath.row];
        
        NSString *name = [news objectForKey:@"title"];
        NSRange range = [name rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
        name = [name stringByReplacingCharactersInRange:range withString:@""];
        
        NSString* text = [news objectForKey:@"text"];
        range = [text rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
        text = [text stringByReplacingCharactersInRange:range withString:@""];
        
        cell.name.text = [name
                          stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        cell.text.text = text;
        
        CGSize constrainedSize = CGSizeMake(cell.text.frame.size.width, 100);
        
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:10.0], NSFontAttributeName,nil];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:attributesDictionary];
        
        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        if (requiredHeight.size.width > cell.text.frame.size.width) {
            requiredHeight = CGRectMake(0,0, cell.text.frame.size.width, requiredHeight.size.height);
        }
        CGRect newFrame = cell.text.frame;
        newFrame.size.height = requiredHeight.size.height;
        cell.text.frame = newFrame;
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!self.emptyTable) {
        AMOneNewsTableViewController *dest = [self.storyboard instantiateViewControllerWithIdentifier:@"oneNews"];
        [dest setNewsLink:[[self.newsArray objectAtIndex:indexPath.row] objectForKey:@"link"]];
        [dest setText:[[self.newsArray objectAtIndex:indexPath.row] objectForKey:@"text"]];
        [dest setName:[[self.newsArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
        [dest setDate:[[self.newsArray objectAtIndex:indexPath.row] objectForKey:@"date"]];
        [self.navigationController pushViewController:dest animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.emptyTable) {
        return 120;
    } else {
        NSDictionary* news = [self.newsArray objectAtIndex:indexPath.row];
        NSString* text = [news objectForKey:@"text"];
        
        
        AMNewsCellTableViewCell *Cell = (AMNewsCellTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        
        CGSize constrainedSize = CGSizeMake(Cell.text.frame.size.width, 100);
        
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:10.0], NSFontAttributeName,nil];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:attributesDictionary];
        
        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        if (requiredHeight.size.width > Cell.text.frame.size.width) {
            requiredHeight = CGRectMake(0,0, Cell.text.frame.size.width, requiredHeight.size.height);
        }
        
        CGRect newFrame = Cell.text.frame;
        newFrame.size.height = requiredHeight.size.height;
        
        return newFrame.size.height + DELTA_LABEL;
    }
}


-(NSMutableArray*)loadNextNewsPage {
    NSURL *tutorialsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://mati.ru/index.php/novosti/novosti?limitstart=%d",self.pageIndex]];
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithData:tutorialsHtmlData error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
    }
    
    HTMLNode *bodyNode = [parser body];
    
    NSArray *newsTitle = [bodyNode findChildTags:@"h2"];
    NSArray *newsText = [bodyNode findChildrenWithAttribute:@"class" matchingName:@"article-intro" allowPartial:NO];
    NSArray *newsDate = [bodyNode findChildrenWithAttribute:@"class" matchingName:@"article-info muted" allowPartial:NO];
    
    NSMutableArray *articlesDone = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (HTMLNode *postNode in newsTitle) {
        NSMutableDictionary *article = [[NSMutableDictionary alloc] init];
        NSArray *aTags = [postNode findChildTags:@"a"];
        if (aTags.count > 0) {
            HTMLNode *aOne = [aTags objectAtIndex:0];
            NSString *nameOfArticle = [aOne contents];
            NSString *link = [aOne getAttributeNamed:@"href"];
            NSString *text = [self getText:[newsText objectAtIndex:i]];
            NSString *date = [[newsDate objectAtIndex:i] allContents];
            [article setObject:nameOfArticle forKey:@"title"];
            [article setObject:date forKey:@"date"];
            [article setObject:link forKey:@"link"];
            [article setObject:text forKey:@"text"];
            [articlesDone addObject:article];
            i++;
        }
    }
    
    self.pageIndex += 5;
    return articlesDone;
}

-(NSString*)getText:(HTMLNode*)node {
    NSArray *pTags = [node findChildTags:@"p"];
    NSMutableString* text = [[NSMutableString alloc]init];
    if (pTags.count > 0) {
        for (HTMLNode *pNode in pTags) {
            if ([pNode findChildTags:@"img"].count > 0)
                continue;
            else
                [text appendString:[NSString stringWithFormat:@"%@ %@",[pNode allContents],@"\n\n"]];
        }
    }
    return text;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return CGFLOAT_MIN;
    return tableView.sectionHeaderHeight;
}

#pragma mark -
#pragma mark MNMBottomPullToRefreshManagerClient

/**
 * This is the same delegate method as UIScrollView but required in MNMBottomPullToRefreshManagerClient protocol
 * to warn about its implementation. Here you have to call [MNMBottomPullToRefreshManager tableViewScrolled]
 *
 * Tells the delegate when the user scrolls the content view within the receiver.
 *
 * @param scrollView: The scroll-view object in which the scrolling occurred.
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pullToRefreshManager_ tableViewScrolled];
}

/**
 * This is the same delegate method as UIScrollView but required in MNMBottomPullToRefreshClient protocol
 * to warn about its implementation. Here you have to call [MNMBottomPullToRefreshManager tableViewReleased]
 *
 * Tells the delegate when dragging ended in the scroll view.
 *
 * @param scrollView: The scroll-view object that finished scrolling the content view.
 * @param decelerate: YES if the scrolling movement will continue, but decelerate, after a touch-up gesture during a dragging operation.
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.pullToRefreshManager_ tableViewReleased];
}

/**
 * Tells client that refresh has been triggered
 * After reloading is completed must call [MNMBottomPullToRefreshManager tableViewReloadFinished]
 *
 * @param manager PTR manager
 */
- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager {
    
    [self loadTable];
}


@end
