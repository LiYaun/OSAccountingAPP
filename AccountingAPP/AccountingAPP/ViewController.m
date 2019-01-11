//
//  ViewController.m
//  AccountingAPP
//
//  Created by 張力元 on 2018/12/6.
//  Copyright © 2018 張力元. All rights reserved.
//

#import "ViewController.h"
#import "myIntroView.h"
#import "MounthRecrodViewContrloller.h"
#import "AccountHomeViewController.h"


@interface ViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *accountHomeView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *resetDBBtn;

@property (assign, nonatomic) int nowPage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSocialScrollview];
    [self resetDBBtnInit];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setIntroView];
    self.title = @"我的帳簿";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)initSocialScrollview{
    CGSize tableSize = _accountHomeView.frame.size;
    _scrollView.contentSize = CGSizeMake(tableSize.width*2, tableSize.height);
    _scrollView.delegate = self;
    _nowPage = 0;
}

- (void)setIntroView{
    
    _introView = [myIntroView getIntroView:UIScreen.mainScreen.bounds];
    _introView.contentMode = UIViewContentModeScaleAspectFill;
    _introView.swipeToExit = false;
    _introView.skipButton.hidden = true;
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"HasLaunchedOnce"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [_introView showFullscreenWithAnimateDuration:0.3f];
    }
    
}

- (void)resetDBBtnInit{
    UITapGestureRecognizer *pres = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resetDB)];
    pres.numberOfTapsRequired = 10;
    [_resetDBBtn addGestureRecognizer:pres];
}

- (IBAction)swichPage:(UISegmentedControl *)sender {
    NSLog(@"%ld",(long)sender.selectedSegmentIndex);
    [self scrollToPage:(int)sender.selectedSegmentIndex];
}

- (void)scrollToPage:(int)page{
    if (page != _nowPage)
    {
        CGSize tableSize = _accountHomeView.frame.size;
        CGRect frame = CGRectMake(tableSize.width*page, 0, tableSize.width, tableSize.height);
        [_scrollView scrollRectToVisible:frame animated:YES];
        _nowPage = page;
        [self.view endEditing:true];
        
        if (page == 1) {
            for (int i = 0; i<self.childViewControllers.count; i++) {
                if ([self.childViewControllers[i] isKindOfClass:[MounthRecrodViewContrloller class]]) {
                    MounthRecrodViewContrloller *tView = (MounthRecrodViewContrloller *)self.childViewControllers[i];
                    [tView updateAccData];
                    [tView updateEarliestData];
                    break;
                }
            }
        }
        else if (page == 0){
            for (int i = 0; i<self.childViewControllers.count; i++) {
                if ([self.childViewControllers[i] isKindOfClass:[AccountHomeViewController class]]) {
                    AccountHomeViewController *tView = (AccountHomeViewController *)self.childViewControllers[i];
                    [tView listDataInit];
                    break;
                }
            }
        }
    }
    
    if (_pageSwich.selectedSegmentIndex != page) {
        [_pageSwich setSelectedSegmentIndex:page];
    }
}

- (void)resetDB{
    RLMRealm *db = [RLMRealm defaultRealm];
    [db beginWriteTransaction];
    [db deleteAllObjects];
    [db commitWriteTransaction];
    [self.view makeToast:@"清除資料庫成功"];
}

@end
