//
//  MounthRecrodViewContrloller.h
//  AccountingAPP
//
//  Created by 張力元 on 2018/12/17.
//  Copyright © 2018 張力元. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MounthRecrodViewContrloller : UIViewController
@property (assign, nonatomic) int nowMonth;
@property (assign, nonatomic) int nowYear;

- (void)updateAccData;
- (void)updateEarliestData;
@end

NS_ASSUME_NONNULL_END
