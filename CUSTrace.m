//
//  CUSTrace.m
//  CUSUI
//
//  Created by wangjun on 14-8-11.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSTrace.h"
#include <execinfo.h>

static NSString *logDirectoryName = @"AppOutput";
static NSString *logFileName = @"runLog.txt";
static CUSTrace *sharedCUSTrace = nil;

@interface CUSTrace()

/**
 *  通过设定的打印级别与此次打印级别，判断打印权限
 *
 *  @param level 此次打印的基本
 *
 *  @return 返回此次能否打印
 */
bool outputPower(OutputLevel level);

/**
 *  打印基本描述
 *
 *  @param level 需要描述的打印级别
 *
 *  @return 返回具体打印基本对应的打印基本描述
 */
NSString* outputLevelDesctibetion(OutputLevel level);

/**
 *  获取当前时间
 *
 *  @return 返回当前时间
 */
const char *getDate();

/**
 *  输出到文件
 *
 *  @param string 需要输出的内容
 */
void outputToFile(NSString *string);

/**
 *  获取当前输出日志信息的文件路径
 *
 *  @return 返回文件路径
 */
NSString *outputFilePath();

/**
 *  判断当前写入日志的文件是否已经准备好
 *
 *  @return 返回是否准备好
 */
bool outputFileAlready();

/**
 *  创建文件，存在则不创建
 *
 *  @return 返回是否创建成功
 */
bool createOutputFile();

/**
 *  创建文件目录
 *
 *  @return 返回是否创建成功
 */
bool createOutputDirectory();

/**
 *  开启监控，用户捕获crash
 */
void startObservaction();

/**
 *  设置捕获类型
 */
void setupUncaughtSignals();

/**
 *  捕获异常
 *
 *  @param exception 异常描述
 */
void handleUncaughtException(NSException *exception);

/**
 *  异常
 *
 *  @param sig
 *  @param info
 *  @param context
 */
void handleUncaughtSignal(int sig, siginfo_t *info, void *context);

/**
 *  生成crash文件
 *
 *  @param crash crash信息
 */
void outputCrashFile(NSMutableString *crash);

@end

@implementation CUSTrace
@synthesize outputConsole = _outputConsole;
@synthesize outputFile = _outputFile;
@synthesize outputLevel = _outputLevel;

+ (CUSTrace *)shareInstance
{
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedCUSTrace = [[CUSTrace alloc] init];
    });
    return sharedCUSTrace;
}

#pragma mark - Console Log
void outputLog(OutputLevel level,
               const char *function,
               NSInteger line,
               NSString *format, ...)
{
    va_list logList;
    va_start(logList, format);
    format = [format stringByAppendingString:@"\n"];
    NSString *inputString = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@",format] arguments:logList];
    va_end(logList);
    
    NSString *outputMessage = [NSString stringWithFormat:@"%s [%s] %s m:%ld %@",[outputLevelDesctibetion(level) UTF8String],getDate(),function,(long)line,inputString];
    
    if ([[CUSTrace shareInstance] outputConsole] &&
        (outputPower(level)))
    {
        // 打印到控制台
        fprintf(stderr, "%s",[outputMessage UTF8String]);
    }
    // 写入文件时，不需要判断设置的等级，全部写入
    if ([[CUSTrace shareInstance] outputFile])
    {
        // 输出到文件
        outputToFile(outputMessage);
    }
#if !__has_feature(objc_arc)
    [inputString release];
#endif
}

void outputToFile(NSString *string)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSString *filePath = outputFilePath();
        if (filePath.length > 0)
        {
            NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
            [handle truncateFileAtOffset:[handle seekToEndOfFile]];
            [handle writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
            [handle closeFile];
        }
    });
}

NSString *outputFilePath()
{
    if (outputFileAlready())
    {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
        NSString *logFilePath = [[documentPath stringByAppendingPathComponent:logDirectoryName] stringByAppendingPathComponent:logFileName];
        
        return logFilePath;
    }
    else
    {
        return @"";
    }
}

bool outputFileAlready()
{
    return createOutputFile();
}

bool createOutputFile()
{
    if (!createOutputDirectory()) return NO;
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSString *logFilePath = [[documentPath stringByAppendingPathComponent:logDirectoryName] stringByAppendingPathComponent:logFileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:logFilePath])
    {
        return [[NSData data] writeToFile:logFilePath atomically:YES];
    }
    else
    {
        return YES;
    }
}

bool createOutputDirectory()
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSString *logDirectoryPath = [documentPath stringByAppendingPathComponent:logDirectoryName];
    
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:logDirectoryPath])
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:logDirectoryPath
                                         withIntermediateDirectories:NO
                                                          attributes:nil
                                                               error:&error];
    }
    else
    {
        return YES;
    }
}

bool outputPower(OutputLevel level)
{
    switch ([[CUSTrace shareInstance] outputLevel])
    {
        case OutputLevelALL:
            return YES;
            break;
        case OutputLevelCritical:
        case OutputLevelError:
        case OutputLevelWarn:
        case OutputLevelInfo:
        case OutputLevelDebug:
            return ([[CUSTrace shareInstance] outputLevel] == level);
            break;
        default:
            return NO;
            break;
    }
}

NSString* outputLevelDesctibetion(OutputLevel level)
{
    switch (level) {
        case OutputLevelCritical:
            return @"CRITICAL";
            break;
        case OutputLevelError:
            return @"ERROR";
            break;
        case OutputLevelWarn:
            return @"WARN";
            break;
        case OutputLevelInfo:
            return @"INFO";
            break;
        case OutputLevelDebug:
            return @"DEBUG";
            break;
        case OutputLevelALL:
            return @"ALL";
            break;
        default:
            return @"DEBUG";
            break;
    }
}

const char *getDate()
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSString *timeStamp = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
    
    return [timeStamp UTF8String];
}

#pragma mark - Crash Log
- (void)setCatchUncatchedException:(BOOL)catchUncatchedException
{
    if (catchUncatchedException)
    {
        startObservation();
    }
}

void startObservation()
{
    NSSetUncaughtExceptionHandler(&handleUncaughtException);
    setupUncaughtSignals();
}

void setupUncaughtSignals()
{
	struct sigaction signalAction;
	signalAction.sa_sigaction = handleUncaughtSignal;
	signalAction.sa_flags = SA_SIGINFO;
	
	sigemptyset(&signalAction.sa_mask);
	sigaction(SIGQUIT, &signalAction, NULL);
	sigaction(SIGILL, &signalAction, NULL);
	sigaction(SIGTRAP, &signalAction, NULL);
	sigaction(SIGABRT, &signalAction, NULL);
	sigaction(SIGEMT, &signalAction, NULL);
	sigaction(SIGFPE, &signalAction, NULL);
	sigaction(SIGBUS, &signalAction, NULL);
	sigaction(SIGSEGV, &signalAction, NULL);
	sigaction(SIGSYS, &signalAction, NULL);
	sigaction(SIGPIPE, &signalAction, NULL);
	sigaction(SIGALRM, &signalAction, NULL);
	sigaction(SIGXCPU, &signalAction, NULL);
	sigaction(SIGXFSZ, &signalAction, NULL);
}

void handleUncaughtException(NSException *exception)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray *callStack = [exception callStackReturnAddresses];
        int i,len = [callStack count];
        void **frames = malloc(sizeof(void *)* len);
        
        for (i = 0; i < len; ++i) {
            frames[i] = (void *)[[callStack objectAtIndex:i] unsignedIntegerValue];
        }
        
        char **symbols = backtrace_symbols(frames,len);
        
        /* Now format into a message for sending to the user */
        
        NSMutableString *buffer = [[NSMutableString alloc] initWithCapacity:4096];
        
        NSBundle *bundle = [NSBundle mainBundle];
        [buffer appendFormat:@"%@ version %@ build %@\n\n",
         [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"],
         [bundle objectForInfoDictionaryKey:@"CFBundleVersion"],
         [bundle objectForInfoDictionaryKey:@"CIMBuildNumber"]];
        [buffer appendString:@"Uncaught Exception\n"];
        [buffer appendFormat:@"Exception Name: %@\n",[exception name]];
        [buffer appendFormat:@"Exception Reason: %@\n",[exception reason]];
        [buffer appendString:@"Stack trace:\n\n"];
        for (i = 0; i < len; ++i) {
            [buffer appendFormat:@"%4d - %s\n",i,symbols[i]];
        }
        
        outputCrashFile(buffer);
        
        free(frames);
        exit(0);
    });
}

void handleUncaughtSignal(int sig, siginfo_t *info, void *context)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        void *frames[128];
        int i,len = backtrace(frames, 128);
        char **symbols = backtrace_symbols(frames,len);
        
        /* Now format into a message for sending to the user */
        
        NSMutableString *buffer = [[NSMutableString alloc] initWithCapacity:4096];
        
        NSBundle *bundle = [NSBundle mainBundle];
        [buffer appendFormat:@"%@ version %@ build %@\n\n",
         [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"],
         [bundle objectForInfoDictionaryKey:@"CFBundleVersion"],
         [bundle objectForInfoDictionaryKey:@"CIMBuildNumber"]];
        [buffer appendString:@"Uncaught Signal\n"];
        [buffer appendFormat:@"si_signo    %d\n",info->si_signo];
        [buffer appendFormat:@"si_code     %d\n",info->si_code];
        [buffer appendFormat:@"si_value    %d\n",info->si_value];
        [buffer appendFormat:@"si_errno    %d\n",info->si_errno];
        [buffer appendFormat:@"si_addr     0x%08lX\n",info->si_addr];
        [buffer appendFormat:@"si_status   %d\n",info->si_status];
        [buffer appendString:@"Stack trace:\n\n"];
        for (i = 0; i < len; ++i) {
            [buffer appendFormat:@"%4d - %s\n",i,symbols[i]];
        }
        
        outputCrashFile(buffer);
        
        exit(0);
    });
}

/**
 *  生成crash文件
 *
 *  @param crash crash信息
 */
void outputCrashFile(NSMutableString *crash)
{
    if (!createOutputDirectory()) return;
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSString *crashName = [NSString stringWithFormat:@"%s.crash",getDate()];
    NSString *crashFilePath = [[documentPath stringByAppendingPathComponent:logDirectoryName] stringByAppendingPathComponent:crashName];
    NSData *crashData = [crash dataUsingEncoding:NSUTF8StringEncoding];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:crashFilePath])
    {
        [crashData writeToFile:crashFilePath atomically:YES];
    }
}

@end
