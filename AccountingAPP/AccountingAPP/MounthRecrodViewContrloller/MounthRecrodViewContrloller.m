//
//  MounthRecrodViewContrloller.m
//  AccountingAPP
//
//  Created by 張力元 on 2018/12/17.
//  Copyright © 2018 張力元. All rights reserved.
//

#import "MounthRecrodViewContrloller.h"
#import <PNChart.h>

@interface MounthRecrodViewContrloller ()
@property (strong, nonatomic) IBOutlet UIView *chartView;
@property (strong, nonatomic) IBOutlet UIScrollView *barScrollView;
@property (strong, nonatomic) IBOutlet UITextField *mounthField;
@property (strong, nonatomic) IBOutlet UILabel *totalCost;

@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) PNBarChart *barChart;
@property (strong, nonatomic) NSMutableArray<RLMResults<accountModel *>*> *monthDataArr;

@property (strong, nonatomic) NSArray *newestDate;

@property (strong, nonatomic) NSMutableArray<NSString *> *barChartXLableArr;
@property (strong, nonatomic) NSMutableArray<NSNumber *> *barChartValueArr;

@property (strong, nonatomic) accountModel *earliestData;
@end

@implementation MounthRecrodViewContrloller

- (void)viewDidLoad {
    [super viewDidLoad];
    _newestDate = [[DateTimeManager NSDateToNSString:[NSDate date]] componentsSeparatedByString:@"/"];
    _nowMonth =[_newestDate[1] intValue];
    _nowYear = [_newestDate[0] intValue];
    [self dataInit];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateAccData];
}

#pragma mark - init
- (void)dataInit{
    if (!_monthDataArr)
        _monthDataArr = [NSMutableArray<RLMResults<accountModel *>*> new];
    _mounthField.text = [NSString stringWithFormat:@"%d/%d",_nowYear,_nowMonth];
    
    
}

- (void)chartViewReload{
    if (!_barChart) {
        _barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, 45*_monthDataArr.count, _chartView.bounds.size.height)];
    }
    else{
        [_barChart setFrame:CGRectMake(0, 0, 45*_monthDataArr.count, _chartView.bounds.size.height)];
    }
    
    [_barChart setChartMarginTop:5];
    [_barChart setYLabelSum:5];
    [_barChart setBarWidth:40];
    [_barChart setXLabels:_barChartXLableArr];
    [_barChart setYValues:_barChartValueArr];
    [_barChart strokeChart];
    [self barScrollViewInit];
}

- (void)barScrollViewInit{
    _barScrollView.contentSize = _barChart.frame.size;
    [_barScrollView addSubview:_barChart];
}

#pragma mark - IBAction
- (IBAction)swichMounth:(UIButton *)btn {
    if (_nowMonth == [_newestDate[1] intValue] && _nowYear == [_newestDate[0] intValue] && btn.tag == 1){
        [self.view makeToast:@"時間還沒到喔～～"];
        return;
    }
    
    int mounth = _nowMonth + (int)btn.tag;
    int year = _nowYear;
    if (mounth>12) {
        mounth = 1;
        year++;
    }
    else if (mounth<1){
        mounth = 12;
        year--;
    }
    
    NSLog(@"%d/%d",_earliestData.year,_earliestData.month);
    if (mounth < _earliestData.month || year < _earliestData.year) {
        [self.view makeToast:@"沒有更早的紀錄囉～"];
        return;
    }
    _nowYear = year;
    _nowMonth = mounth;
    
    _mounthField.text = [NSString stringWithFormat:@"%d/%d",_nowYear,_nowMonth];
    [self updateAccData];
}

#pragma mark - function
- (void)updateAccData{
    [_monthDataArr removeAllObjects];
    int monthOfDays = [DateTimeManager getSumOfDaysInMonth:[NSString stringWithFormat:@"%d",_nowYear]
                                                     month:[NSString stringWithFormat:@"%d",_nowMonth]];
    
    BOOL isNewest = ([_newestDate[0] intValue] == _nowYear) && ([_newestDate[1] intValue] == _nowMonth);
    monthOfDays = (isNewest)?[_newestDate[2] intValue]:monthOfDays;
    for (int i=0; i<monthOfDays; i++) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"year = %d AND month = %d AND day = %d",_nowYear,_nowMonth,i+1];
        RLMResults<accountModel *> *dayData = [[accountModel objectsWithPredicate:pred] sortedResultsUsingKeyPath:@"date" ascending:true];
        [_monthDataArr addObject:dayData];
    }
    NSLog(@"%d",(int)_monthDataArr.count);
    _barChartXLableArr = [NSMutableArray<NSString *> new];
    _barChartValueArr = [NSMutableArray<NSNumber *> new];
    int totalCost = 0;
    for (int i=0; i<_monthDataArr.count; i++) {
        [_barChartXLableArr addObject:[NSString stringWithFormat:@"%d/%d",_nowMonth,i+1]];
        int cost = 0;
        for (int j=0; j<_monthDataArr[i].count; j++) {
            accountModel *data = (accountModel *)_monthDataArr[i][j];
            cost = cost + data.price;
            totalCost = totalCost + data.price;
        }
        [_barChartValueArr addObject:[NSNumber numberWithInt:cost]];
    }
    [self chartViewReload];
    if (isNewest)
        [_barScrollView scrollRectToVisible:CGRectMake(_barScrollView.contentSize.width-_barScrollView.frame.size.width,
                                                       0,
                                                       _barScrollView.frame.size.width,
                                                       _barScrollView.frame.size.height) animated:true];
    else
        [_barScrollView scrollRectToVisible:CGRectMake(0,
                                                       0,
                                                       _barScrollView.frame.size.width,
                                                       _barScrollView.frame.size.height) animated:true];
    
    _totalCost.text = [NSString stringWithFormat:@"%d",totalCost];
}

- (void)updateEarliestData{
    RLMResults<accountModel *> *allData = [accountModel allObjects];
    _earliestData = [[allData sortedResultsUsingKeyPath:@"date" ascending:YES] firstObject];
}

@end
