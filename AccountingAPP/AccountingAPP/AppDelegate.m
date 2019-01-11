//
//  AppDelegate.m
//  AccountingAPP
//
//  Created by 張力元 on 2018/12/6.
//  Copyright © 2018 張力元. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSArray *typeArr = (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"typeArr"];
    if (!typeArr){
        typeArr = [[NSArray alloc]initWithObjects:@"食物",@"飲料",@"交通",@"娛樂",@"購物",@"教育",@"醫療",@"其他",@"收入", nil];
        [[NSUserDefaults standardUserDefaults] setObject:typeArr forKey:@"typeArr"];
    }
    
    NSMutableArray *typeColorArr = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"typeColorArr"];
    if (!typeColorArr){
        typeColorArr = [[NSMutableArray alloc]initWithObjects:PNRed,PNGreen,PNBlue,PNBrown,PNDarkBlue,PNLightBlue,PNMauve,PNDeepGrey,PNTwitterColor, nil];
        for (int i=0; i<typeColorArr.count; i++) {
            NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:typeColorArr[i]];
            typeColorArr[i] = colorData;
        }
        [[NSUserDefaults standardUserDefaults] setObject:typeColorArr forKey:@"typeColorArr"];
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
