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

@interface AMOneNewsTableViewController () <UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>

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




-(NSString*) cleanStringOfSpaces:(NSString*)string {
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSRange range = [string rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
    string = [string stringByReplacingCharactersInRange:range withString:@""];
    return string;
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



- (IBAction)openMatiCom:(id)sender
{
    [[self actionSheet] showInView:[self view]];
}

#pragma mark UIActionSheetDelegate

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

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        
        return [NSObject heightLabelOfTextForString:self.text fontSize:11.f widthLabel:300] + [NSObject heightLabelOfTextForString:self.name fontSize:15.f widthLabel:300] + DATE_LABEL;
    } else
        return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return CGFLOAT_MIN;
    return tableView.sectionHeaderHeight;
}



#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* indentifier = @"oneNewsCell";
    
    AMOneNewsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (!cell) {
        cell = [[AMOneNewsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    cell.nameLable.text = [self cleanStringOfSpaces:self.name];
    cell.textLable.text = self.text;
    
    NSRange range = [self.date rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
    self.date = [self.date stringByReplacingCharactersInRange:range withString:@""];
    self.date = [self.date stringByReplacingOccurrencesOfString:@"Создано:" withString:@"Опубликовано:"];
    
    cell.dateLable.text = [self cleanStringOfSpaces:self.date];
    
    CGRect newFrame =  cell.nameLable.frame;
    newFrame.size.height = [NSObject heightLabelOfTextForString:self.name fontSize:15.f widthLabel:300];
    cell.nameLable.frame = newFrame;
    
    newFrame = CGRectMake(10.f, newFrame.size.height, 300, 20);
    newFrame.size.height = [NSObject heightLabelOfTextForString:self.text fontSize:11.f widthLabel:300];
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

@end
