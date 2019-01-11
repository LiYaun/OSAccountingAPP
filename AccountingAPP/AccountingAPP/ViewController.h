//
//  ViewController.h
//  AccountingAPP
//
//  Created by 張力元 on 2018/12/6.
//  Copyright © 2018 張力元. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EAIntroView.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) EAIntroView *introView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pageSwich;

- (void)scrollToPage:(int)page;
@end

