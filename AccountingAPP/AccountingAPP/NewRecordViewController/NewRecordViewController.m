//
//  NewRecordViewController.m
//  AccountingAPP
//
//  Created by 張力元 on 2018/12/18.
//  Copyright © 2018 張力元. All rights reserved.
//

#import "NewRecordViewController.h"
#import "accountModel.h"

@interface NewRecordViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) accountModel *model;
@property (strong, nonatomic) IBOutlet UITextField *dateField;
@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UITextField *typeField;
@property (strong, nonatomic) IBOutlet UITextField *costField;

@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) NSArray *typeArr;
//@property (strong, nonatomic) RLMRealm *realmDB;
@end


@implementation NewRecordViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _typeArr = (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"typeArr"];
    [self modelInit];
    [self viewInit];
    [self pickerInit];
    [self datePickerInit];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navigationBtnInit];
}

- (void)navigationBtnInit{
    UIBarButtonItem *sendBtn = [[UIBarButtonItem alloc]initWithTitle:@"確定" style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnClick)];
    self.navigationItem.rightBarButtonItem = sendBtn;
    
    UIBarButtonItem *exitBtn = [[UIBarButtonItem alloc]initWithTitle:@"離開" style:UIBarButtonItemStylePlain target:self action:@selector(showExitAlert)];
    self.navigationItem.leftBarButtonItem = exitBtn;
}

- (void)pickerInit{
    CGFloat Width = self.view.frame.size.width;
    _picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, Width, 220)];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.showsSelectionIndicator = true;
    _typeField.inputView = _picker;
}

- (void)datePickerInit{
    CGFloat Width = self.view.frame.size.width;
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, Width, 220)];
    [_datePicker addTarget:self action:@selector(scrollDatePicker) forControlEvents:UIControlEventValueChanged];
    _datePicker.maximumDate = [NSDate date];
    _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    _dateField.inputView = _datePicker;
}

- (void)viewInit{
    _dateField.text = [DateTimeManager NSDateToNSString:[NSDate date]];
    _typeField.text = _typeArr[0];
    _titleField.placeholder = _typeField.text;
    UITapGestureRecognizer *endEditTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(killKeyboard)];
    [self.view addGestureRecognizer:endEditTap];
}

- (void)modelInit{
    _model = [accountModel new];
    _model.date = [DateTimeManager NSDateToDouble:_datePicker.date];
    NSArray *dateArr = [_dateField.text componentsSeparatedByString:@"/"];
    _model.year = [dateArr[0] intValue];
    _model.month = [dateArr[1] intValue];
    _model.day = [dateArr[2] intValue];
}

#pragma mark - Function
- (void)nextBtnClick{
    _model.refreshTime = [DateTimeManager NSDateToDouble:[NSDate date]];
    _model.title = _titleField.text;
    _model.price = [_costField.text intValue];
    RLMRealm *realmDB = [RLMRealm defaultRealm];
    [realmDB transactionWithBlock:^{
        [realmDB addObject:self->_model];
    }];
    [self.navigationController popViewControllerAnimated:true];
}

- (void)showExitAlert{
    UIAlertController *aView = [UIAlertController alertControllerWithTitle:@"尚未儲存" message:@"你確定要離開嗎？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:true];
    }];
    
    [aView addAction:cancel];
    [aView addAction:setAction];
    [self presentViewController:aView animated:true completion:nil];
}

- (void)scrollDatePicker{
    if (_dateField.isFirstResponder){
        _dateField.text = [DateTimeManager NSDateToNSString:_datePicker.date];
        _model.date = [DateTimeManager NSDateToDouble:_datePicker.date];
        NSArray *dateArr = [_dateField.text componentsSeparatedByString:@"/"];
        _model.year = [dateArr[0] intValue];
        _model.month = [dateArr[1] intValue];
        _model.day = [dateArr[2] intValue];
    }
}

- (void)killKeyboard{
    [self.view endEditing:true];
}

#pragma mark - PickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return _typeArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return  _typeArr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _typeField.text = _typeArr[row];
    _titleField.placeholder = _typeField.text;
}

@end
