//
//  MounthRecrodViewContrloller.m
//  AccountingAPP
//
//  Created by 張力元 on 2018/12/17.
//  Copyright © 2018 張力元. All rights reserved.
//

#import "MounthRecrodViewContrloller.h"
#import "AccountHomeViewController.h"
#import "barPreviewingViewController.h"
#import "ViewController.h"

@interface MounthRecrodViewContrloller ()<PNChartDelegate,UIViewControllerPreviewingDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *barChartView;
@property (strong, nonatomic) IBOutlet UIView *pieChartView;
@property (strong, nonatomic) IBOutlet UIScrollView *barScrollView;
@property (strong, nonatomic) IBOutlet UITextField *mounthField;
@property (strong, nonatomic) IBOutlet UILabel *totalCost;
@property (strong, nonatomic) IBOutlet UILabel *typeCost;
@property (strong, nonatomic) IBOutlet UILabel *noRecordLable;

@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) PNBarChart *barChart;
@property (strong, nonatomic) PNPieChart *pieChart;
@property (strong, nonatomic) NSMutableArray<RLMResults<accountModel *>*> *monthDataArr;
@property (strong, nonatomic) NSMutableArray<RLMResults<accountModel *>*> *typeDataArr;

@property (strong, nonatomic) NSArray *newestDate;
@property (strong, nonatomic) NSArray *typeArr;
@property (strong, nonatomic) NSArray *typeColorArr;

@property (strong, nonatomic) NSMutableArray<NSString *> *barChartXLableArr;
@property (strong, nonatomic) NSMutableArray<NSNumber *> *barChartValueArr;

@property (strong, nonatomic) accountModel *earliestData;
@property (strong, nonatomic) NSDate *selectDate;
@end

@implementation MounthRecrodViewContrloller

- (void)viewDidLoad {
    [super viewDidLoad];
    _typeArr = (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"typeArr"];
    _typeColorArr = (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"typeColorArr"];
    _newestDate = [[DateTimeManager NSDateToNSString:[NSDate date]] componentsSeparatedByString:@"/"];
    _nowMonth =[_newestDate[1] intValue];
    _nowYear = [_newestDate[0] intValue];
    [self dataInit];
    [self pickerViewInit];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadChart];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

#pragma mark - init
- (void)dataInit{
    if (!_monthDataArr)
        _monthDataArr = [NSMutableArray<RLMResults<accountModel *>*> new];
    if (!_typeDataArr)
        _typeDataArr = [NSMutableArray<RLMResults<accountModel *>*> new];
    _mounthField.text = [NSString stringWithFormat:@"%d/%d",_nowYear,_nowMonth];
}

- (void)barChartViewReload{
    int YLableWidth = 60;
    if (!_barChart) {
        _barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, 45*_monthDataArr.count+YLableWidth, _barChartView.bounds.size.height)];
    }
    else{
        [_barChart setFrame:CGRectMake(0, 0, 45*_monthDataArr.count+YLableWidth, _barChartView.bounds.size.height)];
    }
    
    [_barChart setChartMarginTop:5];
    [_barChart setYLabelSum:5];
    [_barChart setBarWidth:40];
    [_barChart setXLabels:_barChartXLableArr];
    [_barChart setYValues:_barChartValueArr];
    [_barChart strokeChart];
    for (int i=0; i<_barChart.bars.count; i++) {
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            [self registerForPreviewingWithDelegate:self sourceView:_barChart.bars[i]];
        }
    }
    [self barScrollViewInit];
}

- (void)pickerViewInit{
    CGFloat Width = self.view.frame.size.width;
    _picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, Width, 220)];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.showsSelectionIndicator = true;
    _mounthField.inputAccessoryView = [self keyboardInputAccessoryView];
    _mounthField.inputView = _picker;
}

- (void)pieChartViewReload{
    _typeCost.hidden = true;
    NSMutableArray<PNPieChartDataItem *> *items = [NSMutableArray<PNPieChartDataItem *> new];
    for (int i = 0; i<_typeArr.count; i++) {
        UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:_typeColorArr[i]];
        int cost = 0;
        for (int j = 0; j<_typeDataArr[i].count; j++) {
            accountModel *data = (accountModel *)_typeDataArr[i][j];
            cost += data.price;
        }
        PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:cost color:color description:_typeArr[i]];
        [items addObject:item];
    }
    
    if (!_pieChart) {
        _pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 0, _pieChartView.frame.size.width, _pieChartView.frame.size.height) items:nil];
        _pieChart.delegate = self;
        _pieChart.descriptionTextColor = [UIColor whiteColor];
        _pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
        [_pieChartView addSubview:_pieChart];
    }
    [_pieChart updateChartData:items];
    [_pieChart strokeChart];
}

- (void)barScrollViewInit{
    if(_barChart.frame.size.width>_barChartView.frame.size.width)
        _barScrollView.contentSize = _barChart.frame.size;
    else
        _barScrollView.contentSize = _barChartView.frame.size;
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
    if (mounth < _earliestData.month && year <= _earliestData.year) {
        [self.view makeToast:@"沒有更早的紀錄囉～"];
        return;
    }
    _typeCost.hidden = true;
    _nowYear = year;
    _nowMonth = mounth;
    
    _mounthField.text = [NSString stringWithFormat:@"%d/%d",_nowYear,_nowMonth];
    [self startEditMounthField:nil];
    [self reloadChart];
}

- (IBAction)startEditMounthField:(id)sender {
    [_picker selectRow:_nowYear - _earliestData.year inComponent:0 animated:true];
    if (_nowYear == _earliestData.year)
        [_picker selectRow:_nowMonth - _earliestData.month inComponent:1 animated:true];
    else
        [_picker selectRow:_nowMonth - 1 inComponent:1 animated:true];
}

#pragma mark - PickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return [_newestDate[0] intValue] - _earliestData.year + 1;
    }
    else if (_nowYear == _earliestData.year) {
        return 12 - _earliestData.month + 1;
    }
    else if(_nowYear == [_newestDate[0] intValue]){
        return [_newestDate[1] intValue];
    }
    return 12;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [NSString stringWithFormat:@"%d",(int)(_earliestData.year + row)];
    }
    else if (_nowYear == _earliestData.year) {
        return [NSString stringWithFormat:@"%d",(int)(_earliestData.month + row)];
    }
    return [NSString stringWithFormat:@"%d",(int)row+1];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0){
        _nowYear = (int)(_earliestData.year + row);
        [pickerView reloadComponent:1];
        [self pickerView:pickerView didSelectRow:0 inComponent:1];
    }
    else if (_nowYear == _earliestData.year)
        _nowMonth = (int)(_earliestData.month + row);
    else
        _nowMonth = (int)row+1;
    
    _mounthField.text = [NSString stringWithFormat:@"%d/%d",_nowYear,_nowMonth];
}

#pragma mark - UIViewControllerPreviewingDelegate(3D touch)
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    if ([previewingContext.sourceView isKindOfClass:[PNBar class]]) {
        barPreviewingViewController *view = [barPreviewingViewController new];
        for (int i=0; i<_barChart.bars.count; i++) {
            if ([previewingContext.sourceView isEqual: _barChart.bars[i]]) {
                view.accountData = _monthDataArr[i];
                NSString *dateStr = [NSString stringWithFormat:@"%@/%d",_mounthField.text,i+1];
                _selectDate = [DateTimeManager NSStringToDate:dateStr type:0];
                break;
            }
        }
        return view;
    }
    return nil;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    if ([previewingContext.sourceView isKindOfClass:[PNBar class]]) {
        for (int i=0; i<self.parentViewController.childViewControllers.count; i++) {
            if ([self.parentViewController.childViewControllers[i] isKindOfClass:[AccountHomeViewController class]]) {
                AccountHomeViewController *tView = (AccountHomeViewController *)self.parentViewController.childViewControllers[i];
                tView.nowDate = _selectDate;
                ViewController *parentView = (ViewController *)self.parentViewController;
                [parentView scrollToPage:0];
                break;
            }
        }
    }
}

#pragma mark - function
- (UIToolbar *)keyboardInputAccessoryView{
    
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成"                                                                   style:UIBarButtonItemStylePlain target:self                                                                  action:@selector(reloadChart)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:space,doneButton, nil]];
    
    return keyboardDoneButtonView;
}

- (void)reloadChart{
    [self.view endEditing:true];
    [self updateAccData];
    [self updateTypeData];
}

- (void)updateAccData{
    [_monthDataArr removeAllObjects];
    int monthOfDays = [DateTimeManager getSumOfDaysInMonth:[NSString stringWithFormat:@"%d",_nowYear]
                                                     month:[NSString stringWithFormat:@"%d",_nowMonth]];
    
    BOOL isNewest = ([_newestDate[0] intValue] == _nowYear) && ([_newestDate[1] intValue] == _nowMonth);
    monthOfDays = (isNewest)?[_newestDate[2] intValue]:monthOfDays;
    for (int i=0; i<monthOfDays; i++) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"year = %d AND month = %d AND day = %d",_nowYear,_nowMonth,i+1];
        RLMResults<accountModel *> *dayData = [[accountModel objectsWithPredicate:pred] sortedResultsUsingKeyPath:@"refreshTime" ascending:true];
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
    [self barChartViewReload];
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
    [self barChartViewReload];
    _totalCost.text = [NSString stringWithFormat:@"%d",totalCost];
}

- (void)updateTypeData{
    [_typeDataArr removeAllObjects];
    BOOL isNoObject = true;
    for (int i=0; i<_typeArr.count; i++) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"type = %@ AND year = %d AND month = %d",_typeArr[i],_nowYear,_nowMonth];
        RLMResults<accountModel *> *typeData = [[accountModel objectsWithPredicate:pred] sortedResultsUsingKeyPath:@"refreshTime" ascending:true];
        if(typeData.count > 0) isNoObject = false;
        [_typeDataArr addObject:typeData];
    }
    _noRecordLable.hidden = !isNoObject;
    [self pieChartViewReload];
}

- (void)updateEarliestData{
    RLMResults<accountModel *> *allData = [accountModel allObjects];
    _earliestData = [[allData sortedResultsUsingKeyPath:@"date" ascending:YES] firstObject];
}

#pragma mark - chart delegate
- (void)userClickedOnPieIndexItem:(NSInteger)barIndex{
    _typeCost.hidden = false;
    int typeCostInt = 0;
    for (int i = 0; i<_typeDataArr[barIndex].count; i++) {
        accountModel *data = (accountModel *)_typeDataArr[barIndex][i];
        typeCostInt += data.price;
    }
    _typeCost.text = [NSString stringWithFormat:@"%d元",typeCostInt];
}

- (void)didUnselectPieItem{
    _typeCost.hidden = true;
}

@end
