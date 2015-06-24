//
//  ZFKeychainUtils.h
//
//  Created by Ruozi on 15/6/23.
//

#import <Foundation/Foundation.h>

typedef void (^SearchKeychainCompletionHandler)(OSStatus status, NSData *result);

@interface ZFKeychainUtils : NSObject

+ (void)searchKeychainCopyMatching:(NSString *)identifier
                   withServiceName:(NSString *)serviceName
                 completionHandler:(SearchKeychainCompletionHandler)handler;

+ (BOOL)createKeychainValue:(NSString *)password
              forIdentifier:(NSString *)identifier
            withServiceName:(NSString *)serviceName;

+ (BOOL)updateKeychainValue:(NSString *)password
              forIdentifier:(NSString *)identifier
            withServiceName:(NSString *)serviceName;

+ (void)deleteKeychainValue:(NSString *)identifier
            withServiceName:(NSString *)serviceName;

@end
