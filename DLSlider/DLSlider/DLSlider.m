//
//  DLSlider.m
//  html
//
//  Created by DongLei on 2018/3/16.
//  Copyright © 2018年 DongLei All rights reserved.
//

#import "DLSlider.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGTH [UIScreen mainScreen].bounds.size.height

@interface DLSlider ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) CGFloat itemWidth;   //标尺item宽度
@property (nonatomic, assign) BOOL setDefaultIndex;  //是否已经设置默认位置
@property (nonatomic, strong) UIButton *sign;

@end

@implementation DLSlider

- (instancetype)init
{
    self = [super init];
    if (self) {
        //1.告诉系统我们要自定义转场
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        //2.设置转场的代理
        self.transitioningDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化,设置默认值
    _stepNum = _stepNum == 0 ? 4 : _stepNum;
    _lineColor = _lineColor == nil ? [UIColor colorWithRed:66/255.0 green:130/255.0 blue:191/255.0 alpha:1] : _lineColor;
    _itemWidth = SCREEN_WIDTH / _stepNum;
    _titleFont = _titleFont == nil ? [UIFont systemFontOfSize:14] : _titleFont;
    _titleColor = _titleColor == nil ? [UIColor darkGrayColor] : _titleColor;
    _defaultIndex = _setDefaultIndex ? _defaultIndex : 1;
    _currentIndex = _defaultIndex;
    //添加标尺
    for (int i = 0; i < _stepNum; i++) {
        [self setupRuleItemWithIndex:i];
    }
    
    //关闭按钮
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGTH * .2 - 50, SCREEN_WIDTH, 50)];
    [self.view addSubview:closeBtn];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismissVc) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat signX = _itemWidth * (_defaultIndex + .5) - 6;
    CGFloat signY = (SCREEN_HEIGTH * .2 - 50) * .5 + 10;
    
    UIButton *sign = [[UIButton alloc] initWithFrame:CGRectMake(signX , signY, 20, 20)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSign:)];
    [sign addGestureRecognizer:pan];
    _sign = sign;
    [self.view addSubview:sign];
    sign.backgroundColor = [UIColor whiteColor];
    sign.layer.cornerRadius = 10;
    sign.layer.shadowColor = [UIColor grayColor].CGColor;
    sign.layer.shadowOffset = CGSizeMake(1, 1);
    sign.layer.shadowOpacity = .5;
    
}

#pragma mark：______________设置标尺的item______________
- (void)setupRuleItemWithIndex:(NSInteger)index {
    
    CGFloat selfHeight = SCREEN_HEIGTH * .2;  //self的高度
    CGFloat itemHeight = selfHeight - 50;    //标尺item的高度
    
    UIView * item = [[UIView alloc] initWithFrame:CGRectMake(_itemWidth * index, 0, _itemWidth, itemHeight)];
    item.tag = index;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)];
    [item addGestureRecognizer:tap];
    item.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:item];
    
    //标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, CGRectGetWidth(item.frame) - 10, 30)];
    title.text = @"";
    [item addSubview:title];
    title.textColor = _titleColor;
    title.font = [UIFont systemFontOfSize:14];
    title.textAlignment = NSTextAlignmentCenter;
    title.numberOfLines = 2;
    
    if ([self.delegate respondsToSelector:@selector(titleFontAtIndex: withMark:)]) {
        title.font = [self.delegate titleFontAtIndex:index withMark:self.mark];
    }
    if ([self.delegate respondsToSelector:@selector(titleColorAtIndex: withMark:)]) {
        title.textColor = [self.delegate titleColorAtIndex:index withMark:self.mark];
    }
    if ([self.delegate respondsToSelector:@selector(titleAtIndex: withMark:)]) {
        title.text = [self.delegate titleAtIndex:index withMark:self.mark];
    }
    
    //左半线
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, itemHeight * .5 + 20, _itemWidth * .5, 1)];
    leftLine.backgroundColor = _lineColor;
    [item addSubview:leftLine];
    leftLine.hidden = index == 0;
    
    //右半线
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(_itemWidth * .5, itemHeight * .5 + 20, _itemWidth * .5, 1)];
    rightLine.backgroundColor = _lineColor;
    [item addSubview:rightLine];
    rightLine.hidden = index == _stepNum - 1;
    
    //中半线
    UIView *midLine = [[UIView alloc] initWithFrame:CGRectMake(_itemWidth * .5 - .5, itemHeight * .5 + 15, 1, 10)];
    midLine.backgroundColor = _lineColor;
    [item addSubview:midLine];
}

#pragma mark：______________点击标尺item______________
- (void)itemClick:(UITapGestureRecognizer *)tap {
    
    NSInteger index = tap.view.tag;
    _currentIndex = index;
    CGFloat signX = _itemWidth * (index + .5) - 6;
    CGFloat signY = (SCREEN_HEIGTH * .2 - 50) * .5 + 10;
    
    if ([self.delegate respondsToSelector:@selector(willSelectItemWithIndex: withMark:)]) {
        [self.delegate willSelectItemWithIndex:index withMark:self.mark];
    }
    
    [UIView animateWithDuration:.25 animations:^{
        self.sign.frame = CGRectMake(signX, signY, 20, 20);
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(didSelectItemWithIndex: withMark:)]) {
            [self.delegate didSelectItemWithIndex:index withMark:self.mark];
        }
    }];
    
}

#pragma mark：______________拖动sign位置______________
- (void)moveSign:(UIPanGestureRecognizer *)pan {
    
    CGPoint point = [pan translationInView:pan.view];
    CGPoint realPoint = [pan.view convertPoint:point toView:self.view];
    NSInteger index = realPoint.x / _itemWidth;
    
    //移动到另外一个item时，执行代理方法
    if (index != _currentIndex) {
        _currentIndex = index;
        if ([self.delegate respondsToSelector:@selector(willSelectItemWithIndex: withMark:)]) {
            [self.delegate willSelectItemWithIndex:_currentIndex withMark:self.mark];
        }
    }
    
    //移动sign位置
    CGFloat signX = realPoint.x;
    if (realPoint.x < _itemWidth * .5 - 10) {
        signX = _itemWidth * .5 - 10;
    }else if (realPoint.x > _itemWidth * (_stepNum - .5) - 10) {
        signX = _itemWidth * (_stepNum - .5) - 10;
    }
    CGFloat signY = (SCREEN_HEIGTH * .2 - 50) * .5 + 10;
    _sign.frame = CGRectMake(signX, signY, 20, 20);
    [pan setTranslation:CGPointZero inView:pan.view];
    
    //手势结束时
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        
        CGFloat X = _itemWidth * (_currentIndex + .5) - 6;
        CGFloat Y = (SCREEN_HEIGTH * .2 - 50) * .5 + 10;
        
        [UIView animateWithDuration:.25 animations:^{
            self.sign.frame = CGRectMake(X, Y, 20, 20);
        } completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(didSelectItemWithIndex: withMark:)]) {
                [self.delegate didSelectItemWithIndex:self.currentIndex withMark:self.mark];
            }
        }];
    }
}

- (void)setDefaultIndex:(NSInteger )defaultIndex {
    _defaultIndex = defaultIndex;
    _setDefaultIndex = YES;  //防止在设置defaultIndex为0时，影响设置默认值，所以改用此BOOL值来判断设置默认值。
}

- (void)dismissVc {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//给系统提供 你要自定义的转场控制器
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source {
    
    DLPresentationController *presentStyle = [[DLPresentationController alloc] initWithPresentedViewController:presented presentingViewController:source];
    presentStyle.heightScale = .2;
    
    return presentStyle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


@implementation DLPresentationController

//容器视图 将要布局子控件
- (void)containerViewWillLayoutSubviews {
    
    
    //1.获取容器视图
    UIView *contanerView = self.containerView;
    
    //2.获取展示的控制器的View
    UIView *presentedView = self.presentedView;
    
    [contanerView addSubview:presentedView];
    
    //3.修改展示控制器的VIew的frame
    presentedView.frame = CGRectMake(0, SCREEN_HEIGTH * (1 - _heightScale), SCREEN_WIDTH, SCREEN_HEIGTH * _heightScale);
    
    //4.设置蒙板 改变透明度
    UIView *dimView = [[UIView alloc] initWithFrame:contanerView.frame];
    dimView.backgroundColor = [UIColor blackColor];
    dimView.alpha = 0.4;
    [contanerView insertSubview:dimView atIndex:0];
    
    //5.给蒙板添加tap手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [dimView addGestureRecognizer:tap];
}

//销毁控制器
- (void)tapAction:(UITapGestureRecognizer *)sender {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

