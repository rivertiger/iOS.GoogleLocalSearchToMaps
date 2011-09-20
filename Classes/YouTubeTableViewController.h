//
//  YouTubeTableViewController.h
//  GoogleLocalSearchToMaps
//
//  Created by USER 1 on 10/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YouTubeTableViewController : UITableViewController <UITableViewDelegate> {
	//YouTube IVARs
	NSString					*username;
	NSString				*_GLOBALVideoThumbnailImages;
	NSString				*_GLOBALVideoURLs;
	NSString				*_GLOBALVideoTitles;
	NSString				*_GLOBALVideoDescription;
	NSString				*_GLOBALVideoFlashURLs;
}
-(void) queryYouTube;
@end
