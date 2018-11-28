//
//  JYAFHTTPSessionManager.h
//  BaseProject
//
//  Created by admin on 2018/11/27.
//  Copyright © 2018 JY. All rights reserved.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface JYAFHTTPSessionManager : AFHTTPSessionManager
+(JYAFHTTPSessionManager *)sharedJYManager;
//setUserAgent:not in this version
@end

NS_ASSUME_NONNULL_END
