//
//  myIntroView.m
//  AccountingAPP
//
//  Created by 張力元 on 2018/12/15.
//  Copyright © 2018 張力元. All rights reserved.
//

#import "myIntroView.h"
static EAIntroView *introView;
static CGRect fullScreemFrame;
@implementation myIntroView

+ (EAIntroView *)getIntroView:(CGRect)frame{
    if (!introView) {
        fullScreemFrame = frame;
        introView =  [[EAIntroView alloc] initWithFrame:frame andPages:@[[self page1],[self page2],[self lastPage]]];
    }
    return introView;
}

+ (EAIntroPage *)page1{
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = @"1234567891123";
    page1.bgImage = [UIImage imageNamed:@"BG1"];
    return page1;
}

+ (EAIntroPage *)page2{
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.titleFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:20];
    page2.titlePositionY = 220;
    page2.desc = @"asdcnsalkjnvadksjvbas";
    page2.descFont = [UIFont fontWithName:@"Georgia-Italic" size:18];
    page2.descPositionY = 200;
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_icon"]];
    page2.titleIconPositionY = 100;
    page2.bgImage = [UIImage imageNamed:@"BG2"];
    return page2;
}

+ (EAIntroPage *)lastPage{
    UIView *viewForLastPage = [[UIView alloc] initWithFrame:fullScreemFrame];
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, fullScreemFrame.size.height/2, fullScreemFrame.size.width, 30)];
    [startBtn setTitle:@"開始記帳吧！！！" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startAccount) forControlEvents:UIControlEventTouchUpInside];
    [viewForLastPage addSubview:startBtn];
    EAIntroPage *lastPage = [EAIntroPage pageWithCustomView:viewForLastPage];
    lastPage.bgImage = [UIImage imageNamed:@"BG1"];
    return lastPage;
}

+ (void)startAccount{
    [introView hideWithFadeOutDuration:0.3];
}

@end
