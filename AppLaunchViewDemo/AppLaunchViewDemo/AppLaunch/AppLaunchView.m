//
//  AppLaunchView.m
//  YDJY
//
//  Created by YuehaoHJ on 17/3/7.
//  Copyright © 2017年 yuehaojiaoyu. All rights reserved.
//

#import "AppLaunchView.h"
#import "FLAnimatedImage.h"
#import "UIImage+Extend.h"
#import "CALayer+Cool.h"
#import <CommonCrypto/CommonDigest.h>

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

#define ScreenWidth                   [UIScreen mainScreen].bounds.size.width
#define ScreenHeight                  [UIScreen mainScreen].bounds.size.height

@interface AppLaunchView ()
{
    UIWindow          *_currentWindow;
    NSTimer           *_launchTimer;
    NSURL             *_movieURL;
    LaunchAnimType    _launchType;
}

@property(nonatomic, strong) MPMoviePlayerController *player;

@property(nonatomic, strong) UIButton  *buttonSkip;
@property(nonatomic, strong) UIButton  *buttonPush;
@property(nonatomic, strong) FLAnimatedImageView *imageViewGif;
@property(nonatomic, weak) FLAnimatedImage *animtedImage;
@property(nonatomic, copy) NSString *localDirectory;
@property(nonatomic, assign) BOOL isImageType;

@end

@implementation AppLaunchView

-(void)dealloc
{
    self.imageViewGif = nil;
    self.animtedImage = nil;
    self.player = nil;
}

- (instancetype)initWithWindow:(UIWindow *)window launchType:(LaunchAnimType)launchType{
    if(self = [super init]){
        _launchTime    = 4;
        _launchType    = launchType;
        _currentWindow = window;
        _isImageType = YES;
        [self setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self setup];
    }
    return self;
}

- (instancetype)initWithWindow:(UIWindow *)window launchVideoName:(NSString *)fileName
{
    if(self = [super init]){
        _currentWindow = window;
        _isImageType = NO;
        _movieURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        [self setBackgroundColor:[UIColor blackColor]];
        [self setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self setupVideoPlayer];
    }
    return self;
}

- (void)setupVideoPlayer
{
    [_currentWindow makeKeyAndVisible];
    _player = [[MPMoviePlayerController alloc] init];
    _player.shouldAutoplay = YES;
    _player.controlStyle = MPMovieControlStyleNone;
    _player.repeatMode = MPMovieRepeatModeOne;
    _player.view.frame = _currentWindow.bounds;
    _player.view.alpha = 0;
    [self addSubview:_player.view];
    [self addSubview:self.buttonPush];
}

- (void)setup
{
    [_currentWindow makeKeyAndVisible];
    self.imageViewGif.frame = self.frame;
    [self.imageViewGif setImage:[UIImage getCurrentLaunchImage]];
    [self addSubview:self.imageViewGif];
    [self addSubview:self.buttonSkip];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionClickAd)]];
}

- (void)show
{
    [_currentWindow addSubview:self];
    
    if (_isImageType) {
        [self startTimer];
    }else {
        _player.contentURL = _movieURL;
        [UIView animateWithDuration:2 animations:^{
            _player.view.alpha = 1;
            [_player prepareToPlay];
        }];
    }
}

- (void)startTimer
{
    _launchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(closeLaunch) userInfo:nil repeats:YES];
}

- (void)closeLaunch{
    if (_launchTime == 0) {
        [self actionSkip];
    }else{
        _launchTime--;
        NSString *stringCount = [NSString stringWithFormat:@"%lu",(unsigned long)_launchTime];
        [self.buttonSkip setTitle:stringCount forState:UIControlStateNormal];
    }
}

#pragma mark - setting && getting
- (UIButton *)buttonSkip{
    if (!_buttonSkip) {
        NSString *stringCount = [NSString stringWithFormat:@"%lu",(unsigned long)_launchTime];
        _buttonSkip = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonSkip setTitle:stringCount forState:UIControlStateNormal];
        [_buttonSkip setBackgroundImage:[UIImage imageNamed:@"launchSkip"] forState:UIControlStateNormal];
        [_buttonSkip addTarget:self action:@selector(actionSkip) forControlEvents:UIControlEventTouchUpInside];
        [_buttonSkip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonSkip setFrame:CGRectMake(ScreenWidth - 69, 32, 45, 45)];
        [_buttonSkip.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
        [_buttonSkip setTitleEdgeInsets:UIEdgeInsetsMake(-10, -10, 8, -10)];
    }
    return _buttonSkip;
}

- (UIButton *)buttonPush{
    if (!_buttonPush) {
        _buttonPush = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonPush setBackgroundImage:[UIImage imageNamed:@"go_selected"] forState:UIControlStateNormal];
        [_buttonPush addTarget:self action:@selector(actionPush) forControlEvents:UIControlEventTouchUpInside];
        [_buttonPush setFrame:CGRectMake((ScreenWidth - 125) / 2, ScreenHeight * 0.8, 125, 45)];
    }
    return _buttonPush;
}

- (FLAnimatedImageView *)imageViewGif{
    if (!_imageViewGif) {
        _imageViewGif = [[FLAnimatedImageView alloc] init];
        _imageViewGif.loopCompletionBlock = ^(NSUInteger index){
        };
        _imageViewGif.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageViewGif;
}

-(void)setHiddenButtonTime:(BOOL)hiddenButtonTime
{
    _hiddenButtonTime = hiddenButtonTime;
    self.buttonSkip.hidden = hiddenButtonTime;
}

- (void)setLaunchImageName:(NSString *)launchImageName{
    _launchImageName = launchImageName;
    if (_launchImageName) {
        if ([_launchImageName rangeOfString:@".gif"].location != NSNotFound) {
            if (!self.animtedImage) {
                NSURL *urlString = [[NSBundle mainBundle] URLForResource:launchImageName withExtension:nil];
                NSData *dataGif = [NSData dataWithContentsOfURL:urlString];
                FLAnimatedImage *animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:dataGif];
                self.animtedImage = animatedImage1;
                self.imageViewGif.animatedImage = animatedImage1;
            }
        }else{
            self.imageViewGif.image = [UIImage imageNamed:launchImageName];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self bringSubviewToFront:self.buttonSkip];
        });
    }
}

- (void)setLaunchUrl:(NSString *)launchUrl{
    _launchUrl =  launchUrl;
    
    NSString *bundlePath = [[NSBundle mainBundle]pathForResource:launchUrl.lastPathComponent ofType:nil];
    if ([launchUrl isEqualToString:bundlePath]) { //如果是放在bundle路径下
        if (!_isImageType) _movieURL = [NSURL fileURLWithPath:launchUrl];
    }else {
        if (launchUrl) {
            [self createLocalDirectory];
            NSURL *urlString = [NSURL URLWithString:launchUrl];
            
            if (_isImageType) {
                if ([_launchUrl rangeOfString:@".gif"].location != NSNotFound) {
                    [self loadAnimatedImageWithURL:urlString completion:^(FLAnimatedImage *animatedImage) {
                        self.imageViewGif.animatedImage = animatedImage;
                        self.imageViewGif.userInteractionEnabled = YES;
                    }];
                }else{
                    [self loadImageWithUrl:urlString completion:^(UIImage *imageIcon) {
                        self.imageViewGif.image = imageIcon;
                        self.imageViewGif.userInteractionEnabled = YES;
                    }];
                }
            }else {
                [self loadVideoWithUrl:urlString];
            }
        }
    }
}

- (void)setPlacerHodelImage:(NSString *)placerHodelImage{
    _placerHodelImage = placerHodelImage;
}

#pragma mark - action
- (void)actionSkip{
    [self.imageViewGif stopAnimGif];
    [_launchTimer invalidate];
    _launchTimer = nil;
    [self cancelAnimType];
}

- (void)actionPush{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            _player.view.alpha = 0;
            self.alpha = 0;
        }completion:^(BOOL finished) {
            [_player pause];
            [_player setEndPlaybackTime:-1];
            [_player.view removeFromSuperview];
            [self removeFromSuperview];
        }];
    });
}

- (void)actionClickAd{
    if (_launchViewClickLinkBlock) {
        _launchViewClickLinkBlock(_launchUrl);
    }
    [self clearCacheImage];
}

- (void)cancelAnimType{
    if (_launchType == AppLauchAnimLite) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1 animations:^{
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                self.imageViewGif.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        });
    }else if (_launchType == AppLaunchAnimCool){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.window.layer transitionWithAnimType:TransitionAnimTypeReveal subType:TransitionSubtypesFromRight curve:TransitionCurveLinear duration:1.0];
            [self removeFromSuperview];
        });
    }else if (_launchType == AppLauchAnimaFadeOut) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1 animations:^{
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                self.imageViewGif.alpha = 0;
                self.buttonSkip.alpha = 0;
            }completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        });
        
    }
}


#pragma mark---------loadImage----------------------
- (void)loadAnimatedImageWithURL:(NSURL *const)url completion:(void (^)(FLAnimatedImage *animatedImage))completion
{
    NSString *const filename = url.lastPathComponent;
    NSData * __block animatedImageData = [[NSFileManager defaultManager] contentsAtPath:[self pathOnDiskForName:filename]];
    FLAnimatedImage * __block animatedImage = nil;
    if (animatedImageData) {
        animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedImageData];
        if (completion) {
            completion(animatedImage);
        }
    } else {
        if (_placerHodelImage) {
            NSURL *urlString = [[NSBundle mainBundle] URLForResource:_placerHodelImage withExtension:nil];
            NSData *dataGif = [NSData dataWithContentsOfURL:urlString];
            animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:dataGif];
            if (completion) {
                completion(animatedImage);
            }
        }else{
            if (completion) {
                completion(nil);
            }
        }
        [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 异步操作
                NSData * data = [NSData dataWithContentsOfURL:url];
                [self saveImageFromName:filename image:data];
            });
        }] resume];
    }
}

- (void)loadImageWithUrl:(NSURL *const)url completion:(void (^)(UIImage *imageIcon))completion{
    NSString *const filename = url.lastPathComponent;
    NSData * __block imageData = [[NSFileManager defaultManager] contentsAtPath:[self pathOnDiskForName:filename]];
    if (imageData) {
        if (completion) {
            completion( [UIImage imageWithData:imageData]);
        }
    }else{
        if (completion) {
            completion(_placerHodelImage?[UIImage imageNamed:_placerHodelImage]:[UIImage getCurrentLaunchImage]);
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 异步操作
            NSData * data = [NSData dataWithContentsOfURL:url];
            [self saveImageFromName:filename image:data];
        });
    }
}


- (void)loadVideoWithUrl:(NSURL *const)url
{
    NSString *const filename = url.lastPathComponent;
    if ([self isFileExist:filename]) {
        _movieURL = [NSURL fileURLWithPath:[self.localDirectory stringByAppendingPathComponent:filename]];
    }else {
        _movieURL = [NSURL URLWithString:_launchUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
            if (!error) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    if(data) [data writeToFile:[self.localDirectory stringByAppendingPathComponent:filename] options:NSAtomicWrite error:nil];
                });
                
            } else {
                NSLog(@"error is %@", error.localizedDescription);
            }
        }] resume];
    }
}

#pragma mark - 存放image的文件夹路径
- (NSString *) localDirectory
{
    if (_localDirectory == nil) {
        _localDirectory = [NSString stringWithFormat:@"%@/LaunchCache", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]];
    }
    return _localDirectory;
}

#pragma mark - 文件是否存在目录下
-(BOOL)isFileExist:(NSString *)fileName
{
    NSString *filePath = [self.localDirectory stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

#pragma mark - 创建缓存图片文件目录
- (void) createLocalDirectory
{
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:self.localDirectory] ) {
        NSError *error;
        
        if ( ![[NSFileManager defaultManager] createDirectoryAtPath:self.localDirectory withIntermediateDirectories:YES attributes:nil error:&error] ) {
            NSLog(@"[%@] ERROR: attempting to write create MyFolder directory", [self class]);
            NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
        }
    }
}

- (BOOL)saveImageFromName:(NSString *)imageName image:(NSData *)imageData{
    if (!imageData) return NO;
    
    [imageData writeToFile:[self pathOnDiskForName:imageName] options:NSAtomicWrite error:nil];
    return YES;
}

#pragma mark - image名字MD5加密后的路径
- (NSString *) pathOnDiskForName:(NSString *)imageName
{
    return [self.localDirectory stringByAppendingPathComponent:[self md5:imageName]];
}

#pragma mark - md5加密
- (NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    if (cStr == NULL) {
        cStr = "";
    }
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (void)clearCacheImage{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[self pathOnDiskForName:_launchUrl.lastPathComponent] error:&error];
    if ( ![[NSFileManager defaultManager] createDirectoryAtPath:self.localDirectory withIntermediateDirectories:NO attributes:nil error:&error] )
        return;
}

- (void)clearCacheVideo{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[self.localDirectory stringByAppendingPathComponent:_launchUrl.lastPathComponent] error:&error];
    if ( ![[NSFileManager defaultManager] createDirectoryAtPath:self.localDirectory withIntermediateDirectories:NO attributes:nil error:&error] )
        return;
}

@end
