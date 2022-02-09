//
//  LemmaSDK.h
//  LemmaSDK
//
//  Created by Lemma
//

#import <Foundation/Foundation.h>

//! Project version number for LemmaSDK.
FOUNDATION_EXPORT double LemmaSDKVersionNumber;

//! Project version string for LemmaSDK.
FOUNDATION_EXPORT const unsigned char LemmaSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <LemmaSDK/PublicHeader.h>


#import <CoreLocation/CoreLocation.h>
#import <LemmaSDK/LMTypes.h>
#import <LemmaSDK/LMAdRequest.h>
#import <LemmaSDK/LMBannerView.h>
#import <LemmaSDK/LMInBannerVideo.h>
#import <LemmaSDK/LMInterstitialAd.h>

@interface LemmaSDK: NSObject
+ (LemmaSDK *) shared;

/// Get SDK version
+ (NSString *)version;

/// Sets log level
+ (void)setLevel:(LMLogLevel)level;

/// Indicates the domain of the mobile application
@property(nonatomic, strong) NSString *appDomain;

/// Valid URL of the application on App store
@property(nonatomic, strong) NSURL *storeURL;

/// Comma separated list of IAB categories, examples "IAB-2, IAB-4"
@property(nonatomic, strong) NSString *appCategories;

/// Comman separated application keywords
@property (nonatomic, strong) NSString *appkeywords;

/// Comman separated user keywords
@property (nonatomic, strong) NSString *userKeywords;

/// User location
@property (nonatomic, strong) CLLocation *location;

/// Coppa compliance
@property (nonatomic, assign) BOOL coppa;

/// GDPR compliance
@property (nonatomic, assign) BOOL gdpr;

/// GDPR consent string, as per IAB guideline - https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework.
@property (nonatomic, strong) NSString *gdprConsent;

@end
