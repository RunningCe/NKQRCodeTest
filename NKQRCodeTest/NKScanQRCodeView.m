//
//  NKScanQRCodeView.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/6/2.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "NKScanQRCodeView.h"
#import "Masonry.h"

//界面的宽
#define WIDTH_VIEW [UIScreen mainScreen].bounds.size.width
//界面的高
#define HEIGHT_VIEW [UIScreen mainScreen].bounds.size.height
//半透明背景色
#define COLOR_BACKBLACK_TRANSPARENT [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]

@implementation NKScanQRCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self =  [super initWithFrame:frame])
    {
        [self initSubViews];
        [self initReaderView];
        _is_AnmotionFinished = YES;
    }
    return self;
}
//初始化界面
- (void)initSubViews
{
    //二维码扫描界面
    _readerView = [ZBarReaderView new];
    [self addSubview:_readerView];
    [_readerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(WIDTH_VIEW, HEIGHT_VIEW));
    }];
    //imageView
    UIImageView *readerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanframe"]];
    self.readerImageView = readerImageView;
    [self addSubview:readerImageView];
    [readerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).multipliedBy(0.9);
        make.size.mas_equalTo(CGSizeMake(220, 220));
    }];
    //边背景view
    UIView *buttonBaseView = [[UIView alloc] init];
    buttonBaseView.backgroundColor = COLOR_BACKBLACK_TRANSPARENT;
    [self addSubview:buttonBaseView];
    [buttonBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(WIDTH_VIEW, 91));
    }];
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = COLOR_BACKBLACK_TRANSPARENT;
    [self addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(readerImageView.mas_left);
        make.bottom.equalTo(buttonBaseView.mas_top);
    }];
    UIView *rightView = [[UIView alloc] init];
    rightView.backgroundColor = COLOR_BACKBLACK_TRANSPARENT;
    [self addSubview: rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(readerImageView.mas_right);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(buttonBaseView.mas_top);
    }];
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = COLOR_BACKBLACK_TRANSPARENT;
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(leftView.mas_right);
        make.bottom.equalTo(readerImageView.mas_top);
        make.right.equalTo(rightView.mas_left);
    }];
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = COLOR_BACKBLACK_TRANSPARENT;
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(readerImageView.mas_bottom);
        make.left.equalTo(leftView.mas_right);
        make.bottom.equalTo(buttonBaseView.mas_top);
        make.right.equalTo(rightView.mas_left);
    }];
    //扫描二维码提示
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 14)];
    [bottomView addSubview:msgLabel];
    msgLabel.text = @"将二维码放到区域内自动扫描";
    msgLabel.textColor = [UIColor whiteColor];
    msgLabel.font = [UIFont systemFontOfSize:14.0];
    [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_equalTo(14.0);
    }];
}
//初始化ZBarReaderView
- (void)initReaderView
{
    //扫描区域
    CGRect scanMaskRect = CGRectMake(60,CGRectGetMidY(self.readerView.frame) - 126, 300, 300);
    //处理模拟器
    if (TARGET_IPHONE_SIMULATOR)
    {
        ZBarCameraSimulator *cameraSimulator
        = [[ZBarCameraSimulator alloc] initWithViewController:self.vc];
        cameraSimulator.readerView = self.readerView;
    }
    //扫描区域计算
    self.readerView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:self.readerView.bounds];
}
//创建扫描条
-(void)loopDrawLine
{
    _is_AnmotionFinished = NO;
    CGRect rect = CGRectMake(5, 10, _readerImageView.frame.size.width - 10, 2);
    if (_readLineView) {
        _readLineView.alpha = 1;
        _readLineView.frame = rect;
    }
    else{
        _readLineView = [[UIImageView alloc] initWithFrame:rect];
        [_readLineView setImage:[UIImage imageNamed:@"scanLine"]];
        [_readerImageView addSubview:_readLineView];
    }
    
    [UIView animateWithDuration:1.5 animations:^{
        _readLineView.frame =CGRectMake(5, _readerImageView.frame.size.height - 10, _readerImageView.frame.size.width - 10, 2);
    } completion:^(BOOL finished) {
        if (!_is_Anmotion) {
            [self loopDrawLine];
        }
        _is_AnmotionFinished = YES;
    }];
}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    return CGRectMake(x,y, width, height);
}

- (void)scanStart
{
    _is_Anmotion = NO;
    
    if (_is_AnmotionFinished) {
        [self loopDrawLine];
    }
    [self.readerView start];
}
- (void)scanStop
{
    _is_Anmotion = YES;
    
    if (_is_AnmotionFinished) {
        [self loopDrawLine];
    }
    [self.readerView stop];
}


@end
