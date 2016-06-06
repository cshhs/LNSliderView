//
//  LNSliderView.h
//  CCC
//
//  Created by lemon on 16/5/16.
//  Copyright © 2016年 ys. All rights reserved.
//


//视图宽高
#define ViewWidth                        ([[UIScreen mainScreen] bounds].size.width)
#define ViewHeight                       ([[UIScreen mainScreen] bounds].size.height)


#import <UIKit/UIKit.h>

@protocol LNSliderViewDelegate <NSObject>

@required
-(void)menuMoveIndex:(NSInteger)index;
@end

//侧滑的头
@interface LNSliderView : UIView
//数据源
@property(nonatomic,strong)NSArray *titlesDataArr;
//背景色
@property(nonatomic,strong)UIColor *backColor;
//线的颜色
@property(nonatomic,strong)UIColor *lineColor;
//标题字体
@property (nonatomic, strong) UIFont *titleFont;
//标题字体颜色
@property (nonatomic, strong) UIColor *titleColor;
//底部移动线的颜色
@property (nonatomic, strong) UIColor *bottomLineColor;

@property (nonatomic, weak) id<LNSliderViewDelegate> delegate;
/**
 *  初始化滑动选择视图(不包含任何的左侧和右侧的View)
 *  title 数据源
 *
 *  @return LNSliderView实例
 */
- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)title;
/**
 *  初始化滑动选择视图
 *  title 数据源
 *
 *  @return LNSliderView实例
 */
- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)title leftView:(UIView *)leftView rightView:(UIView *)rightView;


-(void)setMenusScrollView:(CGPoint)contentOffset;
//滑动停止的时候
-(void)setMenusScrollViewEnd:(CGPoint)endOffset;
@end
