//
//  AccountHomeViewController.m
//  AccountingAPP
//
//  Created by 張力元 on 2018/12/17.
//  Copyright © 2018 張力元. All rights reserved.
//

#import "AccountHomeViewController.h"
#import "ViewController.h"
#import "NewRecordViewController.h"
#import "AccountTableViewCell.h"

@interface AccountHomeViewController ()<UITableViewDelegate, UITableViewDataSource, AccountTableViewCellDelegate, UIViewControllerPreviewingDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong, nonatomic) IBOutlet UITextField *dateField;
@property (strong, nonatomic) IBOutlet UIButton *lastDayBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextDayBtn;
@property (strong, nonatomic) IBOutlet UILabel *totalCostLable;
@property (strong, nonatomic) IBOutlet UIButton *noRecordView;
@property (strong, nonatomic) UIDatePicker *datePicker;


@property (strong, nonatomic) RLMResults<accountModel *> *accountData;
@end

@implementation AccountHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self datePickerInit];
    [self dateFieldInit];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self listDataInit];
}

#pragma mark - init
- (void)datePickerInit{
    CGFloat Width = self.view.frame.size.width;
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, Width, 220)];
    [_datePicker addTarget:self action:@selector(scrollDatePicker) forControlEvents:UIControlEventValueChanged];
    _datePicker.maximumDate = [NSDate date];
    _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    _nowDate = _datePicker.date;
}

- (void)dateFieldInit{
    _dateField.text = @"今天";
    _dateField.inputAccessoryView = [self keyboardInputAccessoryView];
    _dateField.inputView = _datePicker;
}

- (void)listDataInit{
    
    NSString *dateStr = [DateTimeManager NSDateToNSString:_nowDate];
    NSArray *dateArr = [dateStr componentsSeparatedByString:@"/"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"year = %d AND month = %d AND day = %d",[dateArr[0] intValue],[dateArr[1]intValue],[dateArr[2]intValue]];
    _accountData = [[accountModel objectsWithPredicate:pred] sortedResultsUsingKeyPath:@"refreshTime" ascending:true];
    
    
    _listView.hidden = !(_accountData.count > 0);
    _noRecordView.hidden = (_accountData.count > 0);
    int totalCost = 0;
    for (int i=0; i<_accountData.count; i++) {
        totalCost = totalCost + _accountData[i].price;
    }
    _totalCostLable.text = [NSString stringWithFormat:@"%d",totalCost];
    if (_accountData.count > 0)
        [_listView reloadData];
    
    
    [self dateReload];
}

#pragma mark - IBAction
- (IBAction)addNewRecord:(UIButton *)sender {
    NewRecordViewController *tView = [NewRecordViewController new];
    tView.nowDate = _nowDate;
    tView.isEdit = true;
    [self.navigationController pushViewController:tView animated:true];
}

- (IBAction)whyAccountBtnClick:(id)sender {
    NSLog(@"%@",[self.parentViewController class]);
    if ([self.parentViewController isKindOfClass:[ViewController class]]) {
        ViewController *view = (ViewController *)self.parentViewController;
        [view.introView showFullscreenWithAnimateDuration:0.3f];
    }
}

- (IBAction)swichDay:(UIButton *)btn{
    if (btn.tag == 0) {
        _nowDate = [DateTimeManager NextDay:_nowDate isAdd:false];
        [self dateReload];
    }
    else if ([_dateField.text isEqualToString:@"今天"]){
        [self.view makeToast:@"未來的帳未來算"];
    }
    else if (btn.tag == 1){
        _nowDate = [DateTimeManager NextDay:_nowDate isAdd:true];
        [self dateReload];
    }
    _datePicker.date = _nowDate;
    [self listDataInit];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _accountData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountTableViewCell"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AccountTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    [cell setCellbyAccount:_accountData[indexPath.row]];
    cell.delegate = self;
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {  //支持3D Touch
        //系统所有cell可实现预览（peek）
        [self registerForPreviewingWithDelegate:self sourceView:cell]; //注册cell
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NewRecordViewController *tView = [NewRecordViewController new];
    tView.model = _accountData[indexPath.row];
    tView.isEdit = false;
    [self.navigationController pushViewController:tView animated:true];
}

- (void)deleteAccount:(accountModel *)model{
    
    UIAlertController *aView = [UIAlertController alertControllerWithTitle:@"刪除紀錄" message:@"你確定要刪除嗎？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RLMRealm *db = [RLMRealm defaultRealm];
        [db beginWriteTransaction];
        [db deleteObject:model];
        [db commitWriteTransaction];
        [self listDataInit];
    }];
    
    [aView addAction:cancel];
    [aView addAction:setAction];
    [self presentViewController:aView animated:true completion:nil];
}

#pragma mark - UIViewControllerPreviewingDelegate(3D touch)
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    NewRecordViewController *tView = [NewRecordViewController new];
    
    //转化坐标
    location = [_listView convertPoint:location fromView:[previewingContext sourceView]];
    
    //根据locaton获取位置
    NSIndexPath *path = [_listView indexPathForRowAtPoint:location];
    
    //根据位置获取字典数据传传入控制器
    tView.model = _accountData[path.row];
    tView.isEdit = false;
    
    return tView;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
}

#pragma mark - function
- (UIToolbar *)keyboardInputAccessoryView{
    
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成"                                                                   style:UIBarButtonItemStylePlain target:self                                                                  action:@selector(killKeyboard)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:space,doneButton, nil]];
    
    return keyboardDoneButtonView;
}

- (void)killKeyboard{
    [self.view endEditing:true];
}

- (void)scrollDatePicker{
    if (_dateField.isFirstResponder){
        NSString *dateStr = [DateTimeManager NSDateToNSString:_datePicker.date];
        if ([dateStr isEqualToString:[DateTimeManager NSDateToNSString:[NSDate date]]])
            _dateField.text = @"今天";
        else
            _dateField.text = dateStr;
        _nowDate = _datePicker.date;
        [self listDataInit];
    }
}

- (void)dateReload{
    NSString *dateStr = [DateTimeManager NSDateToNSString:_nowDate];
    if ([dateStr isEqualToString:[DateTimeManager NSDateToNSString:[NSDate date]]])
        _dateField.text = @"今天";
    else
        _dateField.text = dateStr;
}

@end
