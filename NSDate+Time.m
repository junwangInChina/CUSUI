//
//  NSDate+Time.m
//  CUSUI
//
//  Created by wangjun on 14-10-10.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "NSDate+Time.h"

static NSString *defaultCalendarIdentifier = nil;
static NSLock *defaultCalendarIdentifierLock = nil;
static dispatch_once_t defaultCalendarOnceToken;

static NSString *defaultCalendarKey = @"currentCalentar_key";

#define SECONDS_IN_MINUTE 60
#define MINUTES_IN_HOUR 60
#define DAYS_IN_WEEK 7
#define SECONDS_IN_HOUR (SECONDS_IN_MINUTE * MINUTES_IN_HOUR)
#define HOURS_IN_DAY 24
#define SECONDS_IN_DAY (HOURS_IN_DAY * SECONDS_IN_HOUR)

#define DEFAULT_CONVERSION_TYPE             @"yyyy-MM-dd HH:mm:ss"
#define DEFAULT_CONVERSION_TYPE_UTC         @"yyyy-MM-dd HH:mm:ss Z"
#define DEFAULT_CONVERSION_TYPE_ENGLISH     @"MMM dd,yyyy"

@implementation NSDate (Time)

+ (NSCalendar *)currentCalendar
{
    NSString *key = defaultCalendarKey;
    NSString *calendarIdentifier = [self defauleCalendarIdentifier];
    if (calendarIdentifier)
    {
        key = [key stringByAppendingString:calendarIdentifier];
    }
    NSMutableDictionary *mutableDictory = [[NSThread currentThread] threadDictionary];
    NSCalendar *currentCalendar = [mutableDictory objectForKey:key];
    if (currentCalendar == nil)
    {
        if (calendarIdentifier == nil)
        {
            currentCalendar = [NSCalendar currentCalendar];
        }
        else
        {
            currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:calendarIdentifier];
        }
        [mutableDictory setObject:currentCalendar forKey:key];
    }
    return currentCalendar;
}

+ (NSString *)defauleCalendarIdentifier
{
    dispatch_once(&defaultCalendarOnceToken, ^{
        
        defaultCalendarIdentifierLock = [[NSLock alloc] init];
        
    });
    NSString *string;
    [defaultCalendarIdentifierLock lock];
    string = defaultCalendarIdentifier;
    [defaultCalendarIdentifierLock unlock];
    
    return string;
}

+ (void)setDefaultCalendarIdentifier:(NSString *)identifier
{
    dispatch_once(&defaultCalendarOnceToken, ^{
        
        defaultCalendarIdentifierLock = [[NSLock alloc] init];
        
    });
    [defaultCalendarIdentifierLock lock];
    defaultCalendarIdentifier = identifier;
    [defaultCalendarIdentifierLock unlock];
}

#pragma mark - 获取各种日期

+ (NSDate *)dateNow
{
    return [self dateWithDaysAfterNow:0];
}

+ (NSDate *)dateNowUTC
{
    return [self queryUTCDateFormatAnyDate:[self dateNow]];
}

+ (NSDate *)dateTomorrow
{
    return [self dateWithDaysAfterNow:1];
}

+ (NSDate *)dateTomorrowUTC
{
    return [self queryUTCDateFormatAnyDate:[self dateTomorrow]];
}

+ (NSDate *)dateTomorrowWithDate:(NSDate *)date
{
    return [self dateWithDaysAfterDate:date days:1];
}

+ (NSDate *)dateTomorrowUTCWithDate:(NSDate *)date
{
    return [self queryUTCDateFormatAnyDate:[self dateTomorrowWithDate:date]];
}

+ (NSDate *)dateYesterday
{
    return [self dateWithDaysBeforeNow:1];
}

+ (NSDate *)dateYesterdayUTC
{
    return [self queryUTCDateFormatAnyDate:[self dateYesterday]];
}

+ (NSDate *)dateYesterdayWithDate:(NSDate *)date
{
    return [self dateWithDaysBeforeDate:date days:1];
}

+ (NSDate *)dateYesterdayUTCWithDate:(NSDate *)date
{
    return [self queryUTCDateFormatAnyDate:[self dateYesterdayWithDate:date]];
}

+ (NSDate *)dateWithDaysAfterNow:(NSInteger)days
{
    return [NSDate dateWithTimeIntervalSinceReferenceDate:[self querySinceReferenceTime:(SECONDS_IN_DAY * days)]];
}

+ (NSDate *)dateWithDaysAfterNowUTC:(NSInteger)days
{
    return [self queryUTCDateFormatAnyDate:[self dateWithDaysAfterNow:days]];
}

+ (NSDate *)dateWithDaysAfterDate:(NSDate *)date days:(NSInteger)days
{
    return [NSDate dateWithTimeInterval:[self querytimeIntervalSinceDate:date
                                                                    time:(SECONDS_IN_DAY * days)]
                              sinceDate:date];
}

+ (NSDate *)dateWithDaysAfterDateUTC:(NSDate *)date days:(NSInteger)days
{
    return [self queryUTCDateFormatAnyDate:[self dateWithDaysAfterDate:date
                                                                  days:days]];
}

+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days
{
    return [NSDate dateWithTimeIntervalSinceReferenceDate:[self querySinceReferenceTime:-(SECONDS_IN_DAY * days)]];
}

+ (NSDate *)dateWithDaysBeforeNowUTC:(NSInteger)days
{
    return [self queryUTCDateFormatAnyDate:[self dateWithDaysBeforeNow:days]];
}

+ (NSDate *)dateWithDaysBeforeDate:(NSDate *)date days:(NSInteger)days
{
    return [NSDate dateWithTimeInterval:[self querytimeIntervalSinceDate:date
                                                                    time:-(SECONDS_IN_DAY * days)]
                              sinceDate:date];
}

+ (NSDate *)dateWithDaysBeforeDateUTC:(NSDate *)date days:(NSInteger)days
{
    return [self queryUTCDateFormatAnyDate:[self dateWithDaysBeforeDate:date
                                                                   days:days]];
}

+ (NSDate *)dateWithHoursAfterNow:(NSInteger)hours
{
    return [NSDate dateWithTimeIntervalSinceReferenceDate:[self querySinceReferenceTime:(SECONDS_IN_HOUR * hours)]];
}

+ (NSDate *)dateWithHoursAfterNowUTC:(NSInteger)hours
{
    return [self queryUTCDateFormatAnyDate:[self dateWithHoursAfterNow:hours]];
}

+ (NSDate *)dateWithHoursAfterDate:(NSDate *)date hours:(NSInteger)hours
{
    return [NSDate dateWithTimeInterval:[self querytimeIntervalSinceDate:date
                                                                    time:(SECONDS_IN_HOUR * hours)]
                              sinceDate:date];
}

+ (NSDate *)dateWithHoursAfterDateUTC:(NSDate *)date hours:(NSInteger)hours
{
    return [self queryUTCDateFormatAnyDate:[self dateWithHoursAfterDate:date
                                                                  hours:hours]];
}

+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)hours
{
    return [NSDate dateWithTimeIntervalSinceReferenceDate:[self querySinceReferenceTime:-(SECONDS_IN_HOUR * hours)]];
}

+ (NSDate *)dateWithHoursBeforeNowUTC:(NSInteger)hours
{
    return [self queryUTCDateFormatAnyDate:[self dateWithHoursBeforeNow:hours]];
}

+ (NSDate *)dateWithHoursBeforeDate:(NSDate *)date hours:(NSInteger)hours
{
    return [NSDate dateWithTimeInterval:[self querytimeIntervalSinceDate:date
                                                                    time:-(SECONDS_IN_HOUR * hours)]
                              sinceDate:date];
}

+ (NSDate *)dateWithHoursBeforeDateUTC:(NSDate *)date hours:(NSInteger)hours
{
    return [self queryUTCDateFormatAnyDate:[self dateWithHoursBeforeDate:date
                                                                   hours:hours]];
}

+ (NSDate *)dateWithMinutesAfterNow:(NSInteger)minutes
{
    return [NSDate dateWithTimeIntervalSinceReferenceDate:[self querySinceReferenceTime:(SECONDS_IN_MINUTE * minutes)]];
}

+ (NSDate *)dateWithMinutesAfterNowUTC:(NSInteger)minutes
{
    return [self queryUTCDateFormatAnyDate:[self dateWithMinutesAfterNow:minutes]];
}

+ (NSDate *)dateWithMinutesAfterDate:(NSDate *)date minutes:(NSInteger)minutes
{
    return [NSDate dateWithTimeInterval:[self querytimeIntervalSinceDate:date
                                                                    time:(SECONDS_IN_MINUTE * minutes)]
                              sinceDate:date];
}

+ (NSDate *)dateWithMinutesAfterDateUTC:(NSDate *)date minutes:(NSInteger)minutes
{
    return [self queryUTCDateFormatAnyDate:[self dateWithMinutesAfterDate:date
                                                                  minutes:minutes]];
}

+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)minutes
{
    return [NSDate dateWithTimeIntervalSinceReferenceDate:[self querySinceReferenceTime:-(SECONDS_IN_MINUTE * minutes)]];
}

+ (NSDate *)dateWithMinutesBeforeNowUTC:(NSInteger)minutes
{
    return [self queryUTCDateFormatAnyDate:[self dateWithMinutesBeforeNow:minutes]];
}

+ (NSDate *)dateWithMinutesBeforeDate:(NSDate *)date minutes:(NSInteger)minutes
{
    return [NSDate dateWithTimeInterval:[self querytimeIntervalSinceDate:date
                                                                    time:-(SECONDS_IN_MINUTE * minutes)]
                              sinceDate:date];
}

+ (NSDate *)dateWithMinutesBeforeDateUTC:(NSDate *)date minutes:(NSInteger)minutes
{
    return [self queryUTCDateFormatAnyDate:[self dateWithMinutesBeforeDate:date
                                                                   minutes:minutes]];
}

+ (NSTimeInterval)querytimeIntervalSinceDate:(NSDate *)date time:(NSInteger)seconds
{
    NSTimeInterval timeInterval = [[[NSDate alloc] init] timeIntervalSinceDate:date] + (seconds);
    return timeInterval;
}

+ (NSTimeInterval)querySinceReferenceTime:(NSInteger)seconds
{
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] + (seconds);
    return timeInterval;
}

+ (NSDate *)queryUTCDateFormatAnyDate:(NSDate *)date
{
    // 设置时区
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    // 设置转换后的目标时区
    NSTimeZone *destinationTimeZone = [NSTimeZone localTimeZone];
    // 获取源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    // 获取源日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    // 获取两个偏移量的差值
    NSTimeInterval timeInterval = destinationGMTOffset - sourceGMTOffset;
    // 将时间差加到源日期上
    NSDate *utcDate = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date];
    // 返回
#if !__has_feature(objc_arc)
    return [utcDate autorelease];
#else
    return utcDate;
#endif
}

#pragma mark - NSDate Conversion NSString && NSString Conversion NSDate

+ (NSString *)stringWithNow
{
    return [self stringWithDate:[NSDate date]];
}

+ (NSString *)stringWithDate:(NSDate *)date
{
    return [self stringWithDate:date type:DEFAULT_CONVERSION_TYPE];
}

+ (NSString *)stringWithNow:(NSString *)type
{
    return [self stringWithDate:[NSDate date] type:type];
}

+ (NSString *)stringWithDate:(NSDate *)date type:(NSString *)type
{
    return [[self queryDateFormatter:type] stringFromDate:date];
}

+ (NSString *)stringWithNowEnglist
{
    return [self stringWithEnglistDate:[NSDate date]];
}

+ (NSString *)stringWithEnglistDate:(NSDate *)date
{
    return [[self queryDateFormatterEnglist:DEFAULT_CONVERSION_TYPE_ENGLISH] stringFromDate:date];
}

+ (NSString *)stringWithDateUTC:(NSDate *)date
{
    return [self stringWithDateUTC:date type:DEFAULT_CONVERSION_TYPE_UTC];
}

+ (NSString *)stringWithDateUTC:(NSDate *)date type:(NSString *)type
{
    return [[self queryDateFormatterUTC:type] stringFromDate:date];
}

+ (NSDateFormatter *)queryDateFormatter:(NSString *)type
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:type];
    
#if !__has_feature(objc_arc)
    return [dateFormatter autorelease];
#else
    return dateFormatter;
#endif
}

+ (NSDateFormatter *)queryDateFormatterUTC:(NSString *)type
{
    NSDateFormatter *dateFormatter = [self queryDateFormatter:type];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    return dateFormatter;
}

+ (NSDateFormatter *)queryDateFormatterEnglist:(NSString *)type
{
    NSDateFormatter *dateFormatter = [self queryDateFormatter:type];
    dateFormatter.locale =  [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    return dateFormatter;
}

#pragma mark - 判断

+ (BOOL)isToday:(NSDate *)date
{
    return [self isToday:[NSDate date] another:date];
}

+ (BOOL)isToday:(NSDate *)date another:(NSDate *)anotherDate
{
    return [self isSameDay:date other:anotherDate];
}

+ (BOOL)isSameDay:(NSDate *)date other:(NSDate *)otherDate
{
    NSCalendar *currentCalendar = [self currentCalendar];
    NSCalendarUnit unitFlags = NSEraCalendarUnit |
    NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit;
    NSDateComponents *componentsNow = [currentCalendar components:unitFlags fromDate:date];
    NSDateComponents *componentsAnother = [currentCalendar components:unitFlags fromDate:otherDate];
    return ((componentsNow.era == componentsAnother.era) &&
            (componentsNow.year == componentsAnother.year) &&
            (componentsNow.month == componentsAnother.month) &&
            (componentsNow.day == componentsAnother.day));
}

+ (BOOL)isThisWeek:(NSDate *)date
{
    return [self isSameWeek:[NSDate date] other:date];
}

+ (BOOL)isThisWeek:(NSDate *)date another:(NSDate *)anotherDate
{
    return [self isSameWeek:date other:anotherDate];
}

+ (BOOL)isLastWeek:(NSDate *)date
{
    return [self isLastWeek:[NSDate date] another:date];
}

+ (BOOL)isLastWeek:(NSDate *)date another:(NSDate *)anotherDate
{
    NSDate *newDate = [self dateWithDaysBeforeDate:date days:DAYS_IN_WEEK];
    return [self isSameWeek:newDate other:anotherDate];
}

+ (BOOL)isNextWeek:(NSDate *)date
{
    return [self isNextWeek:[NSDate date] another:date];
}

+ (BOOL)isNextWeek:(NSDate *)date another:(NSDate *)anotherWeek
{
    NSDate *newDate = [self dateWithDaysAfterDate:date days:DAYS_IN_WEEK];
    return [self isSameWeek:newDate other:anotherWeek];
}

+ (BOOL)isSameWeek:(NSDate *)date other:(NSDate *)otherDate
{
    NSCalendar *calendar = [self currentCalendar];
    NSDateComponents *componentsNow = [calendar components:NSWeekCalendarUnit fromDate:date];
    NSDateComponents *componentsAnother = [calendar components:NSWeekCalendarUnit fromDate:otherDate];
    if (componentsNow.week != componentsAnother.week)
    {
        return NO;
    }
    return (fabs([self querytimeIntervalSinceDate:date time:0] - [self querytimeIntervalSinceDate:otherDate time:0]) < (SECONDS_IN_DAY * DAYS_IN_WEEK));
}

+ (BOOL)isThisMonth:(NSDate *)date
{
    return [self isThisMonth:[NSDate date] another:date];
}

+ (BOOL)isThisMonth:(NSDate *)date another:(NSDate *)anotherDate
{
    NSCalendar *calendar = [self currentCalendar];
    NSDateComponents *componentsNow = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:date];
    NSDateComponents *componentsAnother = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:anotherDate];
    
    return ((componentsNow.year == componentsAnother.year) &&
            (componentsNow.month == componentsAnother.month));
}

+ (BOOL)isLastMonth:(NSDate *)date
{
    return [self isLastMonth:[NSDate date] another:date];
}

+ (BOOL)isLastMonth:(NSDate *)date another:(NSDate *)anotherDate
{
    NSCalendar *calendar = [self currentCalendar];
    NSDateComponents *componentsNow = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:date];
    NSDateComponents *componentsLast = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:anotherDate];
    componentsNow.month -= 1;
    
    return ((componentsNow.year == componentsLast.year) &&
            (componentsNow.month == componentsLast.month));
}

+ (BOOL)isNextMonth:(NSDate *)date
{
    return [self isNextMonth:[NSDate date] another:date];
}

+ (BOOL)isNextMonth:(NSDate *)date another:(NSDate *)anotherDate
{
    NSCalendar *calendar = [self currentCalendar];
    NSDateComponents *componentsNow = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:date];
    NSDateComponents *componentsNext = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:anotherDate];
    componentsNow.month += 1;
    
    return ((componentsNow.year == componentsNext.year) &&
            (componentsNow.month  == componentsNext.month));
}

+ (BOOL)isThisYear:(NSDate *)date
{
    return [self isThisYear:[NSDate date] another:date];
}

+ (BOOL)isThisYear:(NSDate *)date another:(NSDate *)anotherDate
{
    NSCalendar *calendar = [self currentCalendar];
    NSDateComponents *componentsNow = [calendar components:NSYearCalendarUnit fromDate:date];
    NSDateComponents *componentsAnother = [calendar components:NSYearCalendarUnit fromDate:anotherDate];
    
    return (componentsNow.year == componentsAnother.year);
}

+ (BOOL)isLastYear:(NSDate *)date
{
    return [self isLastYear:[NSDate date] another:date];
}

+ (BOOL)isLastYear:(NSDate *)date another:(NSDate *)anotherDate
{
    NSCalendar *calendar = [self currentCalendar];
    NSDateComponents *componentsNow = [calendar components:NSYearCalendarUnit fromDate:date];
    NSDateComponents *componentsLast = [calendar components:NSYearCalendarUnit fromDate:anotherDate];
    componentsNow.year -= 1;
    
    return (componentsNow.year == componentsLast.year);
}

+ (BOOL)isNextYear:(NSDate *)date
{
    return [self isNextYear:[NSDate date] another:date];
}

+ (BOOL)isNextYear:(NSDate *)date another:(NSDate *)anotherDate
{
    NSCalendar *calendar = [self currentCalendar];
    NSDateComponents *componentsNow = [calendar components:NSYearCalendarUnit fromDate:date];
    NSDateComponents *componentsNext = [calendar components:NSYearCalendarUnit fromDate:anotherDate];
    componentsNow.year += 1;
    
    return (componentsNow.year == componentsNext.year);
}

+ (BOOL)isTypicallyWeekend
{
    return [self isTypicallyWeekend:[NSDate date]];
}

+ (BOOL)isTypicallyWeekend:(NSDate *)date
{
    NSCalendar *calendar = [self currentCalendar];
    NSRange weekdayRange = [calendar maximumRangeOfUnit:NSWeekdayCalendarUnit];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    NSInteger weekdayOfDate = [components weekday];
    if (weekdayOfDate == weekdayRange.location || weekdayOfDate == weekdayRange.length)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isTypicallyWorkday
{
    return [self isTypicallyWorkday:[NSDate date]];
}

+ (BOOL)isTypicallyWorkday:(NSDate *)date
{
    return ![self isTypicallyWeekend:date];
}

#pragma mark - Year、Month、Day ...

+ (NSInteger)years
{
    return [self yearsWithDate:[NSDate date]];
}

+ (NSInteger)yearsWithDate:(NSDate *)date
{
    return [[[self currentCalendar] components:NSYearCalendarUnit fromDate:date] year];
}

+ (NSInteger)months
{
    return [self monthsWithDate:[NSDate date]];
}

+ (NSInteger)monthsWithDate:(NSDate *)date
{
    return [[[self currentCalendar] components:NSMonthCalendarUnit fromDate:date] month];
}

+ (NSString *)monthsInEnglish
{
    switch ([self months])
    {
        case 1:
            return @"January";
            break;
        case 2:
            return @"February";
            break;
        case 3:
            return @"March";
            break;
        case 4:
            return @"April";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"June";
            break;
        case 7:
            return @"July";
            break;
        case 8:
            return @"August";
            break;
        case 9:
            return @"September";
            break;
        case 10:
            return @"October";
            break;
        case 11:
            return @"November";
            break;
        case 12:
            return @"December";
            break;
        default:
            return @"December";
            break;
    }
}

+ (NSString *)monthsInEnglishWithDate:(NSDate *)date
{
    switch ([self monthsWithDate:date])
    {
        case 1:
            return @"January";
            break;
        case 2:
            return @"February";
            break;
        case 3:
            return @"March";
            break;
        case 4:
            return @"April";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"June";
            break;
        case 7:
            return @"July";
            break;
        case 8:
            return @"August";
            break;
        case 9:
            return @"September";
            break;
        case 10:
            return @"October";
            break;
        case 11:
            return @"November";
            break;
        case 12:
            return @"December";
            break;
        default:
            return @"December";
            break;
    }
}

+ (NSString *)monthsInEnglishShort
{
    switch ([self months])
    {
        case 1:
            return @"Jan";
            break;
        case 2:
            return @"Feb";
            break;
        case 3:
            return @"Mar";
            break;
        case 4:
            return @"Apr";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"June";
            break;
        case 7:
            return @"July";
            break;
        case 8:
            return @"Aug";
            break;
        case 9:
            return @"Sept";
            break;
        case 10:
            return @"Oct";
            break;
        case 11:
            return @"Nov";
            break;
        case 12:
            return @"Dec";
            break;
        default:
            return @"Dec";
            break;
    }
}

+ (NSString *)monthsInEnglishShortWithDate:(NSDate *)date
{
    switch ([self monthsWithDate:date])
    {
        case 1:
            return @"Jan";
            break;
        case 2:
            return @"Feb";
            break;
        case 3:
            return @"Mar";
            break;
        case 4:
            return @"Apr";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"June";
            break;
        case 7:
            return @"July";
            break;
        case 8:
            return @"Aug";
            break;
        case 9:
            return @"Sept";
            break;
        case 10:
            return @"Oct";
            break;
        case 11:
            return @"Nov";
            break;
        case 12:
            return @"Dec";
            break;
        default:
            return @"Dec";
            break;
    }
}

+ (NSInteger)days
{
    return [self daysWithDate:[NSDate date]];
}

+ (NSInteger)daysWithDate:(NSDate *)date
{
    return [[[self currentCalendar] components:NSDayCalendarUnit fromDate:date] day];
}

+ (NSInteger)hours
{
    return [self hoursWithDate:[NSDate date]];
}

+ (NSInteger)hoursWithDate:(NSDate *)date
{
    return [[[self currentCalendar] components:NSHourCalendarUnit fromDate:date] hour];
}

+ (NSInteger)minutes
{
    return [self minutesWithDate:[NSDate date]];
}

+ (NSInteger)minutesWithDate:(NSDate *)date
{
    return [[[self currentCalendar] components:NSMinuteCalendarUnit fromDate:date] minute];
}

+ (NSInteger)seconds
{
    return [self secondsWithDate:[NSDate date]];
}

+ (NSInteger)secondsWithDate:(NSDate *)date
{
    return [[[self currentCalendar] components:NSSecondCalendarUnit fromDate:date] second];
}

@end
