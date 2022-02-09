//
//  LMAdRequest.h
//  LemmaSDK
//
//  Created by Lemma
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMAdRequest : NSObject

@property (nonatomic, strong) NSString *publisherId;
@property (nonatomic, strong) NSString *adunitId;
@property (nonatomic, strong) NSString *serverUrl;
@property (nonatomic, assign) NSUInteger netoworkTimeout;

@end

NS_ASSUME_NONNULL_END
