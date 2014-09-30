//
//  CUSEncryption.m
//  CUSUI
//
//  Created by wangjun on 14-9-18.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSEncryption.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation CUSEncryption

static const char base64Encoding[64] =
{
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

static const char base64Decoding[] =
{
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 99, 99, 99,
    99,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99,
    99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99
};

+ (CUSEncryption *)shareEncrytion
{
    static dispatch_once_t once;
    static CUSEncryption *encrytion = nil;
    dispatch_once(&once, ^{
        
        encrytion = [[CUSEncryption alloc] init];
        
    });
    return encrytion;
}

#pragma mark - MD5

- (NSString *)md5HashEncodeString:(NSString *)string
{
    // Create pointer to the string as UTF8
    const char *stringPtr = [string UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 bytes MD5 hash value, store in buffer
    CC_MD5(stringPtr, (CC_LONG)strlen(stringPtr), md5Buffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x",md5Buffer[i]];
    }
    
    return output;
}

- (NSString *)md5HashEncodeData:(NSData *)data
{
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
	// Create 16 byte MD5 hash value, store in buffer
    CC_MD5(data.bytes, (CC_LONG)data.length, md5Buffer);
    
	// Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x",md5Buffer[i]];
    }
    return output;
}

#pragma mark - SHA
- (NSString *)sha1EncodeString:(NSString *)string
{
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1 (data.bytes ,(CC_LONG)data.length ,digest);
    
    NSMutableString * result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for ( int i = 0 ; i < CC_SHA1_DIGEST_LENGTH ; i++)
    {
        [result appendFormat:@"%02x",digest[i]];
    }
    return result;
}

- (NSString *)sha256EncodeString:(NSString *)string
{
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes ,(CC_LONG)data.length ,digest);
    
    NSMutableString * result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for ( int i = 0 ; i < CC_SHA256_DIGEST_LENGTH ; i++)
    {
        [result appendFormat:@"%02x",digest[i]];
    }
    return result;
}

- (NSString *)sha384EncodeString:(NSString *)string
{
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    
    uint8_t digest[CC_SHA384_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes ,(CC_LONG)data.length ,digest);
    
    NSMutableString * result = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    
    for ( int i = 0 ; i < CC_SHA384_DIGEST_LENGTH ; i++)
    {
        [result appendFormat:@"%02x",digest[i]];
    }
    return result;
}

- (NSString *)sha512EncodeString:(NSString *)string
{
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes ,(CC_LONG)data.length ,digest);
    
    NSMutableString * result = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for ( int i = 0 ; i < CC_SHA512_DIGEST_LENGTH ; i++)
    {
        [result appendFormat:@"%02x",digest[i]];
    }
    return result;
}

#pragma mark - Base64

- (NSString *)base64EncodeData:(NSData *)data
{
    // 过滤nil
    if (data == nil) return nil;
    
    // 过滤空字符串
    NSUInteger dataLength = [data length];
    if (dataLength == 0) return @"";
    
    unsigned char input[3], output[4];
    const unsigned char *raw = [data bytes];
    NSMutableString *result = [[NSMutableString alloc] init];
    NSInteger pos = 0;
    while (pos < dataLength)
    {
        unsigned int read = 1;
        unsigned int write = 2;
        input[0] = raw[pos++];
        if (pos < dataLength)
        {
            input[1] = raw[pos++];
            read = 2;
            write = 3;
        }
        else
        {
            input[1] = 0;
        }
        if (pos < dataLength)
        {
            input[2] = raw[pos++];
            read = 3;
            write = 4;
        }
        else
        {
            input[2] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        
        for (int i = 0; i < write; i++)
        {
            [result appendString:[NSString stringWithFormat:@"%c",base64Encoding[output[i]]]];
        }
        switch (read)
        {
            case 1:
                [result appendString:@"=="];
                break;
            case 2:
                [result appendString:@"="];
                break;
            default:
                break;
        }
    }
#if !__has_feature(objc_arc)
    return [result autorelease];
#else
    return result;
#endif
}

- (NSData *)base64DecodeDate:(NSString *)string
{
    if (string == nil) return nil;
    
    NSUInteger slength = [string length];
    if (slength == 0)
    {
        return [[NSData alloc] init];
    }
    
    NSUInteger read;
    char c;
    unsigned char input[4], output[3];
    const char *raw = [string UTF8String];
    NSMutableData *data = [[NSMutableData alloc] init];
    unsigned int pos = 0;
    while (pos < slength)
    {
        input[0] = base64Decoding[raw[pos++]];
        input[1] = base64Decoding[raw[pos++]];
        c = raw[pos++];
        read = 1;
        if (c == '=')
        {
            input[2] = 0;
        }
        else
        {
            input[2] = base64Decoding[c];
            read = 2;
        }
        c = raw[pos++];
        if (c == '=')
        {
            input[3] = 0;
        }
        else
        {
            input[3] = base64Decoding[c];
            read = 3;
        }
        output[0] = ((input[0] << 2) & 0xFC) | ((input[1] >> 4) & 0x03);
        output[1] = ((input[1] << 4) & 0xF0) | ((input[2] >> 2) & 0x0F);
        output[2] = ((input[2] << 6) & 0xC0) | ((input[3] >> 0 & 0x3F));
        [data appendBytes:output length:read];
    }
    
#if !__has_feature(objc_arc)
    return [data autorelease];
#else
    return data;
#endif
}

- (NSString *)base64EncodeString:(NSString *)string
{
    if (string == nil) return nil;
    if (string.length == 0) return @"";
    const char *data = [string UTF8String];
    
    return [self base64EncodeData:[NSData dataWithBytes:data length:string.length]];
}

- (NSString *)base64DecodeString:(NSString *)string
{
    if (string == nil) return nil;
    if (string.length == 0) return @"";
    
    NSData *data = [self base64DecodeDate:string];
    NSString *decodeString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    
#if !__has_feature(objc_arc)
    return [decodeString autorelease];
#else
    return decodeString;
#endif
}

#pragma mark - AES

- (NSData *)aes128Encode:(NSData *)data key:(NSString *)key iv:(NSString *)iv
{
    return [self aes128Operation:kCCEncrypt data:data key:key iv:iv];
}

- (NSData *)aes128Decode:(NSData *)data key:(NSString *)key iv:(NSString *)iv
{
    return [self aes128Operation:kCCDecrypt data:data key:key iv:iv];
}

- (NSData *)aes128Operation:(CCOperation)operation data:(NSData *)data key:(NSString *)key iv:(NSString *)iv
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesCrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(operation,                // 加密/解密
                                          kCCAlgorithmAES128,       // 加密标准  aes des ...
                                          kCCOptionPKCS7Padding,    // 选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                                          keyPtr,                   // 密钥    加密和解密的密钥必须一致
                                          kCCBlockSizeAES128,       // 密钥的大小
                                          ivPtr,                    // 可选的初始矢量
                                          [data bytes],             // 被加密的数据
                                          dataLength,               // 被加密的数据的大小
                                          buffer,                   // 加密后的数据
                                          bufferSize,               // 加密后的数据大小
                                          &numBytesCrypted);        // 加密后数据长度
    if (cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytes:buffer length:numBytesCrypted];
    }
    free(buffer);
    return nil;
}

- (NSData *)aes256Encode:(NSData *)data key:(NSString *)key
{
    return [self aes256Operation:kCCEncrypt data:data key:key];
}

- (NSData *)aes256Decode:(NSData *)data key:(NSString *)key
{
    return [self aes256Operation:kCCDecrypt data:data key:key];
}

- (NSData *)aes256Operation:(CCOperation)operation data:(NSData *)data key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(operation,                // 加密/解密
                                          kCCAlgorithmAES128,       // 加密标准  aes des ...
                                          kCCOptionPKCS7Padding,    // 选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                                          keyPtr,                   // 密钥    加密和解密的密钥必须一致
                                          kCCKeySizeAES256,         // 密钥的大小
                                          NULL,                     // 可选的初始矢量
                                          [data bytes],             // 被加密的数据
                                          dataLength,               // 被加密的数据的大小
                                          buffer,                   // 加密后的数据
                                          bufferSize,               // 加密后的数据大小
                                          &numBytesEncrypted);      // 加密后数据长度
    if (cryptStatus == kCCSuccess)
    {
        return [NSMutableData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

@end
