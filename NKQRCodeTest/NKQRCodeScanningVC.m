//
//  NKQRCodeScanningVC.m
//  NKQRCodeTest
//
//  Created by Nick on 2017/6/8.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "NKQRCodeScanningVC.h"
#import "NKScanQRCodeView.h"
#import <AVFoundation/AVFoundation.h>

//界面的宽
#define WIDTH_VIEW [UIScreen mainScreen].bounds.size.width
//界面的高
#define HEIGHT_VIEW [UIScreen mainScreen].bounds.size.height

@interface NKQRCodeScanningVC ()<ZBarReaderViewDelegate>//实现代理方法

@property (nonatomic, strong) NKScanQRCodeView *scanQRCodeView;

@end

@implementation NKQRCodeScanningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initScanReaderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ZBarReaderView相关方法
//初始化扫描界面
- (void) initScanReaderView
{
    //创建二维码扫描界面
    _scanQRCodeView = [[NKScanQRCodeView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, HEIGHT_VIEW)];
    [self.view addSubview:_scanQRCodeView];
    _scanQRCodeView.vc = self;
    //设置代理
    _scanQRCodeView.readerView.readerDelegate = self;
    //关闭闪光灯
    _scanQRCodeView.readerView.torchMode = 0;
    //关闭手动聚焦
    _scanQRCodeView.readerView.allowsPinchZoom = NO;
    
    [_scanQRCodeView scanStart];
    
}
//扫描结束后回调函数
-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    //0.扫码完成后播放声音
    [self playSound:@"NKQRCode.bundle/sound.caf"];
    //1.停止扫描
    [_scanQRCodeView scanStop];
    //2.数据处理
    NSString *parameterStr;
    for (ZBarSymbol *symbol in symbols) {
        NSLog(@"%@", symbol.data);
        parameterStr = symbol.data;
        break;
    }
}
/** 播放音效文件 */
- (void)playSound:(NSString *)name {
    // 获取音效
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    // 1、获得系统声音ID
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    // 2、播放音频
    AudioServicesPlaySystemSound(soundID); // 播放音效
}
/** 播放完成回调函数 */
void soundCompleteCallback(SystemSoundID soundID, void *clientData){
    //SGQRCodeLog(@"播放完成...");
}

@end
