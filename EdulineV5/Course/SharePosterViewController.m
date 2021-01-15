//
//  SharePosterViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/15.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "SharePosterViewController.h"
#import "V5_Constant.h"
#import "Net_Path.h"

@interface SharePosterViewController ()

@property (strong, nonatomic) UIImageView *posterImageView;
@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UIImageView *courseFace;
@property (strong, nonatomic) UILabel *courseTitle;
@property (strong, nonatomic) UILabel *coursePricelabel;
@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIImageView *teacherFace;
@property (strong, nonatomic) UILabel *teacherName;
@property (strong, nonatomic) UILabel *fromLabel;
@property (strong, nonatomic) UIImageView *codeImageView;

@end

@implementation SharePosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = EdlineV5_Color.backColor;
    _titleLabel.text = @"分享";
    
    _posterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 285, 456)];
    _posterImageView.centerY = MainScreenHeight / 2.0 - 43 / 2.0;
    _posterImageView.centerX = MainScreenWidth / 2.0; // 127 84
    _posterImageView.image = Image(@"share_bg");
    [self.view addSubview:_posterImageView];
    
    [self makeShareContentUI];
    
    [self GetCodeImage];
    
    [self makeBottomView];
}

// MARK: - 布局分享内容
- (void)makeShareContentUI {
    
    _courseFace = [[UIImageView alloc] initWithFrame:CGRectMake(_posterImageView.left + 27.5, _posterImageView.top + 78, 230, 124)];
    _courseFace.layer.masksToBounds = YES;
    _courseFace.layer.cornerRadius = 5;
    _courseFace.backgroundColor = EdlineV5_Color.faildColor;
    [self.view addSubview:_courseFace];
    
    _courseTitle = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.left, _courseFace.bottom + 10, _courseFace.width, 38)];
    _courseTitle.font = SYSTEMFONT(15);
    _courseTitle.textColor = EdlineV5_Color.textFirstColor;
    _courseTitle.numberOfLines = 2;
    _courseTitle.text = @"初中英语阅读理解+完形填空初中英语阅读理解";
    [self.view addSubview:_courseTitle];
    
    _coursePricelabel = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.left, _courseTitle.bottom + 10, _courseFace.width, 19)];
    _coursePricelabel.font = SYSTEMFONT(15);
    _coursePricelabel.textColor = EdlineV5_Color.faildColor;
    _coursePricelabel.text = [NSString stringWithFormat:@"%@1200.00",IOSMoneyTitle];
    [self.view addSubview:_coursePricelabel];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.left, _coursePricelabel.bottom + 9, _courseFace.width, 19)];
    _tipLabel.font = SYSTEMFONT(9);
    _tipLabel.textColor = EdlineV5_Color.textThirdColor;
    NSString *tipPrice = [NSString stringWithFormat:@"%@12",IOSMoneyTitle];
    NSString *tipText = [NSString stringWithFormat:@"每成功邀请一名用户预计最多收入 %@",tipPrice];
    NSMutableAttributedString *atr1 = [[NSMutableAttributedString alloc] initWithString:tipText];
    [atr1 addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.faildColor,NSFontAttributeName:SYSTEMFONT(11)} range:[tipText rangeOfString:tipPrice]];
    _tipLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:atr1];
    [self.view addSubview:_tipLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_courseFace.left, _tipLabel.bottom + 5, _courseFace.width, 1)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self.view addSubview:_lineView];
    
    _teacherFace = [[UIImageView alloc] initWithFrame:CGRectMake(_courseFace.left, _lineView.bottom + 10, 38, 38)];
    _teacherFace.layer.masksToBounds = YES;
    _teacherFace.layer.cornerRadius = 19;
    _teacherFace.backgroundColor = EdlineV5_Color.faildColor;
    [self.view addSubview:_teacherFace];
    
    _teacherName = [[UILabel alloc] initWithFrame:CGRectMake(_teacherFace.right + 8, _teacherFace.top, _courseFace.width - _teacherFace.right - 8, 38)];
    _teacherName.font = SYSTEMFONT(13);
    _teacherName.textColor = EdlineV5_Color.textFirstColor;
    _teacherName.text = @"张晓晓";
    [self.view addSubview:_teacherName];
    
    NSString *institutionName = @"海天机构";
    NSString *fromText = [NSString stringWithFormat:@"本课程由 %@ 提供",institutionName];
    NSMutableAttributedString *atr2 = [[NSMutableAttributedString alloc] initWithString:fromText];
    [atr2 addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.textFirstColor} range:[fromText rangeOfString:institutionName]];
    _fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.left, _teacherFace.bottom + 8, _courseFace.width, 15)];
    _fromLabel.font = SYSTEMFONT(10);
    _fromLabel.textColor = EdlineV5_Color.textThirdColor;
    _fromLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:atr2];
    [self.view addSubview:_fromLabel];
    
    _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_courseFace.right - 63, _lineView.bottom + 9.5, 63, 63)];
    [self.view addSubview:_codeImageView];
}

// MARK: - 布局底部按钮UI
- (void)makeBottomView {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 100 - MACRO_UI_SAFEAREA, MainScreenWidth, 100 + MACRO_UI_SAFEAREA)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    UIBezierPath * path1 = [UIBezierPath bezierPathWithRoundedRect:_bottomView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(14, 14)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = _bottomView.bounds;
    maskLayer1.path = path1.CGPath;
    _bottomView.layer.mask = maskLayer1;
    [self.view addSubview:_bottomView];
    
    NSArray *buttonImageArray = @[@"share_download_icon",@"share_link_icon",@"share_password_icon"];
    NSArray *buttonTitleArray = @[@"保存海报",@"复制链接",@"复制口令"];
    
    for (int i = 0; i<buttonImageArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((MainScreenWidth - 60 * 3) * (i * 2 + 1) / 6.0 + 60 * i, 19, 60, 60)];
        btn.tag = 66 + i;
        [btn setImage:Image(buttonImageArray[i]) forState:0];
        [btn setTitle:buttonTitleArray[i] forState:0];
        btn.titleLabel.font = SYSTEMFONT(12);
        [btn setTitleColor:HEXCOLOR(0x888888) forState:0];
        // 1. 得到imageView和titleLabel的宽、高
        CGFloat imageWith = btn.imageView.frame.size.width;
        CGFloat imageHeight = btn.imageView.frame.size.height;
        
        CGFloat labelWidth = 0.0;
        CGFloat labelHeight = 0.0;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            // 由于iOS8中titleLabel的size为0，用下面的这种设置
            labelWidth = btn.titleLabel.intrinsicContentSize.width;
            labelHeight = btn.titleLabel.intrinsicContentSize.height;
        } else {
            labelWidth = btn.titleLabel.frame.size.width;
            labelHeight = btn.titleLabel.frame.size.height;
        }
        btn.imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-10/2.0, 0, 0, -labelWidth);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-10/2.0, 0);
        [btn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:btn];
    }
}

- (void)bottomButtonClick:(UIButton *)sender {
}

//生成二维码
- (void)GetCodeImage {
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据
    
    NSString *dataStr = HeaderUrl_V5;
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.将CIImage转换成UIImage，并放大显示
    self.codeImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:63];
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    //设置比例
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap（位图）;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
}


@end
