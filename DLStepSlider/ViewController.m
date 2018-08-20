//
//  ViewController.m
//  DLStepSlider
//
//  Created by Donglei on 2018/3/16.
//  Copyright © 2018年 Qianyuanhengye. All rights reserved.
//

#import "ViewController.h"
#import "DLStepSlider.h"

@interface ViewController ()<DLStepSliderDelegate>

@property (nonatomic, strong) UILabel *text;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, CGRectGetWidth(self.view.frame), 30)];
    text.font = [UIFont systemFontOfSize:14];
    text.textAlignment = NSTextAlignmentCenter;
    _text = text;
    [self.view addSubview:text];
    text.text = @"风到这里就是粘，黏住过客的思念";
    text.textColor = [UIColor darkGrayColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    DLStepSlider *vc = [[DLStepSlider alloc] init];
    vc.stepNum = 5;
    vc.delegate = self;
    vc.lineColor = [UIColor redColor];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)willSelectItemWithIndex:(NSInteger)index {
    NSLog(@"即将选择第%ld个item",index);
    _text.font = [UIFont systemFontOfSize:13 + index];
    _text.textColor = [UIColor colorWithRed:index * .1 green:index * .2 blue: index * .3 alpha:1];
}

- (void)didSelectItemWithIndex:(NSInteger)index {
    NSLog(@"已经选择第%ld个item",index);
}

- (NSString *)titleAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"%ld",13 + index];
}

- (UIFont *)titleFontAtIndex:(NSInteger)index {
    return [UIFont systemFontOfSize:13 + index];
}

- (UIColor *)titleColorAtIndex:(NSInteger)index {
    return [UIColor colorWithRed:index * .1 green:index * .2 blue: index * .3 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
