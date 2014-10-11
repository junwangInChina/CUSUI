//
//  CUSUtil.m
//  CUSUI
//
//  Created by wangjun on 14-10-11.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSUtil.h"
#import <sys/utsname.h>

static CUSUtil *util = nil;
static dispatch_once_t onceToken;

@implementation CUSUtil

+ (CUSUtil *)shareInstance
{
    dispatch_once(&onceToken, ^{
       
        util = [[CUSUtil alloc] init];
        
    });
    return util;
}

- (NSString *)machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *machName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSDictionary *commonNamesDictionary = 
    @{
      @"i386":     @"Simulator",
      @"x86_64":   @"Simulator",
      
      @"iPhone1,1":    @"iPhone",
      @"iPhone1,2":    @"iPhone3G",
      @"iPhone2,1":    @"iPhone3GS",
      @"iPhone3,1":    @"iPhone4",
      @"iPhone3,2":    @"iPhone4",
      @"iPhone3,3":    @"iPhone4",
      @"iPhone4,1":    @"iPhone4S",
      @"iPhone5,1":    @"iPhone5",
      @"iPhone5,2":    @"iPhone5",
      @"iPhone5,3":    @"iPhone5c",
      @"iPhone5,4":    @"iPhone5c",
      @"iPhone6,1":    @"iPhone5s",
      @"iPhone6,2":    @"iPhone5s",
      @"iPhone7,2":    @"iPhone6",
      @"iPhone7,1":    @"iPhone6Plus",
      
      @"iPad1,1":  @"iPad",
      @"iPad2,1":  @"iPad 2(WiFi)",
      @"iPad2,2":  @"iPad 2(GSM)",
      @"iPad2,3":  @"iPad 2(CDMA)",
      @"iPad2,4":  @"iPad 2(WiFi Rev A)",
      @"iPad2,5":  @"iPad Mini(WiFi)",
      @"iPad2,6":  @"iPad Mini(GSM)",
      @"iPad2,7":  @"iPad Mini(GSM+CDMA)",
      @"iPad3,1":  @"iPad 3(WiFi)",
      @"iPad3,2":  @"iPad 3(GSM+CDMA)",
      @"iPad3,3":  @"iPad 3(GSM)",
      @"iPad3,4":  @"iPad 4(WiFi)",
      @"iPad3,5":  @"iPad 4(GSM)",
      @"iPad3,6":  @"iPad 4(GSM+CDMA)",
      
      @"iPod1,1":  @"iPod 1st Gen",
      @"iPod2,1":  @"iPod 2nd Gen",
      @"iPod3,1":  @"iPod 3rd Gen",
      @"iPod4,1":  @"iPod 4th Gen",
      @"iPod5,1":  @"iPod 5th Gen",

      };
    NSString *deviceName = commonNamesDictionary[machName];
    
    if (deviceName == nil)
    {
        deviceName = machName;
    }
    
    return deviceName;
}

@end
