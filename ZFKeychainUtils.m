//
//  ZFKeychainUtils.m
//
//  Created by Ruozi on 15/6/23.
//

#import "ZFKeychainUtils.h"
#import <Security/Security.h>

@implementation ZFKeychainUtils

+ (void)searchKeychainCopyMatching:(NSString *)identifier
                   withServiceName:(NSString *)serviceName
                 completionHandler:(SearchKeychainCompletionHandler)handler {
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier withServiceName:serviceName];
    
    // Add search attributes
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    // Add search return types
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    NSData *result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary,
                                          (CFTypeRef *)(void *)&result);
    
    if (nil != handler) {
        handler(status,result);
    }
    
}

+ (BOOL)createKeychainValue:(NSString *)password
              forIdentifier:(NSString *)identifier
            withServiceName:(NSString *)serviceName{
    NSMutableDictionary *dictionary = [self newSearchDictionary:identifier withServiceName:serviceName];
    
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:passwordData forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

+ (BOOL)updateKeychainValue:(NSString *)password
              forIdentifier:(NSString *)identifier
            withServiceName:(NSString *)serviceName{
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier withServiceName:serviceName];
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [updateDictionary setObject:passwordData forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)searchDictionary,
                                    (__bridge CFDictionaryRef)updateDictionary);
    
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

+ (void)deleteKeychainValue:(NSString *)identifier
            withServiceName:(NSString *)serviceName{
    
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier withServiceName:serviceName];
    SecItemDelete((__bridge CFDictionaryRef)searchDictionary);
}

+ (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier withServiceName:(NSString *)serviceName {
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    [searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];
    
    return searchDictionary;
}


@end
