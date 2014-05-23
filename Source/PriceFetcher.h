
//  PriceFetcher.h
//  Douglas Hill, May 2014

@import Foundation;
@import StoreKit;

@class PriceFetcher;
@protocol PriceFetcherDelegate <NSObject>

@optional
- (void)priceFetchDidUpdate:(PriceFetcher *)priceFetcher;

@end

@interface PriceFetcher : NSObject

@property (nonatomic, weak) id <PriceFetcherDelegate> delegate;

@property (nonatomic, copy, readonly) NSDecimalNumber *price;

- (void)refreshPrice;

@end
