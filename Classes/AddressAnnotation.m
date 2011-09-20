//
//  AddressAnnotation.m
//  CollegeFinder
//
//  Created by USER 1 on 8/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AddressAnnotation.h"


@implementation AddressAnnotation

@synthesize coordinate;
@synthesize mTitle;
@synthesize mSubtitle;

- (NSString *)subtitle{
	return mSubtitle;
}

- (NSString *)title{
	return mTitle;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	NSLog(@"Annotation marker was placed at %f,%f",c.latitude,c.longitude);
	return self;
}
@end