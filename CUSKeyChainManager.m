//
//  CUSKeyChainManager.m
//  CUSUI
//
//  Created by wangjun on 14-7-4.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSKeyChainManager.h"
#import <Security/Security.h>

@implementation CUSKeyChainManager

+ (CUSKeyChainManager *)sharedInstance
{
    static dispatch_once_t pred;
    static CUSKeyChainManager *keyChainManager = nil;
    dispatch_once(&pred, ^{
        
        keyChainManager = [[CUSKeyChainManager alloc] init];
        
    });
    return keyChainManager;
}

- (void)saveKeyChainWithKey:(NSString *)key value:(NSString *)value
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:key];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:(__bridge id)kSecValueData];
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

- (void)deleteKeyChainWithKey:(NSString *)key
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:key];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

- (NSString *)getKeyChainWithKey:(NSString *)key
{
    NSString* ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:key];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr)
    {
        @try
        {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *e)
        {
            NSLog(@"class%@ key:%@",NSStringFromClass([self class]),key);
            NSLog(@"class%@ Exception:%@",NSStringFromClass([self class]),e);
        }
        @finally
        {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

- (BOOL)hasKeyChainWithKey:(NSString *)key
{
    return [self getKeyChainWithKey:key] ? YES : NO;
}

- (NSMutableDictionary *)getKeyChainQuery:(NSString *)service
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}


@end
