//
//  UITextField+Attribute.m
//  CUSUI
//
//  Created by wangjun on 14-7-15.
//  Copyright (c) 2014年 wangjun. All rights reserved.
//

#import "UITextField+Attribute.h"

static NSMutableAttributedString *attributedString;
static NSMutableParagraphStyle *parrgraphStyle;

@implementation UITextField (Attribute)

- (NSMutableParagraphStyle *)getParagraphStyl
{
    if (!parrgraphStyle)
    {
        parrgraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    return parrgraphStyle;
}

- (NSMutableAttributedString *)getAttributedString
{
    if (!attributedString)
    {
        attributedString = [[NSMutableAttributedString alloc] init];
    }
    
    return attributedString;
}

- (void)updateAttributeString
{
    if (self.text && self.text.length > 0)
    {
        NSDictionary *attDic = @{NSParagraphStyleAttributeName:[self getParagraphStyl]};
        NSAttributedString *string = [[[NSAttributedString alloc] initWithString:self.text attributes:attDic] autorelease];
        [[self getAttributedString] appendAttributedString:string];
    }
}

- (void)drawNewText
{
    [self updateAttributeString];
    
    self.attributedText = [self getAttributedString];
}

- (BOOL)checkRangeRight:(NSRange)range
{
    if (range.location + range.length > [self getAttributedString].length)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)setLineSpacing:(CGFloat)space
{
    [self getParagraphStyl].lineSpacing = space;
    
    [self drawNewText];
}

- (void)setFirstLineHeadIndent:(CGFloat)space
{
    [self getParagraphStyl].firstLineHeadIndent = space;
    
    [self drawNewText];
}

- (void)setHeadIndent:(CGFloat)space
{
    [self getParagraphStyl].headIndent = space;
    
    [self drawNewText];
}

- (void)setTailIndent:(CGFloat)space
{
    [self getParagraphStyl].tailIndent = space;
    
    [self drawNewText];
}

- (void)setMaximumLineHeight:(CGFloat)space
{
    [self getParagraphStyl].maximumLineHeight = space;
    
    [self drawNewText];
}

- (void)setMinimumLineHeight:(CGFloat)space
{
    [self getParagraphStyl].minimumLineHeight = space;
    
    [self drawNewText];
}

- (void)setLineHeightMultiple:(CGFloat)space
{
    [self getParagraphStyl].lineHeightMultiple = space;
    
    [self drawNewText];
}

- (void)setParagraphSpacing:(CGFloat)space
{
    [self getParagraphStyl].paragraphSpacing = space;
    
    [self drawNewText];
}

- (void)setParagraphSpacingBefore:(CGFloat)space
{
    [self getParagraphStyl].paragraphSpacingBefore = space;
    
    [self drawNewText];
}

- (void)setWritingDirection:(NSWritingDirection)writeDirection
{
    [self getParagraphStyl].baseWritingDirection = writeDirection;
    
    [self drawNewText];
}

- (void)addUnderLine
{
    [[self getAttributedString] addAttribute:NSUnderlineStyleAttributeName
                                       value:[NSNumber numberWithInteger:1]
                                       range:NSMakeRange(0, [[self getAttributedString] length])];
    
    [self drawNewText];
}

- (void)addUnderLineWithRange:(NSRange)range
{
    if ([self checkRangeRight:range])
    {
        [[self getAttributedString] addAttribute:NSUnderlineStyleAttributeName
                                           value:[NSNumber numberWithInteger:1]
                                           range:range];
        
        [self drawNewText];
    }
}

- (void)addDeleteLine
{
    [[self getAttributedString] addAttribute:NSStrikethroughStyleAttributeName
                                       value:[NSNumber numberWithInteger:1]
                                       range:NSMakeRange(0, [[self getAttributedString] length])];
    
    [self drawNewText];
}

- (void)addDeleteLineWithRange:(NSRange)range
{
    if ([self checkRangeRight:range])
    {
        [[self getAttributedString] addAttribute:NSStrikethroughStyleAttributeName
                                           value:[NSNumber numberWithInteger:1]
                                           range:range];
        
        [self drawNewText];
    }
}

- (void)changeCharacterColor:(UIColor *)color range:(NSRange)range
{
    if ([self checkRangeRight:range])
    {
        [[self getAttributedString] addAttribute:NSForegroundColorAttributeName
                                           value:color
                                           range:range];
        
        [self drawNewText];
    }
}

- (void)changeBackgroundColor:(UIColor *)color range:(NSRange)range
{
    if ([self checkRangeRight:range])
    {
        [[self getAttributedString] addAttribute:NSBackgroundColorAttributeName
                                           value:color
                                           range:range];
        
        [self drawNewText];
    }
}

- (void)changeCharacterFont:(UIFont *)font range:(NSRange)range
{
    if ([self checkRangeRight:range])
    {
        [[self getAttributedString] addAttribute:NSFontAttributeName
                                           value:font
                                           range:range];
        [self drawNewText];
    }
    
}

- (void)changeCharacterSpacing:(CGFloat)space
{
    [[self getAttributedString] addAttribute:NSKernAttributeName
                                       value:[NSNumber numberWithFloat:space]
                                       range:NSMakeRange(0, [[self getAttributedString] length])];
    [self drawNewText];
}

- (void)changeCharacterSpacing:(CGFloat)space range:(NSRange)range
{
    if ([self checkRangeRight:range])
    {
        [[self getAttributedString] addAttribute:NSKernAttributeName
                                           value:[NSNumber numberWithFloat:space]
                                           range:range];
        [self drawNewText];
    }
}

- (void)changeCharacterHollow:(CGFloat)space
{
    [[self getAttributedString] addAttribute:NSStrokeWidthAttributeName
                                       value:[NSNumber numberWithFloat:space]
                                       range:NSMakeRange(0, [[self getAttributedString] length])];
    [self drawNewText];
}

- (void)changeCharacterHollow:(CGFloat)space color:(UIColor *)color
{
    [[self getAttributedString] addAttribute:NSStrokeWidthAttributeName
                                       value:[NSNumber numberWithFloat:space]
                                       range:NSMakeRange(0, [[self getAttributedString] length])];
    if (color)
    {
        [[self getAttributedString] addAttribute:NSStrokeColorAttributeName
                                           value:color
                                           range:NSMakeRange(0, [[self getAttributedString] length])];
    }
    
    [self drawNewText];
}

- (void)changeCharacterHollow:(CGFloat)space range:(NSRange)range
{
    if ([self checkRangeRight:range])
    {
        [[self getAttributedString] addAttribute:NSStrokeWidthAttributeName
                                           value:[NSNumber numberWithFloat:space]
                                           range:range];
        [self drawNewText];
    }
}

- (void)changeCharacterHollow:(CGFloat)space range:(NSRange)range color:(UIColor *)color
{
    if ([self checkRangeRight:range])
    {
        [[self getAttributedString] addAttribute:NSStrokeWidthAttributeName
                                           value:[NSNumber numberWithFloat:space]
                                           range:range];
        if (color)
        {
            [[self getAttributedString] addAttribute:NSStrokeColorAttributeName
                                               value:color
                                               range:range];
        }
        
        [self drawNewText];
    }
}

@end
