//
//  AppLaunchView.h
//  YDJY
//
//  Created by YuehaoHJ on 17/3/7.
//  Copyright © 2017年 yuehaojiaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AppLaunchViewClickLinkBlock)(NSString *);
typedef NS_ENUM(NSInteger, LaunchAnimType) {
    AppLauchAnimaFadeOut = 0,
    AppLauchAnimLite = 1,
    AppLaunchAnimCool,
};

@interface AppLaunchView : UIView

/**
 * 图片初始化
 * LaunchAnimType: 动画方式
 */
- (instancetype)initWithWindow:(UIWindow *)window launchType:(LaunchAnimType)launchType;
/**
 * 初始化
 * fileName: 本地视频文件名
 */
- (instancetype)initWithWindow:(UIWindow *)window launchVideoName:(NSString *)fileName;
/**显示*/
- (void)show;

/**网络图片、视频URL*/
@property(nonatomic ,copy) NSString *launchUrl;
/**本地图片文件名*/
@property(nonatomic ,copy) NSString *launchImageName;
/**点击回调*/
@property(nonatomic ,copy) AppLaunchViewClickLinkBlock launchViewClickLinkBlock;
/**倒计时时长*/
@property(nonatomic ,assign) NSUInteger launchTime;
/**隐藏倒计时按钮*/
@property(nonatomic ,getter=isHiddenButtonTime) BOOL hiddenButtonTime;
//占位图片,如果是gif需要传gif 是静态图只需要传静态图 如果不传默认的是启动图片
@property(nonatomic ,copy) NSString *placerHodelImage;
/**清除图片缓存*/
- (void)clearCacheImage;
/**清除视频缓存*/
- (void)clearCacheVideo;

@end
