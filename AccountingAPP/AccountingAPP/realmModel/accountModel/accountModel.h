//
//  accountModel.h
//  AccountingAPP
//
//  Created by 張力元 on 2018/12/17.
//  Copyright © 2018 張力元. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface accountModel : RLMObject
@property int month;
@property int year;
@property int day;
@property double date;
@property NSString *title;
@property int price;
@property NSString *type;
@property double refreshTime;
@property NSString *remark;
@end

NS_ASSUME_NONNULL_END
