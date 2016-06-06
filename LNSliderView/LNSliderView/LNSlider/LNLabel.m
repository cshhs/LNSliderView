//
//  LNLabel.m
//  CCC
//
//  Created by lemon on 16/5/17.
//  Copyright © 2016年 ys. All rights reserved.
//

#import "LNLabel.h"

const CGFloat XMGRed = 154;
const CGFloat XMGGreen = 161;
const CGFloat XMGBlue = 188;
const CGFloat XMGAlpha = 1.0;
const int XMGAge = 20;

@implementation LNLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:14];
        self.textColor = [UIColor colorWithRed:XMGRed green:XMGGreen blue:XMGBlue alpha:1.0];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    //      R G B
    // 默认：0.4 0.6 0.7
    // 红色：1   0   0
    
    CGFloat red = XMGRed - 91 * scale;
    CGFloat green = XMGGreen - 85 * scale;
    CGFloat blue = XMGBlue - 54 * scale;
    self.textColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
    
    // 大小缩放比例
    CGFloat transformScale = 1 + scale * 0.2; // [1, 1.3]
    self.transform = CGAffineTransformMakeScale(transformScale, transformScale);
}

@end
