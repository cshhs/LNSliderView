//
//  LNSliderView.m
//  CCC
//
//  Created by lemon on 16/5/16.
//  Copyright © 2016年 ys. All rights reserved.
//

#import "LNSliderView.h"
#import "LNLabel.h"

//底部线条
#define lineHeight 0.5
//滚动线条
#define bottomLineViewHeight 3


@interface LNSliderView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *contentScv;
//用来定制右侧的View
@property(nonatomic,strong)UIView *rightView;
//用来定制左侧的View
@property(nonatomic,strong)UIView *leftView;
@property(nonatomic,strong)UIView *lineView;
//高亮的Label
//@property(nonatomic,strong)LNLabel *selestLabel;
//底部跟随滑动的View
@property(nonatomic,strong)UIView *bottomLineView;
@end

@implementation LNSliderView

- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)title{
    self = [super initWithFrame:frame];
    if (self) {
        self.titlesDataArr = title;
        [self initNormalSet];
        [self initScrollView];
        [self initLineView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)title leftView:(UIView *)leftView rightView:(UIView *)rightView{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftView = leftView;
        self.rightView = rightView;
        self.titlesDataArr = title;
        
        [self initNormalSet];
        [self initScrollView];
        [self initLineView];
    }
    return self;
}

//初始化一些默认设置
-(void)initNormalSet{
    _backColor = [UIColor whiteColor];
    _titleFont = [UIFont systemFontOfSize:15];
    _titleColor = [UIColor blackColor];
    
}

-(void)initScrollView{
    CGFloat left = 0.0f;
    CGFloat right = 0.0f;
    CGFloat scvWidth = 0.0f;
    //左侧视图
    if (self.leftView) {
        left = self.leftView.frame.size.width;
        self.leftView.frame = CGRectMake(0, 0, left, self.frame.size.height);
    }
    //右侧视图
    if (self.rightView) {
        right = self.rightView.frame.size.width;
        self.rightView.frame = CGRectMake(ViewWidth-right, 0, right, self.frame.size.height);
    }
    scvWidth = self.frame.size.width - left - right;
    self.contentScv = [[UIScrollView alloc]initWithFrame:CGRectMake(left, 0, scvWidth , self.frame.size.height - lineHeight)];
    self.contentScv.backgroundColor = [UIColor clearColor];
    self.contentScv.showsVerticalScrollIndicator = NO;
    self.contentScv.showsHorizontalScrollIndicator = NO;
    self.contentScv.scrollEnabled = YES;
    self.contentScv.userInteractionEnabled = YES;
    [self titleBtnInit];
    
    [self addSubview:self.contentScv];
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
}

#pragma mark--计算数据源里面最大的长度
-(void)titleBtnInit{
    //获取最大长度的btn
    if (self.titlesDataArr) {
        CGFloat btnWidth = 0.0f;
        NSInteger titleLength = 0;
        NSString *maxTitle = @"";
        
        for (NSString *title in self.titlesDataArr) {
            NSInteger length = [title lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
                if (length > titleLength) {
                    titleLength = length;
                    maxTitle = title;
                }
        }
        CGSize size = [maxTitle sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.titleFont,NSFontAttributeName, nil]];
        btnWidth = size.width + 40;
        self.contentScv.contentSize = CGSizeMake(btnWidth*self.titlesDataArr.count, self.frame.size.height - lineHeight);
        
        for (int i=0; i<self.titlesDataArr.count; i++) {
            LNLabel *titleLabel = [[LNLabel alloc]initWithFrame:CGRectMake(i*btnWidth , 0, btnWidth, self.frame.size.height - lineHeight - bottomLineViewHeight)];
            titleLabel.font = self.titleFont;
            NSString *fightTitle = self.titlesDataArr[i];
            titleLabel.text = fightTitle;
            titleLabel.tag = i;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = self.titleColor;
            [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleClick:)]];
            if(i == 0){
                titleLabel.scale = 1.0;
            }
            [self.contentScv addSubview:titleLabel];
        }
        self.bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - lineHeight - bottomLineViewHeight, btnWidth, bottomLineViewHeight)];
        self.bottomLineView.backgroundColor = [UIColor blackColor];
        [self.contentScv addSubview:self.bottomLineView];
    }
}

-(void)initLineView{
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - lineHeight, self.frame.size.width, lineHeight)];
    self.lineView.backgroundColor = [UIColor grayColor];
    [self addSubview:self.lineView];
}

//菜单按钮移动位置
-(void)setMenusScrollView:(CGPoint)contentOffset{
    CGFloat scale = contentOffset.x / ViewWidth;

    if (scale < 0 || scale > self.contentScv.subviews.count - 1 - 1) return;
    
    CGRect frame = self.bottomLineView.frame;
    frame.origin.x = scale * self.bottomLineView.frame.size.width;
    self.bottomLineView.frame = frame;
    
    // 获得需要操作的左边label
    NSInteger leftIndex = scale;
    LNLabel *leftLabel = self.contentScv.subviews[leftIndex];

    // 获得需要操作的右边label
    NSInteger rightIndex = leftIndex + 1;
    LNLabel *rightLabel = (rightIndex == self.contentScv.subviews.count - 1) ? nil : self.contentScv.subviews[rightIndex];

    // 右边比例
    CGFloat rightScale = scale - leftIndex;
    // 左边比例
    CGFloat leftScale = 1 - rightScale;

    // 设置label的比例
    leftLabel.scale = leftScale;
    rightLabel.scale = rightScale;

}

//菜单按钮移动位置(结束调用)
//为了以防ScrollView滚动偏移量导致标题出现大小不正确的情况
//再结束的时候清楚错误的标题大小
-(void)setMenusScrollViewEnd:(CGPoint)endOffset{
    
    NSInteger index = endOffset.x/ViewWidth;
    [self removeAllTitleScale:index];
    
    LNLabel *label = self.contentScv.subviews[index];
    CGFloat width = self.contentScv.frame.size.width;
    CGPoint titleOffset = self.contentScv.contentOffset;
    
    titleOffset.x = label.center.x - width * 0.5;
    //左边超出
    if (titleOffset.x < 0) titleOffset.x = 0;
    //可移动最大量
    CGFloat maxTitleOffsetX = self.contentScv.contentSize.width - width;
    if (maxTitleOffsetX < titleOffset.x) titleOffset.x = maxTitleOffsetX;
    
    [self.contentScv setContentOffset:titleOffset animated:YES];
}


//标题点击
-(void)titleClick:(UITapGestureRecognizer *)tap{
    // 取出被点击label的索引
    int index = (int)tap.view.tag;
    
    if ([self.delegate respondsToSelector:@selector(menuMoveIndex:)]) {
        [self.delegate menuMoveIndex:index];
    }
}

//清楚所有非正确位置的大标题
-(void)removeAllTitleScale:(NSInteger)index{
    for (int i=0; i<self.contentScv.subviews.count - 1; i++) {
        UIView *subView = self.contentScv.subviews[i];
        if([subView isKindOfClass:[LNLabel class]]){
            if (i == index) {
                continue;
            }
            LNLabel *titleLabel = (LNLabel *)subView;
            titleLabel.scale = 0.0f;
        }
    }
}

-(void)setBackColor:(UIColor *)backColor{
    _backColor = backColor;
    self.backgroundColor = _backColor;
}
-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    self.lineView.backgroundColor = _lineColor;

}
-(void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    [self.contentScv.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self titleBtnInit];
    
}
-(void)setTitlesDataArr:(NSArray *)titlesDataArr{
    _titlesDataArr = titlesDataArr;
}

-(void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    NSArray *svcSubView = self.contentScv.subviews;
    for (UIView *subView in svcSubView) {
        if([subView isKindOfClass:[LNLabel class]]){
            UILabel *titleLabel = (LNLabel *)subView;
            titleLabel.textColor = _titleColor;
        }
    }
}
-(void)setBottomLineColor:(UIColor *)bottomLineColor{
    _bottomLineColor = bottomLineColor;
    self.bottomLineView.backgroundColor = _bottomLineColor;
}
@end
