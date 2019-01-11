//
//  DateTimeManager.h
//  AccountingAPP
//
//  Created by 張力元 on 2018/12/18.
//  Copyright © 2018 張力元. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateTimeManager : NSObject
+ (NSString *)NSDateToNSString:(NSDate *)date;
+ (NSDate *)NextDay:(NSDate *)date isAdd:(BOOL)isAdd;
+ (double)NSDateToDouble:(NSDate *)date;
+ (NSDate *)DoubleToNSDate:(double)doubleTime;
+ (int)getSumOfDaysInMonth:(NSString *)year month:(NSString *)month;
//type:0 只有日期
+ (NSDate *)NSStringToDate:(NSString *)timeString type:(int)type;
@end

NS_ASSUME_NONNULL_END
