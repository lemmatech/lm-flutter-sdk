//
//  LMTypes.h
//  LemmaSDK
//
//  Created by Lemma on 21/02/21.
//

#import <Foundation/Foundation.h>

/**
 *  Log levels
 */
typedef NS_ENUM(NSUInteger, LMLogLevel){
    LMLogLevelOff       = 0,
    LMLogLevelError,
    LMLogLevelWarning,
    LMLogLevelInfo,
    LMLogLevelDebug,
    LMLogLevelVerbose,
    LMLogLevelAll,
};

typedef NS_ENUM(NSInteger, LMErrorCode)  {
    LMErrorNoAds,
    LMErrorInternalError,
    LMErrorRenderError,
    
    LMErrorAdNotUsed,
    LMErrorAdAlreadyShown,
    LMErrorAdNotReady,
};
