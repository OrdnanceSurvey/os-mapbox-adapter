//
//  OSProtocolSwizzleSorry.m
//  OSMapboxAdapter
//
//  Created by Dave Hardiman on 04/05/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

#import "OSProtocolSwizzleSorry.h"
#import <objc/runtime.h>

@interface NSURLSessionConfiguration (Sorry)
+ (NSURLSessionConfiguration *)os_defaultSessionConfiguration;
@end

@interface OSMapsStyleProtocol : NSURLProtocol
@end

@implementation OSProtocolSwizzleSorry

+ (void)load {
    Method originalMethod = class_getClassMethod(NSURLSessionConfiguration.class, @selector(os_defaultSessionConfiguration));
    Method replacementMethod = class_getClassMethod(NSURLSessionConfiguration.class, @selector(defaultSessionConfiguration));
    method_exchangeImplementations(originalMethod, replacementMethod);
}

@end

@implementation NSURLSessionConfiguration (Sorry)

+ (NSURLSessionConfiguration *)os_defaultSessionConfiguration {
    NSURLSessionConfiguration *config = [self os_defaultSessionConfiguration];
    NSMutableArray *protocols = [config.protocolClasses mutableCopy];
    [protocols addObject:[OSMapsStyleProtocol class]];
    config.protocolClasses = protocols.copy;
    return config;
}

@end
