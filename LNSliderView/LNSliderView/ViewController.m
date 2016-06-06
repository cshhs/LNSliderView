//
//  ViewController.m
//  LNSliderView
//
//  Created by lemon on 16/6/6.
//  Copyright © 2016年 csh. All rights reserved.
//

#import "ViewController.h"
#import "LNSliderView.h"
#import "TestViewController.h"

@interface ViewController ()<UIScrollViewDelegate,LNSliderViewDelegate>
@property (strong, nonatomic) LNSliderView *sliderView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScv;
//数据源
@property (strong, nonatomic) NSArray *dataArr;
//自控制器
@property (strong, nonatomic) NSMutableArray *subsArr;
@end

@implementation ViewController

-(NSArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = @[@"栏目1",@"栏目2",@"栏目3",@"栏目4",@"栏目5",@"栏目6",@"栏目7",@"栏目8",@"栏目9"];
    }
    return _dataArr;
}

-(NSMutableArray *)subsArr{
    if(_subsArr == nil){
        _subsArr = [NSMutableArray array];
    }
    return _subsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化滑动头
    [self sliderViewInit];
    //初始化子控制器
    [self initChildVC];
    //初始化显示View
    [self initContentView];
}

-(void)sliderViewInit{
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 50, 0)];
    rightView.backgroundColor = [UIColor redColor];
    
    self.sliderView = [[LNSliderView alloc]initWithFrame:CGRectMake(0, 20, ViewWidth, 44.5) withTitleArray:self.dataArr leftView:nil rightView:rightView];
    self.sliderView.titleColor = [UIColor colorWithRed:167/255.0 green:168/255.0 blue:186/255.0 alpha:1.0];
    self.sliderView.titleFont = [UIFont systemFontOfSize:15];
    self.sliderView.bottomLineColor = [UIColor colorWithRed:238/255.0 green:118/255.0 blue:98/255.0 alpha:1.0];
    self.sliderView.lineColor = [UIColor blueColor];
    self.sliderView.delegate = self;
    [self.view addSubview:self.sliderView];
}

-(void)initContentView{
    self.contentScv.contentSize = CGSizeMake(ViewWidth * self.dataArr.count, 0);
    self.contentScv.pagingEnabled = YES;    
}

#pragma mark--初始化子控制器
-(void)initChildVC{
    for (int i=0; i<self.dataArr.count; i++) {
        TestViewController *childVC = [[TestViewController alloc]init];
        [self addChildViewController:childVC];
        [self.subsArr addObject:childVC];
    }
    
    // 默认显示第0个子控制器
    [self scrollViewDidEndScrollingAnimation:self.contentScv];
}

#pragma mark---LNSliderViewDelegate

#pragma mark--注意
//测试发现 setContentOffset方法之后
//scrollViewDidScroll调用的次数有限
//没有按照正确的调用方法执行
//所以会出现标题大小问题

-(void)menuMoveIndex:(NSInteger)index{
    CGPoint offset = self.contentScv.contentOffset;
    offset.x = ViewWidth*index;
    
    [self.contentScv setContentOffset:offset animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
/**
 * scrollView结束了滚动动画以后就会调用这个方法（比如- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;方法执行的动画完毕后）
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self.sliderView setMenusScrollViewEnd:scrollView.contentOffset];
    
    NSInteger index = scrollView.contentOffset.x/ViewWidth;
    // 取出需要显示的控制器
    UIViewController *willShowVc = self.childViewControllers[index];
    // 如果当前位置的位置已经显示过了，就直接返回
    if ([willShowVc isViewLoaded]) return;
    // 添加控制器的view到contentScrollView中;
    willShowVc.view.frame = CGRectMake(scrollView.contentOffset.x, 0, scrollView.frame.size.width, scrollView.frame.size.height);
    [scrollView addSubview:willShowVc.view];
}

/**
 * 手指松开scrollView后，scrollView停止减速完毕就会调用这个
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/**
 * 只要scrollView在滚动，就会调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.sliderView setMenusScrollView:scrollView.contentOffset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
