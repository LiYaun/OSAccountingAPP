//
//  ViewController.m
//  AccountingAPP
//
//  Created by 張力元 on 2018/12/6.
//  Copyright © 2018 張力元. All rights reserved.
//

#import "ViewController.h"
#import "myIntroView.h"


@interface ViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *accountHomeView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (assign, nonatomic) int nowPage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSocialScrollview];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setIntroView];
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
    }
}


@end
