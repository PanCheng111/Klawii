//
//  CRMotionView.m
//  CRMotionView
//
//  Created by Christian Roman on 06/02/14.
//  Copyright (c) 2014 Christian Roman. All rights reserved.
//

#import "CRMotionView.h"
#import "UIScrollView+CRScrollIndicator.h"
#import "XYSpriteView.h"
#import "XYSpriteHelper.h"

@import CoreMotion;

static const CGFloat CRMotionViewRotationMinimumTreshold = 0.1f;
static const CGFloat CRMotionGyroUpdateInterval = 1 / 100;
static const CGFloat CRMotionViewRotationFactor = 4.0f;

@interface CRMotionView ()<XYSpriteDelegate>

@property (nonatomic, assign) CGRect viewFrame;

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XYSpriteView *imageView;

@property (nonatomic, assign) CGFloat motionRate;
@property (nonatomic, assign) NSInteger minimumXOffset;
@property (nonatomic, assign) NSInteger maximumXOffset;

@end

@implementation CRMotionView

- (id)initWithFrame:(CGRect)frame AndStringFormat:(NSString *)format From:(int)firstIndex AndCount:(int)count ByFirstImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewFrame = frame;
        _image = image;
        [self commonInitWithFirstIndex:firstIndex AndCount:count AndFormat:format];
    }
    return self;
}

- (void)commonInitWithFirstIndex:(int)index AndCount:(int)count AndFormat:(NSString *)format
{
    _scrollView = [[UIScrollView alloc] initWithFrame:_viewFrame];
    [_scrollView setUserInteractionEnabled:NO];
    [_scrollView setBounces:NO];
    [_scrollView setContentSize:CGSizeZero];
    [self addSubview:_scrollView];
    
    _imageView = [[XYSpriteView alloc] initWithFrame:_viewFrame];
    CGFloat width = _viewFrame.size.height / _image.size.height * _image.size.width;
    [_imageView setFrame:CGRectMake(0, 0, width, _viewFrame.size.height)];
    [_imageView setBackgroundColor:[UIColor blackColor]];
    _imageView.firstImgIndex = index;
    [_imageView formatImg:format count:count repeatCount:0];
    [_imageView showImgWithIndex:0];
    _imageView.delegate = self;
    [[XYSpriteHelper sharedInstance].sprites setObject:_imageView forKey:@"a"];
    [[XYSpriteHelper sharedInstance] startAllSprites];
    [_scrollView addSubview:_imageView];
    
    _minimumXOffset = 0;
    _scrollView.contentSize = CGSizeMake(_imageView.frame.size.width, _scrollView.frame.size.height);
    _scrollView.contentOffset = CGPointMake((_scrollView.contentSize.width - _scrollView.frame.size.width) / 2, 0);
    
    [_scrollView cr_enableScrollIndicator];
    
    _motionRate = _image.size.width / _viewFrame.size.width * CRMotionViewRotationFactor;
    _maximumXOffset = _scrollView.contentSize.width - _scrollView.frame.size.width;
    
    [self startMonitoring];
    
}

#pragma mark - Setters

- (void)setMotionEnabled:(BOOL)motionEnabled
{
    _motionEnabled = motionEnabled;
    if (_motionEnabled) {
        [self startMonitoring];
    } else {
        [self stopMonitoring];
    }
}

#pragma mark - Core Motion

- (void)startMonitoring
{
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.gyroUpdateInterval = CRMotionGyroUpdateInterval;
        _motionManager.accelerometerUpdateInterval = 0.10; // 告诉manager，更新频率是100Hz
    }
    
    if (![_motionManager isGyroActive] && [_motionManager isGyroAvailable]) {
        [_motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        CGFloat rotationRate = gyroData.rotationRate.y;
                                        if (fabs(rotationRate) >= CRMotionViewRotationMinimumTreshold) {
                                            CGFloat offsetX = _scrollView.contentOffset.x - rotationRate * _motionRate;
                                            if (offsetX > _maximumXOffset) {
                                                offsetX = _maximumXOffset;
                                            } else if (offsetX < _minimumXOffset) {
                                                offsetX = _minimumXOffset;
                                            }
                                            [UIView animateWithDuration:0.3f
                                                                  delay:0.0f
                                                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                                                             animations:^{
                                                                 [_scrollView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
                                            }
                                                             completion:nil];
                                        }
                                    }];
    } else {
        NSLog(@"There is not available gyro.");
    }
    
    if (!_motionManager.accelerometerAvailable) {
        NSLog(@"没有加速计");
    }
    //distance=0;
    
    [_motionManager startDeviceMotionUpdates];
    [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *latestAcc, NSError *error)
     {
         double gravityX = _motionManager.deviceMotion.gravity.x;
         double gravityY = _motionManager.deviceMotion.gravity.y;
         double gravityZ = _motionManager.deviceMotion.gravity.z;
         double zTheta = fabs(atan2(gravityZ,sqrtf(gravityX*gravityX+gravityY*gravityY))/M_PI*180.0);
         //NSLog(@"Z Theta: %.2lf", zTheta);
         if (zTheta > 45.0) {
            // [XYSpriteHelper sharedInstance].interval = zTheta/1080;
             [[XYSpriteHelper sharedInstance] startTimer];
         }
         else {
             [[XYSpriteHelper sharedInstance] pauseTimer];
         }
     }];
    

}

- (void)stopMonitoring
{
    [_motionManager stopGyroUpdates];
    [_motionManager stopDeviceMotionUpdates];
}

- (void)dealloc
{
    [self.scrollView cr_disableScrollIndicator];
}

#pragma mark -XYSpriteDelegate
-(void) spriteOnIndex:(int)aIndex sprite:(XYSpriteView *)aSprite{
    if (aIndex == 1) {
        //_count++;
        //_labText.text = [NSString stringWithFormat:@"%d", _count];
    }
}
-(void) spriteWillStart:(XYSpriteView *)aSprite{
    NSLog(@"spriteWillStart %@,", aSprite);
}

@end
