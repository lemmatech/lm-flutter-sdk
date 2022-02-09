//
//  LMBannerView.h
//  LemmaSDK
//
//  Created by Lemma
//

#import <UIKit/UIKit.h>
#import <LemmaSDK/LMAdRequest.h>

NS_ASSUME_NONNULL_BEGIN

@class LMBannerView;

@protocol LMBannerViewDelegate<NSObject>

@optional

/// Indicates ad successfully loaded and rendered.
- (void)bannerViewDidReceiveAd:(LMBannerView *)bannerView;

/// Indicates ad failed to load/render the add, gives error details
- (void)bannerView:(LMBannerView *)bannerView
didFailToReceiveAdWithError:(NSError *_Nullable)error;

/// Indicates ad interactions will results in modal presentation convering the screen
- (void)bannerViewWillPresentModal:(LMBannerView *)bannerView;

/// Indicates ad interactions will results in modal dismissal
- (void)bannerViewDidDismissModal:(LMBannerView *)bannerView;

@end

@interface LMBannerView : UIView

/// Initializes the interstiail ad with given reqeust
- (instancetype _Nullable)initWithAdRequest:(LMAdRequest *)request
                                  andAdSize:(CGSize )size;

/// Sets delegate for interstitial events
@property (nonatomic, weak) id<LMBannerViewDelegate> delegate;

/// Sets the presentation view controller, used for presenting modals. Example -
/// showing in-app browser. Note that it is mandatory settings
@property (nonatomic, weak) UIViewController *presentationViewController;

/// Sets refresh interval, by defualt refresh is off with value as 0. Please use
/// value between 15 - 90 seconds for better user experience
@property (nonatomic, assign) NSUInteger refreshInterval;

/// Loads the ad
- (void)loadAd ;

@end

NS_ASSUME_NONNULL_END
