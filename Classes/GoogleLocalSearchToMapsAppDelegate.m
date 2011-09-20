//
//  GoogleLocalSearchToMapsAppDelegate.m
//  GoogleLocalSearchToMaps
//
//  Created by USER 1 on 9/5/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "GoogleLocalSearchToMapsAppDelegate.h"
#import "MapViewController.h"

@implementation GoogleLocalSearchToMapsAppDelegate

@synthesize window;



- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch
    //MapViewController *jsonviewcontroller = [[MapViewController alloc] init];
    //[window addSubview:[jsonviewcontroller view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {

    [window release];
    [super dealloc];
}


@end
