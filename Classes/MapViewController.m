//
//  MapViewController.m
//  CollegeFinder
//
//  Created by USER 1 on 8/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "AddressAnnotation.h"
#import "JSON.h"
#import "AccessoryView.h"

@implementation MapViewController


- (void)dealloc {
    [super dealloc];
	[queryTypeString release];
	[AnnotationSubtitle release];
	[AnnotationTitle release];
	[listOfAddresses release];
}

- (id)init
{

	//Set the Title for the View
	if (!(self = [super init])) return self;
	self.title = @"Google Maps";
	

	return self;
}

- (void)queryYouTube {
	username = @"rivertiger911";
	NSLog(@"query YouTube is called.");
	// Create new SBJSON parser object
	SBJSON *jparser = [[SBJSON alloc] init];
	jparser.humanReadable = YES;
	
	//OPTION 1: googleAJAXURL string for Web Search results
	//NSString *googleAJAXURL = @"http://ajax.googleapis.com/ajax/services/search/web?v=1.0&&mrt=localonly&q=";
	
	//OPTION 2: googleAJAXURL string for local Search results -- (4) complete datasets are returned each query
	//NSString *googleAJAXURL = @"http://ajax.googleapis.com/ajax/services/search/local?v=1.0&q=";
	NSString *googleAJAXURL = @"http://gdata.youtube.com/feeds/users/";
	
	//call to clean up the passed query
	googleAJAXURL = [googleAJAXURL stringByAppendingString:username];
	googleAJAXURL = [googleAJAXURL stringByAppendingString:@"/uploads?alt=json&format=5"];
	//NSLog(@"googleAJAXURL = %@", googleAJAXURL);
	
	// Perform NSURL request and get back as a NSData object
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:googleAJAXURL]];	
	NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
	//NSLog(@"returnstring = %@", returnString);	
	
	// parse the JSON response into an object
	// Here we're using NSArray since we're parsing an array of JSON response objects
	NSDictionary *JSONresponse = [jparser objectWithString:returnString error:nil];
	//NSLog(@"JSONresponse = %@", JSONresponse);
	
	// You can retrieve individual values using objectForKey on the status NSDictionary
	// This gives you the entire Youtube "feed"
	NSDictionary *JSONresponseSection = [JSONresponse objectForKey:@"feed"];
	//NSLog(@"JSPNresponsesection = %@", JSONresponseSection);
	
	// This entry returns all the list of Videos into an Array
	NSArray *JSONAllVideos = [JSONresponseSection objectForKey:@"entry"];
	//NSLog(@"JSONAllVideos = %@", JSONAllVideos);
	
	int i;
	for(i=0; i<[JSONAllVideos count]; i++) {
	//This entry creates a dictionary to contain all metadata for one video
	NSDictionary *JSONOneVideo = [JSONAllVideos objectAtIndex:i];
	//NSLog(@"JSONOneVideo = %@", JSONOneVideo);
	
	//This entry creates a dictionary to seek out the title and add it to global IVAR _videoArrayTitle
	NSDictionary *JSONtitleSet = [JSONOneVideo objectForKey:@"title"];
	//NSLog(@"JSONtitleSet = %@", JSONtitleSet);
	NSString *JSONVideoTitle = [JSONtitleSet objectForKey:@"$t"];
	//NSLog(@"JSONVideoTitle = %@", JSONVideoTitle);
		_GLOBALVideoTitles = JSONVideoTitle;
		NSLog(@"GlobalVideoTitles = %@", _GLOBALVideoTitles);
		
	//This entry creates a dictionary to seek out the media set which includes description, player, URL
	NSDictionary *JSONmediaSet= [JSONOneVideo objectForKey:@"media$group"];
	//NSLog(@"JSONmediaSet = %@", JSONmediaSet);	
	//This entry creates a dictionary to seek out the title and add it to global IVAR _videoArrayTitle
	NSDictionary *JSONdescriptionSet= [JSONmediaSet objectForKey:@"media$description"];
	//NSLog(@"JSONdescriptionSet = %@", JSONmediaSet);	
	_GLOBALVideoDescription = [JSONdescriptionSet objectForKey:@"$t"];
		NSLog(@"GlobalVideoDescription = %@", _GLOBALVideoDescription);	
		
	//This entry creates a dictionary to seek out the title and add it to global IVAR _videoArrayTitle
	NSArray *JSONmediaPlayerSet= [JSONmediaSet objectForKey:@"media$player"];
	NSArray *urlString = [JSONmediaPlayerSet objectAtIndex:0];
	_GLOBALVideoURLs = [urlString valueForKey:@"url"];
		NSLog(@"GlobalVideoURL = %@", _GLOBALVideoURLs);
		
	//This entry creates a dictionary to seek out the title and add it to global IVAR _videoArrayTitle
	JSONmediaPlayerSet= [JSONmediaSet objectForKey:@"media$content"];
	NSArray *contentArray = [JSONmediaPlayerSet objectAtIndex:0];
	_GLOBALVideoFlashURLs = [contentArray valueForKey:@"url"];
	NSLog(@"GlobalVideoFlashURL = %@", _GLOBALVideoFlashURLs);		
	}
	/*
	//HERES THE LOOP OF THE DATASET - count, collect fields, get coordinates and plot
	int i;
	for(i=0; i<[resultsSet count]; i++) {
		NSDictionary *JSONresponseSectionSet = [resultsSet objectAtIndex:i];
		NSString *link = [JSONresponseSectionSet objectForKey:@"link"];
		//NSLog(@"link is = %@", link);
	}	
	*/
	

}

//Create the View and call the location coordinate and create the annotation--pass the title & address
- (void)viewDidLoad {
	NSLog(@"viewDidLoad was called");
	
	[super viewDidLoad];
	
	//initialize dummy variables to be used for single Query;
	AnnotationSubtitle = @"Subtitle of Query Point";
	AnnotationTitle = @"Title of Query Point";

	NSString *queryLocationString = @"Irvine, CA";
	NSString *queryTypeString = @"Restaurant";

	
	//Initialize dummy variables for location string and queryTypeString--NOTE: only one word currently used for Google Local Search
	//queryLocationString = @"Lake Forest, CA";
	queryTypeString = @"JambaJuice";

	
	listOfAddresses = [[NSArray alloc] initWithObjects:queryLocationString,  nil];
	[self createMapView];
	[self getCenterPointOfMapView];
	
	
	//Adjust query number ot retrieve the set starting at number specified--NOT total number returned.
	//NSLog(@"first set is called.");
	//[self queryGoogleLocalSearch:@"0" addressPassed:queryLocationString typePassed:queryTypeString];
	//NSLog(@"second set is called.");
	//[self queryGoogleLocalSearch:@"4" addressPassed:queryLocationString typePassed:queryTypeString];
	
	_GLOBALVideoThumbnailImages = nil;
	_GLOBALVideoURLs = nil;
	_GLOBALVideoTitles = nil;
	//[self queryYouTube];
	
}

# pragma mark
# pragma mark custom methods
//Function to geolocate the address text to a CLLocation Coordinate values
-(CLLocationCoordinate2D) addressLocation:(NSString *)address {
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", 
						   [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSArray *listItems = [locationString componentsSeparatedByString:@","];
	
    double latitude = 0.0;
    double longitude = 0.0;
	
    if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
        latitude = [[listItems objectAtIndex:2] doubleValue];
        longitude = [[listItems objectAtIndex:3] doubleValue];
    }
    else {
		//Show error
    }
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
	
    return location;
}


//Function to change the latitude nsstrings to double values and return CLLocation Object
-(CLLocationCoordinate2D) convertLat:(NSString *)latitude convertLong:(NSString *)longitude {
	double lat = [latitude doubleValue];
	double lon = [longitude doubleValue];

	//CLLocation *coordinateLocation = [[[CLLocation alloc] initWithLatitude:lat longitude:lon] autorelease];
	CLLocationCoordinate2D location;
	location.latitude = lat;
	location.longitude = lon;
	return location;
}

//Function to getCenterPointofMapView
- (CLLocationCoordinate2D)getCenterPointOfMapView {
	CLLocationCoordinate2D centerpoint2D = mapView.centerCoordinate;
	//double lat = centerpoint2D.latitude;
	//double lon = centerpoint2D.longitude;
	NSLog(@"centerpoint of MapView lat is %f, long is %f",centerpoint2D.latitude,centerpoint2D.longitude);
	return centerpoint2D;
	
	//CLLocation *centerPoint = [centerpoint2D initWithCoordinate:centerpoint2D];
		//NSLog(@"description coordinates is: %@",description);
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
}

//Function to set the annotation View
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    annView.pinColor = MKPinAnnotationColorPurple;
    annView.animatesDrop=TRUE;
    annView.canShowCallout = YES;
    annView.calloutOffset = CGPointMake(-5, 5);
    return annView;
}



- (void)queryGoogleLocalSearch:(NSString *)querySetNumber addressPassed:(NSString *)address typePassed:(NSString *)typeOfBusiness {
	// Create new SBJSON parser object
	SBJSON *jparser = [[SBJSON alloc] init];
	jparser.humanReadable = YES;
	
	//OPTION 1: googleAJAXURL string for Web Search results
	//NSString *googleAJAXURL = @"http://ajax.googleapis.com/ajax/services/search/web?v=1.0&&mrt=localonly&q=";
	
	//OPTION 2: googleAJAXURL string for local Search results -- (4) complete datasets are returned each query
	NSString *googleAJAXURL = @"http://ajax.googleapis.com/ajax/services/search/local?v=1.0&q=";
	//call to clean up the passed query
	googleAJAXURL = [[[googleAJAXURL stringByAppendingString:[self cleanupString:address]] stringByAppendingString:@"%20"] stringByAppendingString:typeOfBusiness];
	googleAJAXURL = [[googleAJAXURL stringByAppendingString:@"&start="] stringByAppendingString:querySetNumber];
	//NSLog(@"googleAJAXURL = %@", googleAJAXURL);
	
	// Perform NSURL request and get back as a NSData object
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:googleAJAXURL]];	
	NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
	//NSLog(@"returnstring = %@", returnString);	
	
	// parse the JSON response into an object
	// Here we're using NSArray since we're parsing an array of JSON response objects
	NSDictionary *JSONresponse = [jparser objectWithString:returnString error:nil];

	// You can retrieve individual values using objectForKey on the status NSDictionary
	// This example is for locating only name, lat, long but other values are provided too.
	NSDictionary *JSONresponseSection = [JSONresponse objectForKey:@"responseData"];
	
	//SUBSET 2:Get the center point for all locations in this local search
	NSArray *resultsSet = [JSONresponseSection objectForKey:@"results"];
	//NSLog(@"resultsSet = %@", resultsSet);
	
	//HERES THE LOOP OF THE DATASET - count, collect fields, get coordinates and plot
	int i;
	for(i=0; i<[resultsSet count]; i++) {

	NSDictionary *JSONresponseSectionSet = [resultsSet objectAtIndex:i];
	//NSLog(@"JSONresponseSectionSet = %@", JSONresponseSectionSet);
	NSString *title = [JSONresponseSectionSet objectForKey:@"titleNoFormatting"];
	//NSLog(@"title = %@", title);
	//title = [self flattenHTML:title trimWhiteSpace:TRUE];
	//NSLog(@"title = %@", title);
	NSArray *addressArray = [JSONresponseSectionSet objectForKey:@"addressLines"];
	NSString *street = [addressArray objectAtIndex:0];
	NSString *city = [addressArray objectAtIndex:1];
	street = [street stringByAppendingString:city];
	NSString *lat = [JSONresponseSectionSet objectForKey:@"lat"];
	NSString *lng = [JSONresponseSectionSet objectForKey:@"lng"];
	
	CLLocationCoordinate2D JSONresponseSectionCoordinatePt = [self convertLat:lat convertLong:lng];
	AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:JSONresponseSectionCoordinatePt];
	addAnnotation.mTitle = title;
	addAnnotation.mSubtitle = street;
	[mapView addAnnotation:addAnnotation];
	[addAnnotation release];
	
	}
	
	/*
		//SUBSET 3:Get the center point for all locations in this local search
		NSDictionary *viewport = [JSONresponseSection objectForKey:@"viewport"];
		NSLog(@"viewport = %@", viewport);
		NSDictionary *centerPt = [viewport objectForKey:@"center"];
		NSLog(@"centerPt = %@", centerPt);
	
	NSString  *centerlat = [centerPt objectForKey:@"lat"];
	NSString *centerlong = [centerPt objectForKey:@"lng"];
	*/
	
}

- (NSString *)queryGoogleReverseGeocoding:(CLLocationCoordinate2D)updatedCenterCoordinate {
	double reverselatitude = updatedCenterCoordinate.latitude;
	double reverselongitude = updatedCenterCoordinate.longitude;
	NSString *latAndLongString = [NSString stringWithFormat:@"%f", reverselatitude];
	latAndLongString = [latAndLongString stringByAppendingString:@","];
	//NSLog(@"latandLongString is: %@", latAndLongString);
	latAndLongString = [latAndLongString stringByAppendingString:[NSString stringWithFormat:@"%f", reverselongitude]];
	//NSLog(@"latandLongString is: %@", latAndLongString);
	
	//CODE TO GOOGLE REVERSE GEOCODE
	NSString *googleMapURL = @"http://maps.google.com/maps/geo?q=";
	googleMapURL = [[[googleMapURL stringByAppendingString:latAndLongString] stringByAppendingString:@"&output=json&oe=utf8&sensor=true_or_false&key="] stringByAppendingString:kGMAPKEY];
	//NSLog(@"googleMapURL: %@",googleMapURL);
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:googleMapURL]];	
	NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
	
	// Create new SBJSON parser object
	SBJSON *jparser = [[SBJSON alloc] init];
	jparser.humanReadable = YES;
	NSDictionary *JSONresponse = [jparser objectWithString:returnString error:nil];
	// parse the JSON response into an object
	// Here we're using NSArray since we're parsing an array of JSON response objects
	//NSLog(@"JSONresponse = %@", JSONresponse);
	NSArray *JSONresponseSection = [JSONresponse objectForKey:@"Placemark"];
	//NSLog(@"JSONresponseSection = %@", JSONresponseSection);
	NSDictionary *resultsSet = [JSONresponseSection objectAtIndex:0];
	//NSLog(@"resultSet = %@", resultsSet);
	NSString *currentAddressLocation = [resultsSet objectForKey:@"address"];
	NSLog(@"currentAddressLocation = %@", currentAddressLocation);
	//SUBSET 2:Get the center point for all locations in this local search
	//NSArray *resultsSet = [JSONresponseSection objectForKey:@"address"];
	return currentAddressLocation;
	[currentAddressLocation release];
	[resultsSet release];
	[JSONresponseSection release];
}


- (void)createMapView {
	//BELOW CODE: ORIGINAL TO LAUNCH MAPVIEW
	mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
	mapView.mapType=MKMapTypeStandard;
	mapView.delegate=self;
	mapView.showsUserLocation=YES;
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.05;
	span.longitudeDelta=0.05;
	
	//Call to find CLLocation coordinate based on listOfAddresses array --more addresses, more coordinates
	int i;
	for(i=0; i<[listOfAddresses count]; i++) {
	CLLocationCoordinate2D location = [self addressLocation:[listOfAddresses objectAtIndex:i]];
	region.span=span;
	region.center=location;
	AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location];
	addAnnotation.mTitle = AnnotationTitle;
	addAnnotation.mSubtitle = AnnotationSubtitle;
	
		//accessoryView
		//AccessoryView *calloutView = [[AccessoryView alloc] init];
		//calloutView = addAnnotation.leftCalloutAccessoryView;
		
	[mapView addAnnotation:addAnnotation];
	[mapView setRegion:region animated:TRUE];
	[addAnnotation release];
	}
	
	[mapView regionThatFits:region];
	[self.view insertSubview:mapView atIndex:0];
	[mapView release];
	
}


- (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim {
	NSScanner *theScanner;
	NSString *text = nil;
	theScanner = [NSScanner scannerWithString:html];
	while ([theScanner isAtEnd] == NO) {
		
		// find start of tag
		[theScanner scanUpToString:@"<" intoString:NULL] ;
		// find end of tag
		[theScanner scanUpToString:@">" intoString:&text] ;
		
		// replace the found tag with a space
		//(you can filter multi-spaces out later if you wish)
		html = [html stringByReplacingOccurrencesOfString:
				[ NSString stringWithFormat:@"%@>", text]
											   withString:@" "];
	} // while //
	// trim off whitespace
	return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}


-(NSString *)cleanupString:(NSString *)theString
{
	//remove commas and substitute spaces with search characters
	theString = [theString stringByReplacingOccurrencesOfString:@"," withString:@" "];
	NSArray *comps = [theString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	NSMutableArray *words = [NSMutableArray array];
	for(NSString *comp in comps) {
		if([comp length] > 0) {
			[words addObject:comp];
		}
	}
	
	NSString *result = [words componentsJoinedByString:@"%20"];
	//NSLog(@"address is %@", result);
	return result;
	[comps release];
	[words release];
	[result release];
	
}


# pragma mark
# pragma mark delegate methods
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	NSLog(@"calloutAccessoryControlTapped delegate method was called.");
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
	NSLog(@"regionDidChangeAnimated delegate method was called.");
	CLLocationCoordinate2D centerpoint2D = mapView.centerCoordinate;
	NSLog(@"updated centerpoint2D lat is %f, long is %f",centerpoint2D.latitude,centerpoint2D.longitude);
	NSString *updatedAddress = [self queryGoogleReverseGeocoding:centerpoint2D];

	[self queryGoogleLocalSearch:@"0" addressPassed:updatedAddress typePassed:@"Restaurants"];

	//[self queryGoogleLocalSearch:@"0" addressPassed:updatedAddress typePassed:queryTypeString];

}

@end