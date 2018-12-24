//
//  AccountTableViewCell.m
//  AccountingAPP
//
//  Created by 張力元 on 2018/12/19.
//  Copyright © 2018 張力元. All rights reserved.
//

#import "AccountTableViewCell.h"

@interface AccountTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *typeLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *costLAble;

@property (strong, nonatomic) accountModel *model;
@end

@implementation AccountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellbyAccount:(accountModel *)model{
    _model = model;
    _typeLable.text = [NSString stringWithFormat:@"%@：",model.type];
    _titleLable.text = model.title;
    _costLAble.text = [NSString stringWithFormat:@"%d",model.price];
}

- (IBAction)deleteAccount:(id)sender {
    [_delegate deleteAccount:_model];
}

@end
