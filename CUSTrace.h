//
//  CUSTrace.h
//  CUSUI
//
//  Created by wangjun on 14-8-11.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

/**
 *  定制的一款日志打印工具
 *  主要功能有控制日志的打印、日志文件输出、crash捕获
 *
 *  使用方式，首先需要设置是否输出到控制台、是否输出到文件、输出打印级别、以及是否捕获异常
 *  [[CUSTrace shareInstance] setOutputConsole:YES];
 *  [[CUSTrace shareInstance] setOutputFile:YES];
 *  [[CUSTrace shareInstance] setOutputLevel:OutputLevelALL];
 *  [[CUSTrace shareInstance] setCatchUncatchedException:YES];
 *  实际打印时，使用定义好的宏即可
 *  CUSOUTPUT_LOG(OutputLevelALL,@"hello");
 */

#import <Foundation/Foundation.h>

#define CUSOUTPUT_LOG(level,text) outputLog((level), __func__, __LINE__, (text))

typedef NS_ENUM(NSInteger, OutputLevel)
{
    OutputLevelCritical,        // 关键级别，打印至关重要的信息
    OutputLevelError,           // 错误级别，打印错误
    OutputLevelWarn,            // 警告级别，打印潜在错误信息
    OutputLevelInfo,            // 信息级别，用于发布情况下分析问题，打印重要的信息和跳转
    OutputLevelDebug,           // 调试级别，用于程序调试，可以打印函数的入口，分支的跳转等
    OutputLevelALL              // 打印所以日志信息
};

@interface CUSTrace : NSObject

/**
 *  单例模式
 *
 *  @return 获取当前对象
 */
+ (CUSTrace *)shareInstance;

/**
 *  是否输出日志到控制台
 */
@property (nonatomic, assign) BOOL outputConsole;

/**
 *  是否输出日志到日志文件
 */
@property (nonatomic, assign) BOOL outputFile;

/**
 *  日志打印输出级别
 */
@property (nonatomic, assign) OutputLevel outputLevel;

/**
 *  是否捕获异常
 */
@property (nonatomic, assign) BOOL catchUncatchedException;

/**
 *  打印语句
 *
 *  @param logLevel 此次打印级别
 *  @param file     文件
 *  @param line     行数
 *  @param function 方法名
 *  @param format   打印内容
 *  @param ...      其他
 */
void outputLog(OutputLevel logLevel,
               const char *function,
               NSInteger line,
               NSString *format, ...);

@end
