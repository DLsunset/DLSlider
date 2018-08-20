//
//  DLStepSlider.h
//  html
//
//  Created by Qianyuanhengye on 2018/3/16.
//  Copyright © 2018年 Qianyuanhengye. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  DLStepSliderDelegate <NSObject>

@optional

- (void)willSelectItemWithIndex:(NSInteger )index;
- (void)didSelectItemWithIndex:(NSInteger )index;
- (UIFont *)titleFontAtIndex:(NSInteger )index;
- (UIColor *)titleColorAtIndex:(NSInteger )index;
- (NSString *)titleAtIndex:(NSInteger )index;

@end

@interface DLStepSlider : UIViewController

/**
 可调整级数，默认为4, 推荐数值(2 ~ 7),理论可超过7，但过于拥挤
 */
@property (nonatomic, assign) NSInteger stepNum;

/**
 标尺线的颜色，默认为蓝色
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 标题字号，默认为14
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 标题颜色，默认为深灰
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 标准位置，默认是1, (0 ~ stepNum - 1 )
 */
@property (nonatomic, assign) NSInteger defaultIndex;

/**
 当前位置
 */
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, weak) id <DLStepSliderDelegate>delegate;

@end


@interface DLPresentationController : UIPresentationController

/**
 控制器高度占整个屏幕高度的比例，（0 ~ 1）
 */
@property (nonatomic, assign) CGFloat heightScale;

@end
