//
//  NKScanQRCodeView.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/6/2.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface NKScanQRCodeView : UIView

//开放给外部的参数
//二维码扫码界面
@property (nonatomic, strong) ZBarReaderView *readerView;
//扫描框
@property (nonatomic, strong) UIImageView *readerImageView;
//扫描线
@property (nonatomic, strong) UIImageView *readLineView;
//扫描线动画控制
@property (nonatomic,assign)BOOL is_Anmotion;
@property (nonatomic,assign)BOOL is_AnmotionFinished;
//实现代理方法的VC
@property (nonatomic, strong) UIViewController *vc;

//开始扫码
- (void)scanStart;
//结束扫码
- (void)scanStop;


@end
