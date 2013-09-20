//
//  AppDelegate.m
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate


- (void)dealloc
{
    [_viewController release];
    [_window release];
    [super dealloc];
}

- (id)init
{
    if ((self = [super init]))
    {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _viewController = [[SPViewController alloc] init];
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    LinkedList ll;
	int i;
    
	for (i=0; i<20; i++)
	{
		if (i==0)
		{
		    ll = createNode(&i);
		}
		else
		{
			addNode(ll, &i);
		}
	}
    printf("Loop...");
    print(ll);
    
    int k = 1000;
    int j = 15;
    
    printf("addNodeAtIndex...");
    addNodeAtIndex(ll, &k, 10);
    print(ll);
    
    printf("removeNode...");
    removeNode(ll, &j);
    print(ll);

//    for (ORule *rule in [ORule allRules])
//    {
//        NSLog(@"%@", rule.name);
//    }
    
//    for (OCard *card in [OCard allCards])
//    {
//        NSLog(@"%@", card.name);
//    }

//    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor whiteColor];
    

    // Enable some common settings here:
    // _viewController.showStats = YES;
    _viewController.multitouchEnabled = YES;
    _viewController.preferredFramesPerSecond = 60;
  
    [_viewController startWithRoot:[OGameScene class] supportHighResolutions:YES doubleOnPad:YES];
//    _viewController.onRootCreated = ^(OGame *game)
//	{
//	    // access your game instance here
//	};
    
    [_window setRootViewController:_viewController];
    [_window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
