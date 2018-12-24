//
//  DateTimeManager.m
//  AccountingAPP
//
//  Created by 張力元 on 2018/12/18.
//  Copyright © 2018 張力元. All rights reserved.
//

#import "DateTimeManager.h"

@implementation DateTimeManager
+ (NSString *)NSDateToNSString:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSDate *)NextDay:(NSDate *)date isAdd:(BOOL)isAdd{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
    NSDate *newDate;
    if (isAdd)
        newDate = [date dateByAddingTimeInterval:24*60*60];
    else
        newDate = [date dateByAddingTimeInterval:-24*60*60];
    
    return newDate;
}

+ (double)NSDateToDouble:(NSDate *)date{
    NSTimeInterval interval = [date timeIntervalSince1970];
    return interval * 1000;
}

+ (NSDate *)DoubleToNSDate:(double)doubleTime{
    NSTimeInterval _interval = doubleTime/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    return date;
}

+ (int)getSumOfDaysInMonth:(NSString *)year month:(NSString *)month{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM"]; // 年-月
    
    NSString * dateStr = [NSString stringWithFormat:@"%@-%@",year,month];
    
    NSDate * date = [formatter dateFromString:dateStr];
    
    //
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit
                                   inUnit: NSMonthCalendarUnit
                                  forDate:date];
    return (int)range.length;
}
@end
