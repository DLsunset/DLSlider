//
//  ViewController.m
//  DLSlider
//
//  Created by qyhy on 2018/8/20.
//  Copyright © 2018年 QYhengye. All rights reserved.
//

#import "ViewController.h"
#import "DLSlider.h"
@interface ViewController ()<DLSliderDelegate>

@property (nonatomic, strong) UITextView *text;
@property (nonatomic, assign) NSInteger selectIndex1;
@property (nonatomic, assign) NSInteger selectIndex2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(20, 40,w - 40, 500)];
    _text = text;
    text.text = @"风到这里就是黏\n黏住过客的思念\n雨到了这里缠成线\n缠着我们留恋人世间\n你在身边就是缘\n缘分写在三生石上面\n爱有万分之一天\n宁愿我就葬在这一天\n圈圈圆圆圈圈 天天年年天天的我\n深深看你的脸\n生气的温柔 埋怨的温柔 的脸\n不懂爱恨情仇煎熬的我们\n都以为相爱就像风云的善变\n相信爱一天 抵过永远\n在这一刹那冻结了时间\n不懂怎么表现温柔的我们\n还以为殉情只是古老的传言\n离愁能有多痛 痛有多浓\n当梦被埋在江南烟雨中\n心碎了才懂";
    text.font = [UIFont systemFontOfSize:16];
    text.editable = NO;
    [self.view addSubview:text];
    
    UIButton *changeFont = [[UIButton alloc] initWithFrame:CGRectMake(w * .5 + 50, 550 , 44, 44)];
    changeFont.tag = 101;
    [changeFont addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    [changeFont setTitle:@"Aa" forState:UIControlStateNormal];
    [changeFont setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:changeFont];
    
    UIButton *changeColor = [[UIButton alloc] initWithFrame:CGRectMake(w * .5 - 94, 550 , 44, 44)];
    changeColor.tag = 102;
    [changeColor addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    [changeColor setTitle:@"Color" forState:UIControlStateNormal];
    [changeColor setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:changeColor];
    
    _selectIndex1 = 1;
    _selectIndex2 = 1;
}

- (void)changeAction:(UIButton *)sender {
    
    DLSlider *slider = [[DLSlider alloc] init];
    slider.mark = sender.tag;
    slider.delegate = self;
    slider.stepNum = sender.tag == 101 ? 6 : 7;
    slider.lineColor = [UIColor darkGrayColor];
    slider.defaultIndex = sender.tag == 101 ? _selectIndex1 : _selectIndex2;
    //若实现了相关代理，这两个属性的设置会被覆盖。
    slider.titleFont = [UIFont systemFontOfSize:16];
    slider.titleColor = [UIColor cyanColor];
    
    [self presentViewController:slider animated:YES completion:nil];
    
}

- (void)willSelectItemWithIndex:(NSInteger)index withMark:(NSInteger)mark{
    NSLog(@"即将选择第%ld个item",index);
    switch (mark) {
        case 101:
            _text.font = [UIFont systemFontOfSize:15 + index];
            break;
        case 102:
            _text.textColor = [UIColor colorWithRed:index * .3 green:index * .2 blue: index * .1 alpha:1];
            break;
        default:
            break;
    }
}

- (void)didSelectItemWithIndex:(NSInteger)index withMark:(NSInteger)mark{
    NSLog(@"已经选择第%ld个item",index);
    switch (mark) {
        case 101:
            _selectIndex1 = index;
            break;
        case 102:
            _selectIndex2 = index;
            break;
        default:
            break;
    }
}

- (NSString *)titleAtIndex:(NSInteger)index withMark:(NSInteger)mark{
    switch (mark) {
        case 101:
            return [NSString stringWithFormat:@"%ld",15 + index];
            break;
        case 102:
            return @"Color";
            break;
        default:
            return @"";
            break;
    }
}

//滑尺没个item的名字
- (UIFont *)titleFontAtIndex:(NSInteger)index withMark:(NSInteger)mark{
    switch (mark) {
        case 101:
            return [UIFont systemFontOfSize:15 + index];
            break;
        case 102:
            return [UIFont systemFontOfSize:16];
            break;
        default:
            return [UIFont systemFontOfSize:16];
            break;
    }
}

- (UIColor *)titleColorAtIndex:(NSInteger)index withMark:(NSInteger)mark{
    switch (mark) {
        case 101:
            return [UIColor darkGrayColor];
            break;
        case 102:
            return [UIColor colorWithRed:index * .3 green:index * .2 blue: index * .1 alpha:1];
            break;
        default:
            return [UIColor darkGrayColor];
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
