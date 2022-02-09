//
//  LMBannerView.h
//  LemmaSDK
//
//  Created by Lemma
//

#import <UIKit/UIKit.h>
#import <LemmaSDK/LMAdRequest.h>

NS_ASSUME_NONNULL_BEGIN

@class LMInBannerVideo;

@protocol LMInBannerVideoDelegate<NSObject>

@optional

/// Indicates ad successfully loaded and rendered.
- (void)bannerViewDidReceiveAd:(LMInBannerVideo *)bannerView;

/// Indicates ad successfully loaded and rendered.
- (void)bannerViewDidFinishPlayingAd:(LMInBannerVideo *)bannerView;

/// Indicates ad failed to load/render the add, gives error details
- (void)bannerView:(LMInBannerVideo *)bannerView
didFailToReceiveAdWithError:(NSError *_Nullable)error;

/// Indicates ad interactions will results in modal presentation convering the screen
- (void)bannerViewWillPresentModal:(LMInBannerVideo *)bannerView;

/// Indicates ad interactions will results in modal dismissal
- (void)bannerViewDidDismissModal:(LMInBannerVideo *)bannerView;

@end

@interface LMInBannerVideo : UIView

/// Initializes the interstiail ad with given reqeust
- (instancetype _Nullable)initWithAdRequest:(LMAdRequest *)request
                                  andAdSize:(CGSize )size;

/// Sets delegate for interstitial events
@property (nonatomic, weak) id<LMInBannerVideoDelegate> delegate;

/// Sets the presentation view controller, used for presenting modals. Example -
/// showing in-app browser. Note that it is mandatory settings
@property (nonatomic, weak) UIViewController *presentationViewController;

/// Loads the ad
- (void)loadAd;


/// Start playing the ad
- (void)playAd;

@end

NS_ASSUME_NONNULL_END
