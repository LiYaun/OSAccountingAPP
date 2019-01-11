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
    page1.title = @"歡迎使用記帳APP";
    page1.desc = @"讓我們來看看為什麼要記帳";
    page1.bgImage = [UIImage imageNamed:@"BG1"];
    return page1;
}

+ (EAIntroPage *)page2{
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"記帳的重要性";
    page2.titleFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:24];
    page2.titlePositionY = 280;
    page2.desc = @"時代越發達，人們越懂得注重生活品質，而生活品質往往體現於物質上，這也意義著消費的種類將會越來越多樣化。\n\n因此在這個經濟洪流的時代中能夠掌握自己的金錢去流，就代表著能掌握著未來的方向。";
    page2.descFont = [UIFont fontWithName:@"Georgia-Italic" size:18];
    page2.descPositionY = 340;
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whyAccount"]];
    page2.titleIconPositionY = 150;
    page2.bgImage = [UIImage imageNamed:@"BG2"];
    return page2;
}

+ (EAIntroPage *)lastPage{
    UIView *viewForLastPage = [[UIView alloc] initWithFrame:fullScreemFrame];
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(fullScreemFrame.size.width*0.25, fullScreemFrame.size.height/2, fullScreemFrame.size.width*0.5, 30)];
    [startBtn setTitle:@"開始記帳吧！！！" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startAccount) forControlEvents:UIControlEventTouchUpInside];
    startBtn.layer.masksToBounds = true;
    startBtn.layer.cornerRadius = 5;
    startBtn.layer.borderWidth = 1;
    startBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [viewForLastPage addSubview:startBtn];
    EAIntroPage *lastPage = [EAIntroPage pageWithCustomView:viewForLastPage];
    lastPage.bgImage = [UIImage imageNamed:@"BG1"];
    return lastPage;
}

+ (void)startAccount{
    [introView hideWithFadeOutDuration:0.3];
}

@end
