//
//  UIImage+XJ.h
//  YDJY
//
//  Created by YuehaoLXJ on 16/6/8.
//  Copyright © 2016年 yuehaojiaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extend)
/** 遮罩图片 */
- (UIImage *)m_imageMaskedWithColor:(UIColor *)maskColor;

/** 用颜色做图片 10*10 */
+ (UIImage *)m_imageWithColor:(UIColor *)color;

/** 用颜色做图片 rect */
+ (UIImage *)m_imageWithColor:(UIColor *)color rect:(CGRect)rect;

/** 用view创建*/
+ (UIImage *)m_imageWithUIView:(UIView *)view;

/** 获取launchImage*/
+ (UIImage *)getCurrentLaunchImage;

@end
