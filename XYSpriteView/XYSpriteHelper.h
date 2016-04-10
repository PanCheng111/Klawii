//
//  SpriteHelper.h
//
//  Created by Heaven on 13-5-15.
//
//

#define XYSpriteHelper_interval      1.0/4.0
#define XYSpriteHelper_timer         @"XYSprite"

#import "XYSpriteView.h"

@interface XYSpriteHelper : NSObject{
}

+ (XYSpriteHelper *)sharedInstance;

// 采用统一的定时器来刷新 sprite
@property (nonatomic, assign) NSTimeInterval                        interval;       // 定时器间隔
@property (nonatomic, readonly, strong) NSMutableDictionary         *sprites;       // 精灵

-(void) startTimer;      // 开期定时器
-(void) pauseTimer;
-(void) stopTimer;


-(void) startAllSprites;
-(void) stopAllSprites;
-(void) clearAllSprites;    // 从画面上移除所有的精灵, 清空sprites.
@end
