//
//  ViewController.m
//  MagicPlay
//
//  Created by 潘成 on 16/4/9.
//  Copyright © 2016年 潘成. All rights reserved.
//

#import "ViewController.h"
#import "CRMotionView.h"
#import "XYSpriteHelper.h"
#import "UMCommunity.h"
#import "EAIntroView.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //CRMotionView *motionView = [[CRMotionView alloc] initWithFrame:self.view.bounds AndStringFormat:@"thumb_IMG_%d_1024.jpg" From:5589 AndCount:130 ByFirstImage:[UIImage imageNamed:@"Image"]];
    //[self.view addSubview:motionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"ViewController start timer");
    [[XYSpriteHelper sharedInstance] startTimer];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"ViewController top timer");
    [[XYSpriteHelper sharedInstance] stopTimer];
}


@end
