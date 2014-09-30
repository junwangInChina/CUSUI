//
//  CUSKeyChainManager.h
//  CUSUI
//
//  Created by wangjun on 14-7-4.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  KeyChain简单管理
 *  支持保持用户设定的Key、Value
 *  支持获取当前UUID，保持下来，当做UDID使用
 *  支持通过Key查询
 *  支持删除
 */

#import <Foundation/Foundation.h>

@interface CUSKeyChainManager : NSObject

/**
 *  单例模式，获取当前KeyChain管理类
 *
 *  @param  无
 *  @return 当前KeyChain管理单例
 *
 */
+ (CUSKeyChainManager *)sharedInstance;

/**
 *  保存
 *
 *  @param  key   :存储的Key
 *  @param  value :存储的Value
 *  @return 无
 *
 */
- (void)saveKeyChainWithKey:(NSString *)key value:(NSString *)value;

/**
 *  删除
 *
 *  @param  key   :通过此Key，删除
 *  @return 无
 *
 */
- (void)deleteKeyChainWithKey:(NSString *)key;

/**
 *  查询具体值
 *
 *  @param  key   :通过此Key，查询对应的Value
 *  @return 无
 *
 */
- (NSString *)getKeyChainWithKey:(NSString *)key;

/**
 *  查询是否保存
 *
 *  @param  key   :通过此Key，查询是否有保存对应的值
 *  @return 无
 *
 */
- (BOOL)hasKeyChainWithKey:(NSString *)key;

@end
