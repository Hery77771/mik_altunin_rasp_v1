//
//  AMOneNewsTableViewController.m
//  newsTest
//
//  Created by Алтунин Михаил on 09.03.15.
//  Copyright (c) 2015 Altunin Mikhail. All rights reserved.
//

#import "AMOneNewsTableViewController.h"
#import "HTMLParser.h"
#import "AMOneNewsTableViewCell.h"

#define DATE_LABEL 20

@interface AMOneNewsTableViewController () <UIActionSheetDelegate>

@end

@implementation AMOneNewsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)heightLabelOfTextForString:(NSString *)aString fontSize:(CGFloat)fontSize widthLabel:(CGFloat)width {
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        
        return [self heightLabelOfTextForString:self.text fontSize:11.f widthLabel:300] + [self heightLabelOfTextForString:self.name fontSize:15.f widthLabel:300] + DATE_LABEL;
    } else
        return 0;
}


-(NSString*) cleanStringOfSpaces:(NSString*)string {
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSRange range = [string rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
    string = [string stringByReplacingCharactersInRange:range withString:@""];
    return string;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* indentifier = @"oneNewsCell";
    
    AMOneNewsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (!cell) {
        cell = [[AMOneNewsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    cell.nameLable.text = [self cleanStringOfSpaces:self.name];
    cell.textLable.text = self.text;
    cell.dateLable.text = [self cleanStringOfSpaces:self.date];
    
    CGRect newFrame =  cell.nameLable.frame;
    newFrame.size.height = [self heightLabelOfTextForString:self.name fontSize:15.f widthLabel:300];
    cell.nameLable.frame = newFrame;
    
    newFrame = CGRectMake(10.f, newFrame.size.height, 300, 20);
    newFrame.size.height = [self heightLabelOfTextForString:self.text fontSize:11.f widthLabel:300];
    cell.textLable.frame = newFrame;
    
    newFrame = cell.dateLable.frame;
    newFrame.origin.y = cell.textLable.frame.size.height + cell.nameLable.frame.size.height;
    cell.dateLable.frame = newFrame;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return CGFLOAT_MIN;
    return tableView.sectionHeaderHeight;
}


- (UIActionSheet *)actionSheet {
    
    if (_actionSheet == nil) {
        
        NSString *cancelButtonTitle = @"Cancel";
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            cancelButtonTitle = nil;
        }
        
        if ([UIPrintInteractionController isPrintingAvailable]) {
            _actionSheet = [[UIActionSheet alloc]
                            initWithTitle:nil
                            delegate:self
                            cancelButtonTitle:cancelButtonTitle
                            destructiveButtonTitle:nil
                            otherButtonTitles:@"Открыть в Safari",
                            @"Копировать ссылку",
                            nil];
        } else {
            _actionSheet = [[UIActionSheet alloc]
                            initWithTitle:nil
                            delegate:self
                            cancelButtonTitle:cancelButtonTitle
                            destructiveButtonTitle:nil
                            otherButtonTitles:@"Открыть в Safari",
                            @"Копировать ссылку", nil];
        }
    } 
    
    return _actionSheet;
}


- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mati.ru/%@",self.newsLink]]];
            break;
            
        case 1:
            [[UIPasteboard generalPasteboard] setString:[NSString stringWithFormat:@"http://mati.ru/%@",self.newsLink]];
            break;
        default:
            break;
    }
}

- (IBAction)openMatiCom:(id)sender
{
    [[self actionSheet] showInView:[self view]];
}

@end
