//
//  MapViewController.h
//  CollegeFinder
//
//  Created by USER 1 on 8/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
// 9-13-09 

#define kGMAPKEY			@"ABQIAAAAPuY_qhGenhh-aaeBVE9ikBQKPMapD0wkVq_xF-PMA2jVeMIc2RSJNIMPUYzCpTTfRD0edWdtkXwbbQ"

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <CoreLocation/CoreLocation.h>


@interface MapViewController : UIViewController <MKMapViewDelegate>{
	NSString			*AnnotationSubtitle;
	NSString			*AnnotationTitle;
	MKMapView			*mapView;
	NSArray				*listOfAddresses;
	NSString			*queryTypeString;

	//YouTube IVARs
	NSString					*username;
	NSString				*_GLOBALVideoThumbnailImages;
	NSString				*_GLOBALVideoURLs;
	NSString				*_GLOBALVideoTitles;
	NSString				*_GLOBALVideoDescription;
	NSString				*_GLOBALVideoFlashURLs;
}

-(void) queryYouTube;
-(void) createMapView;
- (void)queryGoogleLocalSearch:(NSString *)querySetNumber addressPassed:(NSString *)address typePassed:(NSString *)typeOfBusiness;
- (NSString *)queryGoogleReverseGeocoding:(CLLocationCoordinate2D)updatedCenterCoordinate;
-(CLLocationCoordinate2D) getCenterPointOfMapView;
-(NSString *)cleanupString:(NSString *)theString;
@end




