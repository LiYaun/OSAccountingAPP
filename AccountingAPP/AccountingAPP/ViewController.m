//
//  ViewController.m
//  AccountingAPP
//
//  Created by 張力元 on 2018/12/6.
//  Copyright © 2018 張力元. All rights reserved.
//

#import "ViewController.h"
#import "myIntroView.h"
#import <EAIntroView.h>

@interface ViewController ()
@property (strong, nonatomic) EAIntroView *introView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setIntroView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)setIntroView{
    
    _introView = [myIntroView getIntroView:self.view.bounds];
    _introView.contentMode = UIViewContentModeScaleAspectFill;
    _introView.swipeToExit = false;
    _introView.skipButton.hidden = true;
    
    // showFullscreen
    [_introView showFullscreenWithAnimateDuration:0.3f];
    
    // showInView
    [_introView showInView:self.view animateDuration:0.0];
}


@end
