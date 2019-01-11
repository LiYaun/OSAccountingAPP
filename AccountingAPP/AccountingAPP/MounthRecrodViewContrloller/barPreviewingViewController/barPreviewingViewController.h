//
//  barPreviewingViewController.h
//  AccountingAPP
//
//  Created by 張力元 on 2018/12/24.
//  Copyright © 2018 張力元. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface barPreviewingViewController : UIViewController
@property (strong, nonatomic) RLMResults<accountModel *> *accountData;
@end

NS_ASSUME_NONNULL_END
