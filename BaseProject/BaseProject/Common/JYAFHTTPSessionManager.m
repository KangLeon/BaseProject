//
//  JYAFHTTPSessionManager.m
//  BaseProject
//
//  Created by admin on 2018/11/27.
//  Copyright © 2018 JY. All rights reserved.
//

#import "JYAFHTTPSessionManager.h"

@implementation JYAFHTTPSessionManager

+(JYAFHTTPSessionManager *)sharedJYManager{
    static JYAFHTTPSessionManager *sharedJYAFHTTPSessionManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedJYAFHTTPSessionManager = [[JYAFHTTPSessionManager alloc] init];
        
        // 设置请求类型
        sharedJYAFHTTPSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        // 设置返回类型，去除返回值为null的值
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.removesKeysWithNullValues = YES;
        sharedJYAFHTTPSessionManager.responseSerializer = responseSerializer;
        
        // 设置超时时间
        sharedJYAFHTTPSessionManager.requestSerializer.timeoutInterval = 30;
    });
    
    return sharedJYAFHTTPSessionManager;
}

@end
