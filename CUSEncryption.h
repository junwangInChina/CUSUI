//
//  CUSEncryption.h
//  CUSUI
//
//  Created by wangjun on 14-9-18.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  定制的一款加密管理类
 *  提供了MD5、SHA、Base64、AES几种主流的加密方式
 */

#import <Foundation/Foundation.h>

@interface CUSEncryption : NSObject

/**
 *  类方法，单例模式创建加密管理类
 *
 *  @return 返回加密管理类
 */
+ (CUSEncryption *)shareEncrytion;

#pragma mark - MD5
/**
 *  MD5转码，将String字符串进行MD5转码
 *
 *  @param string 需要转码的字符串
 *
 *  @return 转码后的字符串
 */
- (NSString *)md5HashEncodeString:(NSString *)string;

/**
 *  MD5转码，将NSData进行MD5转码
 *
 *  @param data 需要转码的Data
 *
 *  @return 转码后的字符串
 */
- (NSString *)md5HashEncodeData:(NSData *)data;

#pragma mark - SHA
/**
 *  SHA1 加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
- (NSString *)sha1EncodeString:(NSString *)string;

/**
 *  SHA256加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
- (NSString *)sha256EncodeString:(NSString *)string;

/**
 *  SHA384加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 机密后的字符串
 */
- (NSString *)sha384EncodeString:(NSString *)string;

/**
 *  SHA512加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
- (NSString *)sha512EncodeString:(NSString *)string;

#pragma mark - Base64
/**
 *  Base64加密，将NSData数据，加密成一个字符串
 *
 *  @param data 需要加密的NSData数据
 *
 *  @return 返回加密后的字符串
 */
- (NSString *)base64EncodeData:(NSData *)data;

/**
 *  Base64解密，将由NSData数据加密成的字符串，解密成NSData
 *
 *  @param string 由NSData数据，经过Base64加密后的字符串
 *
 *  @return 解密好的NSData数据
 */
- (NSData *)base64DecodeDate:(NSString *)string;

/**
 *  Base64加密，将NSString数据，加密成一个字符串
 *
 *  @param string 需要加密的NSString数据
 *
 *  @return 返回加密后的字符串
 */
- (NSString *)base64EncodeString:(NSString *)string;

/**
 *  Base64解密，将由NSString数据加密成的字符串，解密成NSString
 *
 *  @param string 由NSString数据，经过Base64加密后的字符串
 *
 *  @return 解密好的字符串
 */
- (NSString *)base64DecodeString:(NSString *)string;

#pragma mark - AES

/**
 *  AES128 加密
 *
 *  @param data 需要加密的数据
 *  @param key  加密密钥
 *  @param iv   初始化向量，AES128需要，AES256不需要
 *
 *  @return 返回加密后的数据
 */
- (NSData *)aes128Encode:(NSData *)data key:(NSString *)key iv:(NSString *)iv;

/**
 *  AES128 解密
 *
 *  @param data 需要解密的数据
 *  @param key  解密密钥
 *  @param iv   初始化向量，AES128需要，AES256不需要
 *
 *  @return 返回解密好的数据
 */
- (NSData *)aes128Decode:(NSData *)data key:(NSString *)key iv:(NSString *)iv;

/**
 *  AES256 加密
 *
 *  @param data 需要加密的数据
 *  @param key  加密密钥
 *
 *  @return 返回加密好的数据
 */
- (NSData *)aes256Encode:(NSData *)data key:(NSString *)key;

/**
 *  AES256 解密
 *
 *  @param data 需要解密的数据
 *  @param key  解密密钥
 *
 *  @return 返回解密好的数据
 */
- (NSData *)aes256Decode:(NSData *)data key:(NSString *)key;

@end
