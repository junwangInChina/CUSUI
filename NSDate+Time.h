//
//  NSDate+Time.h
//  CUSUI
//
//  Created by wangjun on 14-10-10.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Time)

/**
 *  获取日期控制器
 *
 *  @return 返回日期控制器
 */
+ (NSCalendar *)currentCalendar;

/**
 *  获取Identifier
 *
 *  @return 返回Identifier
 */
+ (NSString *)defauleCalendarIdentifier;

/**
 *  设置Identifier
 *
 *  @param identifier 需要设置的Identifier
 */
+ (void)setDefaultCalendarIdentifier:(NSString *)identifier;

#pragma mark - 获取各种日期
/**
 *  获取当前时间，的日期
 *
 *  @return 返回当前时间，的日期 (日期格式)
 */
+ (NSDate *)dateNow;

/**
 *  获取当前时间，UTC时间，的日期
 *
 *  @return 返回当前时间，UTC时间，的日期 (日期格式)
 */
+ (NSDate *)dateNowUTC;

/**
 *  获取当前时间，后一天的日期
 *
 *  @return 返回当前时间，后一天的日期 (日期格式)
 */
+ (NSDate *)dateTomorrow;

/**
 *  获取当前时间，UTC时间，后一天的日期
 *
 *  @return 返回当前时间，UTC时间，后一天的日期 (日期格式)
 */
+ (NSDate *)dateTomorrowUTC;

/**
 *  获取某个时间，后一天的日期
 *
 *  @param date 用户传入的某个时间
 *
 *  @return 返回某个时间时间，后一天的日期 (日期格式)
 */
+ (NSDate *)dateTomorrowWithDate:(NSDate *)date;

/**
 *  获取某个时间，UTC时间，后一天的日期
 *
 *  @param date 用户传入的某个时间
 *
 *  @return 返回某个时间，UTC时间，后一天的日期 (日期格式)
 */
+ (NSDate *)dateTomorrowUTCWithDate:(NSDate *)date;

/**
 *  获取当前时间，前一天的日期
 *
 *  @return 返回当前时间，前一天的日期 (日期格式)
 */
+ (NSDate *)dateYesterday;

/**
 *  获取当前时间，UTC时间，前一天的日期
 *
 *  @return 返回当前时间，UTC时间，前一天的日期 (日期格式)
 */
+ (NSDate *)dateYesterdayUTC;

/**
 *  获取某个时间，前一天的日期
 *
 *  @param date 用户传入的某个时间
 *
 *  @return 返回某个时间时间，前一天的日期 (日期格式)
 */
+ (NSDate *)dateYesterdayWithDate:(NSDate *)date;

/**
 *  获取某个时间，UTC时间，前一天的日期
 *
 *  @param date 用户传入的某个时间
 *
 *  @return 返回某个时间，UTC时间，前一天的日期 (日期格式)
 */
+ (NSDate *)dateYesterdayUTCWithDate:(NSDate *)date;

/**
 *  获取当前时间，后几天的日期
 *
 *  @param days 后几天
 *
 *  @return 返回当前时间，后几天的日期 (日期格式)
 */
+ (NSDate *)dateWithDaysAfterNow:(NSInteger)days;

/**
 *  获取当前时间，UTC时间，后几天的日期
 *
 *  @param days 后几天
 *
 *  @return 返回当前时间，UTC时间，后几天的日期 (日期格式)
 */
+ (NSDate *)dateWithDaysAfterNowUTC:(NSInteger)days;

/**
 *  获取某个时间，后几天的日期
 *
 *  @param date 用户传入的某个时间
 *  @param days 后几天
 *
 *  @return 返回某个时间，后几天的日期 (日期格式)
 */
+ (NSDate *)dateWithDaysAfterDate:(NSDate *)date days:(NSInteger)days;

/**
 *  获取某个时间，UTC时间，后几天的日期
 *
 *  @param date 用户传入的某个时间
 *  @param days 后几天
 *
 *  @return 返回某个时间，UTC时间，后几天的日期 (日期格式)
 */
+ (NSDate *)dateWithDaysAfterDateUTC:(NSDate *)date days:(NSInteger)days;

/**
 *  获取当前时间，前几天的日期
 *
 *  @param days 前几天
 *
 *  @return 返回当前时间，前几天的日期 (日期格式)
 */
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days;

/**
 *  获取当前时间，UTC时间，前几天的日期
 *
 *  @param days 前几天
 *
 *  @return 返回当前时间，UTC时间，前几天的日期 (日期格式)
 */
+ (NSDate *)dateWithDaysBeforeNowUTC:(NSInteger)days;

/**
 *  获取某个时间，前几天的日期
 *
 *  @param date 用户传入的某个时间
 *  @param days 前几天
 *
 *  @return 返回某个时间，前几天的日期 (日期格式)
 */
+ (NSDate *)dateWithDaysBeforeDate:(NSDate *)date days:(NSInteger)days;

/**
 *  获取当前时间，UTC时间，前几天的日期
 *
 *  @param date 用户传入的某个时间
 *  @param days 前几天
 *
 *  @return 返回某个时间，UTC时间，前几天的日期 (日期格式)
 */
+ (NSDate *)dateWithDaysBeforeDateUTC:(NSDate *)date days:(NSInteger)days;

/**
 *  获取当前时间，几小时之后的日期
 *
 *  @param hours 几小时
 *
 *  @return 返回当前时间，几小时之后的日期 (日期格式)
 */
+ (NSDate *)dateWithHoursAfterNow:(NSInteger)hours;

/**
 *  获取当前时间，UTC时间，几小时之后的日期
 *
 *  @param hours 几小时
 *
 *  @return 返回当前时间，UTC时间，几小时之后的日期 (日期格式)
 */
+ (NSDate *)dateWithHoursAfterNowUTC:(NSInteger)hours;

/**
 *  获取某个时间，几小时之后的日期
 *
 *  @param date  用户输入的某个时间
 *  @param hours 几小时
 *
 *  @return 返回某个时间，几小时之后的日期 (日期格式)
 */
+ (NSDate *)dateWithHoursAfterDate:(NSDate *)date hours:(NSInteger)hours;

/**
 *  获取某个时间，UTC时间，几小时之后的日期
 *
 *  @param date  用户输入的某个时间
 *  @param hours 几小时
 *
 *  @return 返回某个时间，UTC时间，几小时之后的日期 (日期格式)
 */
+ (NSDate *)dateWithHoursAfterDateUTC:(NSDate *)date hours:(NSInteger)hours;

/**
 *  获取当前时间，几小时之前的日期
 *
 *  @param hours 几小时
 *
 *  @return 返回当前时间，几小时之前的日期 (日期格式)
 */
+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)hours;

/**
 *  获取当前时间，UTC时间，几小时之前的日期
 *
 *  @param hours 几小时
 *
 *  @return 返回当前时间，UTC时间，几小时之前的日期 (日期格式)
 */
+ (NSDate *)dateWithHoursBeforeNowUTC:(NSInteger)hours;

/**
 *  获取某个时间，几小时之前的日期
 *
 *  @param date  用户输入的某个时间
 *  @param hours 几小时
 *
 *  @return 返回某个时间，几小时之前的日期 (日期格式)
 */
+ (NSDate *)dateWithHoursBeforeDate:(NSDate *)date hours:(NSInteger)hours;

/**
 *  获取某个时间，UTC时间，几小时之前的日期
 *
 *  @param date  用户输入的某个时间
 *  @param hours 几小时
 *
 *  @return 返回某个时间，UTC时间，几小时之前的日期 (日期格式)
 */
+ (NSDate *)dateWithHoursBeforeDateUTC:(NSDate *)date hours:(NSInteger)hours;

/**
 *  获取当前时间，几分钟之后的日期
 *
 *  @param minutes 几分钟
 *
 *  @return 返回当前时间，几小时之后的日期 (日期格式)
 */
+ (NSDate *)dateWithMinutesAfterNow:(NSInteger)minutes;

/**
 *  获取当前时间，UTC时间，几分钟之后的日期
 *
 *  @param minutes 几分钟
 *
 *  @return 返回当前时间，UTC时间，几小时之后的日期 (日期格式)
 */
+ (NSDate *)dateWithMinutesAfterNowUTC:(NSInteger)minutes;

/**
 *  获取某个时间，几分钟之后的日期
 *
 *  @param date    用户输入的某个时间
 *  @param minutes 几分钟
 *
 *  @return 返回某个时间，几小时之后的日期 (日期格式)
 */
+ (NSDate *)dateWithMinutesAfterDate:(NSDate *)date minutes:(NSInteger)minutes;

/**
 *  获取某个时间，UTC时间，几分钟之后的日期
 *
 *  @param date    用户输入的某个时间
 *  @param minutes 几分钟
 *
 *  @return 返回某个时间，UTC时间，几小时之后的日期 (日期格式)
 */
+ (NSDate *)dateWithMinutesAfterDateUTC:(NSDate *)date minutes:(NSInteger)minutes;

/**
 *  获取当前时间，几分钟之前的日期
 *
 *  @param minutes 几分钟
 *
 *  @return 返回当前时间，几小时之前的日期 (日期格式)
 */
+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)minutes;

/**
 *  获取当前时间，UTC时间，几分钟之前的日期
 *
 *  @param minutes 几分钟
 *
 *  @return 返回当前时间，UTC时间，几小时之前的日期 (日期格式)
 */
+ (NSDate *)dateWithMinutesBeforeNowUTC:(NSInteger)minutes;

/**
 *  获取某个时间，几分钟之前的日期
 *
 *  @param date    用户输入的某个时间
 *  @param minutes 几分钟
 *
 *  @return 返回某个时间，几小时之前的日期 (日期格式)
 */
+ (NSDate *)dateWithMinutesBeforeDate:(NSDate *)date minutes:(NSInteger)minutes;

/**
 *  获取某个时间，UTC时间，几分钟之前的日期
 *
 *  @param date    用户输入的某个时间
 *  @param minutes 几分钟
 *
 *  @return 返回某个时间，UTC时间，几小时之前的日期 (日期格式)
 */
+ (NSDate *)dateWithMinutesBeforeDateUTC:(NSDate *)date minutes:(NSInteger)minutes;

/**
 *  获取传入时间，加上时间差，之后的时间，毫秒级 (会处理)
 *
 *  @param date    原始时间
 *  @param seconds 传入的时间
 *
 *  @return 计算后的时间，毫秒级
 */
+ (NSTimeInterval)querytimeIntervalSinceDate:(NSDate *)date time:(NSInteger)seconds;

/**
 *  获取当前时间，加上传入的时间差，之后的时间，毫秒级 (会处理)
 *
 *  @param seconds 传入的时间
 *
 *  @return 计算后的时间，毫秒级
 */
+ (NSTimeInterval)querySinceReferenceTime:(NSInteger)seconds;

/**
 *  获取传入时间的UTC时间
 *
 *  @param date 传入的时间
 *
 *  @return 返回处理后的UTC时间 (日期格式)
 */
+ (NSDate *)queryUTCDateFormatAnyDate:(NSDate *)date;

#pragma mark - NSDate Conversion NSString && NSString Conversion NSDate

/**
 *  将当前日期，转换成字符串输出，默认转换格式 yyyy-MM-dd hh:mm:ss (PS: 转换过程会自动转换UTC时间，所以传进来的值需要是非UTC时间)
 *
 *  @return 返回转换后的字符串
 */
+ (NSString *)stringWithNow;

/**
 *  将一个日期，转换成字符串输出，默认转换格式 yyyy-MM-dd hh:mm:ss
 *
 *  @param date 需要转换的日期 (PS: 转换过程会自动转换UTC时间，所以传进来的值需要是非UTC时间)
 *
 *  @return 返回转换后的字符串
 */
+ (NSString *)stringWithDate:(NSDate *)date;

/**
 *  将当前日期，转换成字符串输出，可自由控制转换格式 (PS: 转换过程会自动转换UTC时间，所以传进来的值需要是非UTC时间)
 *
 *  @param type 需要转换的格式
 *
 *  @return 返回转换后的字符串
 */
+ (NSString *)stringWithNow:(NSString *)type;

/**
 *  将一个日期，转换成字符串输出，可自由控制转换格式
 *
 *  @param date 需要转换的日期 (PS: 转换过程会自动转换UTC时间，所以传进来的值需要是非UTC时间)
 *  @param type 需要转换的格式
 *
 *  @return 返回转换后的字符串
 */
+ (NSString *)stringWithDate:(NSDate *)date type:(NSString *)type;

/**
 *  将当前日期转换为英文的格式输出 May 12,2014 (PS: 转换过程会自动转换UTC时间，所以传进来的值需要是非UTC时间)
 *
 *  @return 返回转换后的英文格式字符串
 */
+ (NSString *)stringWithNowEnglist;

/**
 *  将日期转换为英文的格式输出 May 12,2014
 *
 *  @param date 需要转换的日期 (PS: 转换过程会自动转换UTC时间，所以传进来的值需要是非UTC时间)
 *
 *  @return 转换后的英文格式字符串
 */
+ (NSString *)stringWithEnglistDate:(NSDate *)date;

/**
 *  将一个UTC日期，转换成字符串输出，默认转换格式 yyyy-MM-dd hh:mm:ss Z
 *
 *  @param date 需要转换的UTC日期 (PS: UTC转换只适用与转换UTC时间)
 *
 *  @return 返回转换后的字符串
 */
+ (NSString *)stringWithDateUTC:(NSDate *)date;

/**
 *  将一个UTC日期，转换成字符串输出，可自由控制转换格式
 *
 *  @param date 需要转换的UTC日期 (PS: UTC转换只适用与转换UTC时间)
 *  @param type 需要转换的格式
 *
 *  @return 返回转换后的字符串
 */
+ (NSString *)stringWithDateUTC:(NSDate *)date type:(NSString *)type;

/**
 *  获取日期转换器，需要转换类型
 *
 *  @param type 转换类型
 *
 *  @return 返回日期转换器
 */
+ (NSDateFormatter *)queryDateFormatter:(NSString *)type;

/**
 *  获取日期转换器，需要转换类型，UTC
 *
 *  @param type 转换类型
 *
 *  @return 返回日期转换器
 */
+ (NSDateFormatter *)queryDateFormatterUTC:(NSString *)type;

/**
 *  获取日期转换器，需要转换类型，Englist
 *
 *  @param type 转换类型
 *
 *  @return 返回日期转换器
 */
+ (NSDateFormatter *)queryDateFormatterEnglist:(NSString *)type;

#pragma mark - 判断

/**
 *  判断某个日期，与今天是否是同一天。(需要对比年、月、日)
 *
 *  @param date 需要对比的天
 *
 *  @return 返回是否是同一天
 */
+ (BOOL)isToday:(NSDate *)date;

/**
 *  判断某两个日期，是否是同一天。(需要对比年、月、日)
 *
 *  @param date        第一个日期
 *  @param anotherDate 另一个日期
 *
 *  @return 返回是否是同一天
 */
+ (BOOL)isToday:(NSDate *)date another:(NSDate *)anotherDate;

/**
 *  判断方法，判断两个日期是否是同一天 (需要对比年、月、日)
 *
 *  @param date      第一个日期
 *  @param otherDate 第二个日期
 *
 *  @return 返回是否是同一天
 */
+ (BOOL)isSameDay:(NSDate *)date other:(NSDate *)otherDate;

/**
 *  判断某个日期，与今天的日期比较，是否是属于这个星期。(对比年、月、星期)
 *
 *  @param date 传入的某个日期
 *
 *  @return 返回某个日期，与今天的日期比较，是否属于这个星期
 */
+ (BOOL)isThisWeek:(NSDate *)date;

/**
 *  判断两个日期，是否属于同一个星期。(对比年、月、星期)
 *
 *  @param date        第一个日期
 *  @param anotherDate 第二个日期
 *
 *  @return 返回这两个日期，是否是同一个星期
 */
+ (BOOL)isThisWeek:(NSDate *)date another:(NSDate *)anotherDate;

/**
 *  判断某个日期，与今天的日期比较，是否属于上一个星期。(对比年、月、星期)
 *
 *  @param date 需要判断的日期
 *
 *  @return 返回需要判断的日期，与今天的日期比较，是否为上一个星期
 */
+ (BOOL)isLastWeek:(NSDate *)date;

/**
 *  判断两个日期，后面一个日期对于前面一个日期来说，是否属于前一个星期。(对比年、月、星期)
 *
 *  @param date        第一个日期
 *  @param anotherDate 第二个日期
 *
 *  @return 返回后面一个日期对于前面一个日期来说，是否属于前一个星期。
 */
+ (BOOL)isLastWeek:(NSDate *)date another:(NSDate *)anotherDate;

/**
 *  判断某个日期，与今天的日期比较，是否属于下一个星期。(对比年、月、星期)
 *
 *  @param date 需要判断的日期
 *
 *  @return 返回需要判断的日期，与今天的日期比较，是否为下一个星期
 */
+ (BOOL)isNextWeek:(NSDate *)date;

/**
 *  判断两个日期，后面一个日期对于前面一个日期来说，是否属于下一个星期。(对比年、月、星期)
 *
 *  @param date        第一个日期
 *  @param anotherWeek 第二个日期
 *
 *  @return 返回后面一个日期对于前面一个日期来说，是否属于下一个星期。
 */
+ (BOOL)isNextWeek:(NSDate *)date another:(NSDate *)anotherWeek;

/**
 *  判断两个日期，是否属于同一个星期。(对比年、月、星期)
 *
 *  @param date      第一个日期
 *  @param otherDate 第二个日期
 *
 *  @return 返回这两个日期，是否是同一个星期
 */
+ (BOOL)isSameWeek:(NSDate *)date other:(NSDate *)otherDate;

/**
 *  判断某个日期，与今天的日期比较，是否属于同一个月。(对比年、月)
 *
 *  @param date 需要判断的日期
 *
 *  @return 返回需要判断的日期，与今天的日期比较，是否属于同一个月
 */
+ (BOOL)isThisMonth:(NSDate *)date;

/**
 *  两个日期比较，是否属于同一个月。(对比年、月)
 *
 *  @param date        第一个日期
 *  @param anotherDate 第二个日期
 *
 *  @return 返回两个日期比较，是否属于同一个月
 */
+ (BOOL)isThisMonth:(NSDate *)date another:(NSDate *)anotherDate;

/**
 *  判断某个日期，与今天的日期比较，是否属于上一个月。(对比年、月)
 *
 *  @param date 需要判断的日期
 *
 *  @return 返回需要判断的日期，与今天的日期比较，是否为上一个月
 */
+ (BOOL)isLastMonth:(NSDate *)date;

/**
 *  判断两个日期，后面一个日期对于前面一个日期来说，是否属于前一个月。(对比年、月)
 *
 *  @param date        第一个日期
 *  @param anotherDate 第二个日期
 *
 *  @return 返回后面一个日期对于前面一个日期来说，是否属于前一个月。
 */
+ (BOOL)isLastMonth:(NSDate *)date another:(NSDate *)anotherDate;

/**
 *  判断某个日期，与今天的日期比较，是否属于下一个月。(对比年、月)
 *
 *  @param date 需要判断的日期
 *
 *  @return 返回需要判断的日期，与今天的日期比较，是否为下一个月
 */
+ (BOOL)isNextMonth:(NSDate *)date;

/**
 *  判断两个日期，后面一个日期对于前面一个日期来说，是否属于下一个月。(对比年、月)
 *
 *  @param date        第一个日期
 *  @param anotherDate 第二个日期
 *
 *  @return 返回后面一个日期对于前面一个日期来说，是否属于下一个月。
 */
+ (BOOL)isNextMonth:(NSDate *)date another:(NSDate *)anotherDate;

/**
 *  判断某个日期，与今天的日期比较，是否属于同一年。(对比年)
 *
 *  @param date 需要判断的日期
 *
 *  @return 返回需要判断的日期，与今天的日期比较，是否属于同一年
 */
+ (BOOL)isThisYear:(NSDate *)date;

/**
 *  两个日期比较，是否属于同一年。(对比年)
 *
 *  @param date        第一个日期
 *  @param anotherDate 第二个日期
 *
 *  @return 返回两个日期比较，是否属于同一年
 */
+ (BOOL)isThisYear:(NSDate *)date another:(NSDate *)anotherDate;

/**
 *  判断某个日期，与今天的日期比较，是否属于上一年。(对比年)
 *
 *  @param date 需要判断的日期
 *
 *  @return 返回需要判断的日期，与今天的日期比较，是否为上一年
 */
+ (BOOL)isLastYear:(NSDate *)date;

/**
 *  判断两个日期，后面一个日期对于前面一个日期来说，是否属于前一年。(对比年)
 *
 *  @param date        第一个日期
 *  @param anotherDate 第二个日期
 *
 *  @return 返回后面一个日期对于前面一个日期来说，是否属于前一年
 */
+ (BOOL)isLastYear:(NSDate *)date another:(NSDate *)anotherDate;

/**
 *  判断某个日期，与今天的日期比较，是否属于下一年。(对比年)
 *
 *  @param date 需要判断的日期
 *
 *  @return 返回需要判断的日期，与今天的日期比较，是否为下一年
 */
+ (BOOL)isNextYear:(NSDate *)date;

/**
 *  判断两个日期，后面一个日期对于前面一个日期来说，是否属于下一年。(对比年)
 *
 *  @param date        第一个日期
 *  @param anotherDate 第二个日期
 *
 *  @return 返回后面一个日期对于前面一个日期来说，是否属于下一年。
 */
+ (BOOL)isNextYear:(NSDate *)date another:(NSDate *)anotherDate;

/**
 *  判断当前日期，是否正好是周末
 *
 *  @return 返回当前日期，是否是周末
 */
+ (BOOL)isTypicallyWeekend;

/**
 *  判断某个日期，是否是周末
 *
 *  @param date 需要判断的某个日期
 *
 *  @return 返回需要判断的某个日期，是否是周末
 */
+ (BOOL)isTypicallyWeekend:(NSDate *)date;

/**
 *  判断当前日期，是否是工作日
 *
 *  @return 返回当前日期，是否是工作日
 */
+ (BOOL)isTypicallyWorkday;

/**
 *  判断某个日期，是否是工作日
 *
 *  @param date 需要判断的某个日期
 *
 *  @return 返回需要判断的某个日期，是否是工作日
 */
+ (BOOL)isTypicallyWorkday:(NSDate *)date;

#pragma mark - Year、Month、Day ...

/**
 *  获取当前日期中的年份
 *
 *  @return 返回当前日期中，的年份
 */
+ (NSInteger)years;

/**
 *  获取某个日期中的年份
 *
 *  @param date 需要获取年份的日期
 *
 *  @return 返回需要获取年份的日期，的年份
 */
+ (NSInteger)yearsWithDate:(NSDate *)date;

/**
 *  获取当前日期中的月份
 *
 *  @return 返回当前日期中，的月份
 */
+ (NSInteger)months;

/**
 *  获取当前日期中的月份，以英文输出
 *
 *  @return 返回当前日期中的月份，以英文输出
 */
+ (NSString *)monthsInEnglish;

/**
 *  获取当前日期中的月份，以英文短语文输出 (Mar、Oct)  (PS: 正规的英语中六月，七月，九月的缩写是4个字母，其他月份3个字母。挂历上见到的Jun，Jul,Sep是错误的)
 *
 *  @return 返回当前日期中的月份，以英文短语输出
 */
+ (NSString *)monthsInEnglishShort;

/**
 *  获取某个日期中的月份
 *
 *  @param date 需要获取月份的日期
 *
 *  @return 返返回需要获取月份的日期，的月份值
 */
+ (NSInteger)monthsWithDate:(NSDate *)date;

/**
 *  获取某个日期中的月份，以英文输出
 *
 *  @param date 需要获取月份的日期
 *
 *  @return 返回需要获取月份的日期，的月份值，以英文输出
 */
+ (NSString *)monthsInEnglishWithDate:(NSDate *)date;

/**
 *  获取某个日期中的月份，以英文短语输出 (PS: 正规的英语中六月，七月，九月的缩写是4个字母，其他月份3个字母。挂历上见到的Jun，Jul,Sep是错误的)
 *
 *  @param date 需要获取月份的日期
 *
 *  @return 返回需要获取月份的日期，的月份值，以英文短语输出
 */
+ (NSString *)monthsInEnglishShortWithDate:(NSDate *)date;

/**
 *  获取当前日期中的，天数
 *
 *  @return 返回当前日期中的，天数
 */
+ (NSInteger)days;

/**
 *  获取某个日期中的，天数
 *
 *  @param date 需要获取天数的日期
 *
 *  @return 返回需要获取天数的日期，的天数
 */
+ (NSInteger)daysWithDate:(NSDate *)date;

/**
 *  获取当前日期中的，小时
 *
 *  @return 返回当前日期中的，小时
 */
+ (NSInteger)hours;

/**
 *  获取某个日期中的，小时
 *
 *  @param date 需要获取小时的日期
 *
 *  @return 返回需要获取天数的日期，的小时
 */
+ (NSInteger)hoursWithDate:(NSDate *)date;

/**
 *  获取当前日期中的，分钟
 *
 *  @return 返回当前日期中的，分钟
 */
+ (NSInteger)minutes;

/**
 *  获取某个日期中的，分钟
 *
 *  @param date 需要获取分钟的日期
 *
 *  @return 返回需要获取天数的日期，的分钟
 */
+ (NSInteger)minutesWithDate:(NSDate *)date;

/**
 *  获取当前日期中的，秒钟
 *
 *  @return 返回当前日期中的，秒钟
 */
+ (NSInteger)seconds;

/**
 *  获取某个日期中的，秒钟
 *
 *  @param date 需要获取秒钟的日期
 *
 *  @return 返回需要获取天数的日期，的秒钟
 */
+ (NSInteger)secondsWithDate:(NSDate *)date;

@end
