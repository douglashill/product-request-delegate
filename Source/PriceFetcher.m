
//  PriceFetcher.m
//  Douglas Hill, May 2014

#import "PriceFetcher.h"

// Set this to 0 to observe the problem, or 1 to apply the fix.
#define PREVENT_PREMATURE_DEALLOCATION 0

// Set this to a product identifier that has been set up on iTunes Connect for the correct bundle identifier.
#warning You need to set the product identifier.
static NSString * const productIdentifier = @"???";

@interface PriceFetcher () <SKProductsRequestDelegate>

@property (nonatomic, copy) NSDecimalNumber *price;

@property (nonatomic, strong) SKProductsRequest *request;

#if PREVENT_PREMATURE_DEALLOCATION
@property (nonatomic, strong) PriceFetcher *secondSelf;
#endif

@end

@implementation PriceFetcher

- (void)dealloc {
	NSLog(@"%s START", __PRETTY_FUNCTION__);
	
	[[self request] setDelegate:nil];
	[[self request] cancel];
	
	NSLog(@"%s END", __PRETTY_FUNCTION__);
}

- (void)refreshPrice {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productIdentifier]];
	[self setRequest:request];
	[request setDelegate:self];
	[request start];
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	NSLog(@"%s START", __PRETTY_FUNCTION__);
	
#if PREVENT_PREMATURE_DEALLOCATION
	[self setSecondSelf:self];
#endif
	
	[self setPrice:[[[response products] firstObject] price]];
	
	if ([[self delegate] respondsToSelector:@selector(priceFetchDidUpdate:)]) {
		[[self delegate] priceFetchDidUpdate:self];
	}
	
	NSLog(@"%s END", __PRETTY_FUNCTION__);
}

#pragma mark - SKRequestDelegate

- (void)requestDidFinish:(SKRequest *)request {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	NSLog(@"The request’s delegate is %@", [request delegate]);
	
	[self setRequest:nil];
	
#if PREVENT_PREMATURE_DEALLOCATION
	[self setSecondSelf:nil];
#endif
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
	
	[self setRequest:nil];
	
#if PREVENT_PREMATURE_DEALLOCATION
	[self setSecondSelf:nil];
#endif
}

@end
