//
//  AppDelegate.m
//  JiawenClock
//
//  Created by ysj on 16/8/19.
//  Copyright © 2016年 yushengjie. All rights reserved.
//

#import "AppDelegate.h"
#import "YSJTabBarController.h"
#import "YSJNavigationController.h"
#import "WorkListViewController.h"
#import "SettingViewController.h"
#import "FMDBHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    WorkListViewController *workListVC = [[WorkListViewController alloc]init];
    workListVC.navigationItem.title = @"工作日历";
//    [workListVC setTitle:@"工作日历" titleColor:[UIColor darkGrayColor] titleFont:[UIFont boldSystemFontOfSize:15]];
    YSJNavigationController *nav1 = [[YSJNavigationController alloc]initWithRootViewController:workListVC];
    [nav1 setTabBarItemWithImage:[UIImage imageNamed:@"favorite-tab"] SelectedImage:[UIImage imageNamed:@"favorite-tab-selected"] renderingMode:UIImageRenderingModeAlwaysOriginal title:@"工作日历" titleColor:[UIColor whiteColor]];
    
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    settingVC.navigationItem.title = @"设置";
//    [settingVC setTitle:@"设置" titleColor:[UIColor darkGrayColor] titleFont:[UIFont boldSystemFontOfSize:15]];
    YSJNavigationController *nav2 = [[YSJNavigationController alloc] initWithRootViewController:settingVC];
    [nav2 setTabBarItemWithImage:[UIImage imageNamed:@"more-tab"] SelectedImage:[UIImage imageNamed:@"more-tab-selected"] renderingMode:UIImageRenderingModeAlwaysOriginal title:@"设置" titleColor:[UIColor whiteColor]];
    
    YSJTabBarController *tabBarCtrl = [[YSJTabBarController alloc]init];
    tabBarCtrl.viewControllers = @[nav1,nav2];
    tabBarCtrl.tabBar.backgroundImage = [UIImage imageNamed:@"grey-bg"];
    
    self.window.rootViewController = tabBarCtrl;
    
    [self.window makeKeyAndVisible];
    
    [self initDataBase];
    [self initUserDefault];
    return YES;
}

- (void)initUserDefault{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultKeyAboveHours]) {
        [[NSUserDefaults standardUserDefaults] setObject:@2 forKey:UserDefaultKeyAboveHours];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultKeyShowDays]) {
        [[NSUserDefaults standardUserDefaults] setObject:@30 forKey:UserDefaultKeyShowDays];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:HeadImgFilePath]) {
        UIImage *imgHead = [UIImage imageNamed:@"rest.jpg"];
        [UIImageJPEGRepresentation(imgHead, 1.0) writeToFile:HeadImgFilePath atomically:YES];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:BackImgFilePath]) {
        UIImage *imgBack = [UIImage imageNamed:@"back.jpg"];
        [UIImageJPEGRepresentation(imgBack, 1.0) writeToFile:BackImgFilePath atomically:YES];
    }
}

- (void)initDataBase{
    NSLog(@"%@",HeadImgFilePath);
    YSJLOG(@"%@",HeadImgFilePath);
    
    [FMDBHelper dataBaseWithName:@"JiawenClock.sqlite"];
    
    
    if (![FMDBHelper isTableExist:TableNameWorkType]) {
        NSDictionary *workTypeDic = @{@"id":[NSString stringWithFormat:@"%@%@%@",FMDBVarTypeInteger,FMDBTypeCharPrimaryKey,FMDBTypeCharAutoincrement],
                                      LoveNameKey:FMDBVarTypeText,
                                      StartTimeKey:FMDBVarTypeText,
                                      EndTimeKey:FMDBVarTypeText};
        [FMDBHelper createTable:TableNameWorkType withKeyTypeDic:workTypeDic];
        NSArray *array = @[
                           @{StartTimeKey:@"0000",EndTimeKey:@"0000",LoveNameKey:@"休息"},
                           @{StartTimeKey:@"0700",EndTimeKey:@"1600",LoveNameKey:@"早7"},
                           @{StartTimeKey:@"0730",EndTimeKey:@"1630",LoveNameKey:@"早7:30"},
                           @{StartTimeKey:@"0800",EndTimeKey:@"1700",LoveNameKey:@"早8"},
                           @{StartTimeKey:@"0830",EndTimeKey:@"1730",LoveNameKey:@"早8:30"},
                           @{StartTimeKey:@"0900",EndTimeKey:@"1800",LoveNameKey:@"早9"},
                           @{StartTimeKey:@"0930",EndTimeKey:@"1830",LoveNameKey:@"早9:30"},
                           @{StartTimeKey:@"1200",EndTimeKey:@"2000",LoveNameKey:@"中12"},
                           @{StartTimeKey:@"1400",EndTimeKey:@"2200",LoveNameKey:@"中14"},
                           @{StartTimeKey:@"1500",EndTimeKey:@"2300",LoveNameKey:@"中15"},
                           @{StartTimeKey:@"1600",EndTimeKey:@"0000",LoveNameKey:@"晚16"},
                           @{StartTimeKey:@"1630",EndTimeKey:@"0030",LoveNameKey:@"晚16:30"},
                           @{StartTimeKey:@"1700",EndTimeKey:@"0100",LoveNameKey:@"晚17"},
                           @{StartTimeKey:@"1730",EndTimeKey:@"0130",LoveNameKey:@"晚17:30"},
                           @{StartTimeKey:@"1800",EndTimeKey:@"0200",LoveNameKey:@"晚18"},
                           @{StartTimeKey:@"0000",EndTimeKey:@"0700",LoveNameKey:@"通宵班"}];
        for (NSDictionary *dic in array) {
            [FMDBHelper insertKeyValues:dic intoTable:TableNameWorkType];
        }
    }
    NSDictionary *workDayDic = @{WorkDateKey:FMDBVarTypeDatetime,
                                  WorkTypeKey:FMDBVarTypeInteger};
    [FMDBHelper createTable:TableNameWorkDay withKeyTypeDic:workDayDic];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.yushengjie.JiawenClock" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"JiawenClock" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"JiawenClock.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
