//
//  YouTubeTableViewController.m
//  GoogleLocalSearchToMaps
//
//  Created by USER 1 on 10/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "YouTubeTableViewController.h"
#import "JSON.h"

@implementation YouTubeTableViewController


- (void)dealloc {
    [super dealloc];
}

- (id)init
{
	
	//Set the Title for the View
	if (!(self = [super init])) return self;
	self.title = @"YouTube TVC";
	
	
	return self;
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/
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

- (void)viewDidLoad {
    [super viewDidLoad];
	[self queryYouTube];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	
    return cell.text = @"youtube stuff";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/





@end

