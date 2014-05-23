
//  AppDelegate.m
//  Douglas Hill, May 2014

#import "AppDelegate.h"
#import "PriceFetcher.h"

@interface AppDelegate () <PriceFetcherDelegate>

@property (nonatomic, strong) PriceFetcher *priceFetcher;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	PriceFetcher *fetcher = [[PriceFetcher alloc] init];
	[self setPriceFetcher:fetcher];
	[fetcher setDelegate:self];
	[fetcher refreshPrice];
	
	[self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
	[[self window] setBackgroundColor:[UIColor orangeColor]];
	[[self window] makeKeyAndVisible];
	
	return YES;
}

#pragma mark - PriceFetcherDelegate

- (void)priceFetchDidUpdate:(PriceFetcher *)priceFetcher {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	NSLog(@"The price is %@", [priceFetcher price]);
	
	[self setPriceFetcher:nil];
}

@end
