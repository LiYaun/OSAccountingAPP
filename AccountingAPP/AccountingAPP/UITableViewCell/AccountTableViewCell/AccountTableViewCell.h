//
//  AccountTableViewCell.h
//  AccountingAPP
//
//  Created by 張力元 on 2018/12/19.
//  Copyright © 2018 張力元. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol AccountTableViewCellDelegate <NSObject>
- (void)deleteAccount:(accountModel *)model;
@end

@interface AccountTableViewCell : UITableViewCell
@property (assign, nonatomic) id<AccountTableViewCellDelegate> delegate;
- (void)setCellbyAccount:(accountModel *)model;
@end

NS_ASSUME_NONNULL_END
