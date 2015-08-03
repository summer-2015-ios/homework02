//
//  AppDelegate.m
//  Homework2
//
//  Created by student on 7/30/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse.h>
#import "SignUpViewController.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Parse setApplicationId:@"JzSwPgrPHo6elyJgTPDkqPY30ZfTZ0pEY6TnVqgM"
                  clientKey:@"JXK5ypEm1TD113hSgkyzgEq2JaSoPiJcqx71c2V8"];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"App entered bg");
    self.emailFromUrl = nil;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSString* queryString = [url query];
    queryString = [queryString stringByRemovingPercentEncoding];
    @try{
        self.emailFromUrl = [queryString componentsSeparatedByString:@"="][1];
        NSLog(@"url open app with email: %@", self.emailFromUrl);
        UIViewController* activeVC = [self getActiveVC:self.window.rootViewController];
        if([activeVC isKindOfClass:[ViewController class]]){
            ViewController* vc = (ViewController*)activeVC;
            vc.emailFromUrl = self.emailFromUrl;
            [vc performSegueWithIdentifier:@"signUpSegue" sender:vc];
        }else if([activeVC isKindOfClass:[SignUpViewController class]]){
            SignUpViewController* vc = (SignUpViewController*)activeVC;
            vc.emailTV.text =  self.emailFromUrl;
        }
//        NSDictionary* dict = @{@"email" : self.emailFromUrl};
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"emailFromUrlReceived" object:nil userInfo:dict];
    }@catch (NSException *exception) {
        return NO;
    }@finally {
        
    }
    return YES;
}

-(UIViewController*) getActiveVC: (UIViewController*) rootVC{
    if(!rootVC.presentedViewController){
        return rootVC;
    }
    return [self getActiveVC:rootVC.presentedViewController];
}

@end
