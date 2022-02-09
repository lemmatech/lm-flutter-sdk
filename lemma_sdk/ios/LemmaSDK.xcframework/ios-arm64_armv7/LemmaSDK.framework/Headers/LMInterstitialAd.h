//
//  LMInterstitialAd.h
//  LemmaSDK
//
//  Created by Lemma on 31/01/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <LemmaSDK/LMAdRequest.h>

NS_ASSUME_NONNULL_BEGIN

@class LMInterstitialAd;

/*!
 Protocol for listening interstitial ad events, All events happens on the main thread.
 */
@protocol LMInterstitialAdDelegate<NSObject>
@optional

/// Indicates ad is loaded successfully
- (void)interstitialDidReceiveAd:(LMInterstitialAd *)interstitial;

/// Indicates ad failed to load/render the add, gives error details
- (void)interstitial:(LMInterstitialAd *)interstitial
didFailToReceiveAdWithError:(NSError *_Nullable)error;

/// Indicates ad will be presented on the screen
- (void)interstitialWillPresentAd:(LMInterstitialAd *)interstitial;

/// Indicates ad dismissed from the screen
- (void)interstitialDidDismissAd:(LMInterstitialAd *)interstitial;

/// Indicates ad interactions resulted in app switch
- (void)interstitialWillLeaveApplication:(LMInterstitialAd *)interstitial;

/// Indicates ad click
- (void)interstitialDidClickAd:(LMInterstitialAd *)interstitial;

@end

@interface LMInterstitialAd : NSObject

/// Initializes the interstiail ad with given reqeust
- (instancetype _Nullable)initWithAdRequest:(LMAdRequest *)request;

/// Sets delegate for interstitial events
@property (nonatomic, weak) id<LMInterstitialAdDelegate> delegate;

/// Switch to video, make sure you are passing valid ad units for video while using this option
@property (nonatomic, assign) BOOL switchToVideo;

/// Load interstitial ad
- (void)loadAd;

/// Show interstitial ad
- (void)showFromViewController:(UIViewController *)viewcontroller;
@end

NS_ASSUME_NONNULL_END
