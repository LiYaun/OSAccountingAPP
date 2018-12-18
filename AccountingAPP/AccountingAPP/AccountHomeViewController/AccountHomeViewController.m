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

@interface AccountHomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (strong, nonatomic) IBOutlet UITextField *dateField;
@property (strong, nonatomic) IBOutlet UIButton *lastDayBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextDayBtn;
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) NSDate *nowDate;
@end

@implementation AccountHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self datePickerInit];
    [self dateFieldInit];
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
    _dateField.text = [DateTimeManager NSDateToNSString:[NSDate date]];
    _dateField.inputAccessoryView = [self keyboardInputAccessoryView];
    _dateField.inputView = _datePicker;
}

#pragma mark - IBAction
- (IBAction)addNewRecord:(UIButton *)sender {
    NewRecordViewController *tView = [NewRecordViewController new];
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
    NSLog(@"%d",(int)btn.tag);
    if (btn.tag == 0) {
        _nowDate = [DateTimeManager NextDay:_nowDate isAdd:false];
        _dateField.text = [DateTimeManager NSDateToNSString:_nowDate];
    }
    else if ([_dateField.text isEqualToString:@"今天"]){
        [self.view makeToast:@"未來的帳未來算"];
    }
    else if (btn.tag == 1){
        _nowDate = [DateTimeManager NextDay:_nowDate isAdd:true];
        _dateField.text = [DateTimeManager NSDateToNSString:_nowDate];
    }
    _datePicker.date = _nowDate;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = @"test";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

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
        _dateField.text = [DateTimeManager NSDateToNSString:_datePicker.date];
        _nowDate = _datePicker.date;
    }
}

@end
