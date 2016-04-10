//  Created by Heaven on 13-5-15.
//
//


#import "XYSpriteHelper.h"

@interface XYSpriteHelper()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation XYSpriteHelper{
    
}

+ (XYSpriteHelper *)sharedInstance
{
    static dispatch_once_t once;
    static XYSpriteHelper * __singleton__;
    dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } );
    return __singleton__;
}

-(id)init{
    self = [super init];
    if (self) {
        _sprites = [[NSMutableDictionary alloc] initWithCapacity:5];
        self.interval = 1.0/12.0;
    }
    return self;
}
-(void)dealloc{
}

-(void)startTimer{
    [self stopTimer];

    _timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:XYSpriteHelper_interval target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void) pauseTimer{
    if (_timer.isValid){
        [_timer invalidate];
    }
}
-(void)stopTimer{
    if (_timer.isValid){
        [_timer invalidate];
    }
}

-(void)clearAllSprites{
    [self.sprites enumerateKeysAndObjectsUsingBlock:^(id key, XYSpriteView *ani, BOOL *stop) {
        [ani removeFromSuperview];
    }];
    [self.sprites removeAllObjects];
}
-(void) startAllSprites{
    [self.sprites enumerateKeysAndObjectsUsingBlock:^(id key, XYSpriteView *ani, BOOL *stop) {
        [ani start];
    }];
}
-(void) stopAllSprites{
    [self.sprites enumerateKeysAndObjectsUsingBlock:^(id key, XYSpriteView *ani, BOOL *stop) {
        [ani stop];
    }];
}

- (void)updateSprites{
    if (self.sprites.count == 0) return;
    
    [self.sprites enumerateKeysAndObjectsUsingBlock:^(id key, XYSpriteView *ani, BOOL *stop) {
        [ani updateTimer:_interval];
       // [ani updateImage];
    }];
}
#define mark - XYTimerDelegate

-(void) handleTimer:(NSTimer *)timer{
    [self updateSprites];
}

#pragma mark -
@end
