//
//  HTTPDemoViewController.m
//  meep
//
//  Created by Alex Jarvis on 12/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HTTPDemoViewController.h"

#import "ASIHTTPRequest.h"

@implementation HTTPDemoViewController

@synthesize label;
@synthesize methodStart;

- (void)viewDidLoad {
	//[super viewDidLoad];
}


- (IBAction)loginRequest {
	NSURL *url = [NSURL URLWithString:@"https://192.168.0.1:9443"];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request setValidatesSecureCertificate:NO];
	[request startAsynchronous];
	self.methodStart = [NSDate date];
		
	
	label.text = @"Login Request Sent";
	
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSDate *methodFinish = [NSDate date];
	NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
	
	
	label.text = [NSString stringWithFormat:@"Response received in: %@ms", 
				  [NSString stringWithFormat:@"%g", executionTime*1000]];
	
	// Use when fetching text data
	NSString *responseString = [request responseString];
	
	NSLog(@"Response String: %@", responseString);
	
	// Use when fetching binary data
	NSData *responseData = [request responseData];
	
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	label.text = @"Request failed";
	NSError *error = [request error];
	NSLog(@"Error: %@", [error localizedDescription]);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[label dealloc];
	[methodStart dealloc];
    [super dealloc];
}


@end
