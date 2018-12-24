//
//  NewRecordViewController.h
//  AccountingAPP
//
//  Created by 張力元 on 2018/12/18.
//  Copyright © 2018 張力元. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewRecordViewController : UIViewController
@property (strong, nonatomic) accountModel *model;
@property (assign, nonatomic) bool isEdit;
@property (strong, nonatomic) NSDate* nowDate;
@end

NS_ASSUME_NONNULL_END
