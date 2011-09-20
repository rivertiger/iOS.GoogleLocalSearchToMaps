//
//  AddressAnnotation.h
//  CollegeFinder
//
//  Created by USER 1 on 8/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AddressAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *mTitle;
	NSString *mSubtitle;
}
@property (nonatomic, retain) NSString *mTitle;
@property (nonatomic, retain) NSString *mSubtitle;
@end

