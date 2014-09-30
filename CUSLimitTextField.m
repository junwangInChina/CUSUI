//
//  CUSLimitTextField.m
//  CUSUI
//
//  Created by wangjun on 14-7-3.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "CUSLimitTextField.h"

@implementation CUSLimitTextField
@synthesize limit = _limit;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(textFiledEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:self];
    }
    return self;
}

- (void)textFiledEditChanged:(NSNotification *)notification
{
    UITextField *textField = (UITextField *)notification.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"] || [lang isEqualToString:@"zh-Hant"])
    {
        // 简体中文输入，包括简体拼音，简体五笔，简体手写(zh-Hans)
        // 繁体中文输入，包括繁体拼音，繁体五笔，繁体手写(zh-Hant)
        UITextRange *selectedRange = [textField markedTextRange];
        // 获取高亮部分（联想部分）
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有联想，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > self.limit)
            {
                textField.text = [toBeString substringToIndex:self.limit];
            }
        }
        // 有联想，则暂不对联想的文字进行统计
        else
        {
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，暂时不考虑其他语种情况
    else
    {
        if (toBeString.length > self.limit)
        {
            textField.text = [toBeString substringToIndex:self.limit];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
