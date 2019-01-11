//
//  barPreviewingViewController.m
//  AccountingAPP
//
//  Created by 張力元 on 2018/12/24.
//  Copyright © 2018 張力元. All rights reserved.
//

#import "barPreviewingViewController.h"
#import "AccountTableViewCell.h"

@interface barPreviewingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *noRecordView;

@end

@implementation barPreviewingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    _noRecordView.hidden = _accountData.count>0;
    return _accountData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountTableViewCell"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AccountTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    [cell setCellbyAccount:_accountData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
