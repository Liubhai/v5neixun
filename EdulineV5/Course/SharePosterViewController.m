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
#import <UShareUI/UShareUI.h>

@interface SharePosterViewController ()<UMSocialShareMenuViewDelegate>

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
@property (strong, nonatomic) NSDictionary *shareContentDict;

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
    
    [self getShareContentInfo];
}

// MARK: - 布局分享内容
- (void)makeShareContentUI {
    
    _courseFace = [[UIImageView alloc] initWithFrame:CGRectMake(27.5, 78, 230, 124)];
    _courseFace.layer.masksToBounds = YES;
    _courseFace.layer.cornerRadius = 5;
    [_posterImageView addSubview:_courseFace];
    
    _courseTitle = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.left, _courseFace.bottom + 10, _courseFace.width, 38)];
    _courseTitle.font = SYSTEMFONT(15);
    _courseTitle.textColor = EdlineV5_Color.textFirstColor;
    _courseTitle.numberOfLines = 2;
    [_posterImageView addSubview:_courseTitle];
    
    _coursePricelabel = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.left, _courseTitle.bottom + 10, _courseFace.width, 19)];
    _coursePricelabel.font = SYSTEMFONT(15);
    _coursePricelabel.textColor = EdlineV5_Color.faildColor;
    [_posterImageView addSubview:_coursePricelabel];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.left, _coursePricelabel.bottom + 9, _courseFace.width, 19)];
    _tipLabel.font = SYSTEMFONT(9);
    _tipLabel.textColor = EdlineV5_Color.textThirdColor;
    [_posterImageView addSubview:_tipLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_courseFace.left, _tipLabel.bottom + 5, _courseFace.width, 1)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_posterImageView addSubview:_lineView];
    
    _teacherFace = [[UIImageView alloc] initWithFrame:CGRectMake(_courseFace.left, _lineView.bottom + 10, 38, 38)];
    _teacherFace.layer.masksToBounds = YES;
    _teacherFace.layer.cornerRadius = 19;
    [_posterImageView addSubview:_teacherFace];
    
    _teacherName = [[UILabel alloc] initWithFrame:CGRectMake(_teacherFace.right + 8, _teacherFace.top, _courseFace.width - _teacherFace.width - 8 - 63, 38)];
    _teacherName.font = SYSTEMFONT(13);
    _teacherName.textColor = EdlineV5_Color.textFirstColor;
    [_posterImageView addSubview:_teacherName];
    
    _fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.left, _teacherFace.bottom + 8, _courseFace.width - 63, 15)];
    _fromLabel.font = SYSTEMFONT(10);
    _fromLabel.textColor = EdlineV5_Color.textThirdColor;
    [_posterImageView addSubview:_fromLabel];
    
    _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_courseFace.right - 63, _lineView.bottom + 9.5, 63, 63)];
    [_posterImageView addSubview:_codeImageView];
    
    if (SWNOTEmptyDictionary(_shareContentDict)) {
        [_courseFace sd_setImageWithURL:EdulineUrlString(_shareContentDict[@"cover_url"]) placeholderImage:DefaultImage];
        _courseTitle.text = [NSString stringWithFormat:@"%@",_shareContentDict[@"course_title"]];
        _coursePricelabel.text = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,_shareContentDict[@"course_price"]];
        
        NSString *tipPrice = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,_shareContentDict[@"max_profit"]];
        NSString *tipText = [NSString stringWithFormat:@"每成功邀请一名用户预计最多收入 %@",tipPrice];
        NSMutableAttributedString *atr1 = [[NSMutableAttributedString alloc] initWithString:tipText];
        [atr1 addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.faildColor,NSFontAttributeName:SYSTEMFONT(11)} range:[tipText rangeOfString:tipPrice]];
        _tipLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:atr1];
        
        [_teacherFace sd_setImageWithURL:EdulineUrlString(_shareContentDict[@"teacher_avatar"]) placeholderImage:DefaultUserImage];
        
        _teacherName.text = [NSString stringWithFormat:@"%@",_shareContentDict[@"teacher_name"]];
        
        NSString *institutionName = [NSString stringWithFormat:@"%@",_shareContentDict[@"mhm_title"]];
        NSString *finalName = [NSString stringWithFormat:@"%@",_shareContentDict[@"mhm_title"]];
        NSString *fromText = [NSString stringWithFormat:@"本课程由 %@ 提供",institutionName];
        if (institutionName.length>8) {
            finalName = [institutionName  substringWithRange:NSMakeRange(0, 8)];
            fromText = [NSString stringWithFormat:@"本课程由 %@... 提供",finalName];
        }
        NSMutableAttributedString *atr2 = [[NSMutableAttributedString alloc] initWithString:fromText];
        [atr2 addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.textFirstColor} range:[fromText rangeOfString:finalName]];
        _fromLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:atr2];
    }
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
    
    NSArray *buttonImageArray = @[@"share_password_icon"];
    NSArray *buttonTitleArray = @[@"复制口令"];
    
    if (SWNOTEmptyDictionary(_shareContentDict)) {
        if ([[_shareContentDict allKeys] containsObject:@"open_device"]) {
            if ([[_shareContentDict objectForKey:@"open_device"] containsObject:@"h5"]) {
                buttonImageArray = @[@"share_download_icon",@"share_link_icon",@"share_password_icon"];
                buttonTitleArray = @[@"分享海报",@"复制链接",@"复制口令"];
            }
        }
    }
    
    for (int i = 0; i<buttonImageArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((MainScreenWidth - 60 * buttonImageArray.count) * (i * 2 + 1) / 6.0 + 60 * i, 19, 60, 60)];
        if (buttonImageArray.count == 1) {
            btn.centerX = MainScreenWidth / 2.0;
        }
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
    if (SWNOTEmptyDictionary(_shareContentDict)) {
        if ([sender.titleLabel.text isEqualToString:@"复制链接"]) {
            
            if (SWNOTEmptyStr(_shareContentDict[@"cover_url"])) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = [NSString stringWithFormat:@"%@",_shareContentDict[@"share_url_h5"]];
                [self showHudInView:self.view showHint:@"复制链接成功"];
            }
        
//            [UMSocialUIManager setShareMenuViewDelegate:self];
//            [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ)]];
//            //显示分享面板
//            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//                // 根据获取的platformType确定所选平台进行下一步操作
//                //创建分享消息对象
//                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//
//
//                // 普通文本分享
//                UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_shareContentDict[@"course_title"] descr:nil thumImage:SWNOTEmptyStr(_shareContentDict[@"cover_url"]) ? _courseFace.image : DefaultImage];
//                shareObject.webpageUrl = @"https://tv5-pc.51eduline.com";//[NSString stringWithFormat:@"%@",_shareContentDict[@"share_url"]];
//
//                //分享消息对象设置分享内容对象
//                messageObject.shareObject = shareObject;
//                //调用分享接口
//                [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//                    if (error) {
//                        UMSocialLogInfo(@"************Share fail with error %@*********",error);
//                    }else{
//                        if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                            UMSocialShareResponse *resp = data;
//                            //分享结果消息
//                            UMSocialLogInfo(@"response message is %@",resp.message);
//                            //第三方原始返回的数据
//                            UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//                        }else{
//                            UMSocialLogInfo(@"response data is %@",data);
//                        }
//                    }
//                }];
//            }];
            
        } else if ([sender.titleLabel.text isEqualToString:@"分享海报"]) {
            [self jiepingBtn];
        } else if ([sender.titleLabel.text isEqualToString:@"复制口令"]) {
            NSString *courseTitle = [NSString stringWithFormat:@"[%@]",_shareContentDict[@"course_title"]];
            NSString *shareCode = [NSString stringWithFormat:@"%@",_shareContentDict[@"share_code"]];
            NSString *courseId = [NSString stringWithFormat:@"「courseId=%@」",_sourceId];
            NSString *courseType = [NSString stringWithFormat:@"{courseType=%@}",_courseType];
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [NSString stringWithFormat:@"%@%@%@%@",shareCode,courseId,courseType,courseTitle];
//            NSData *shareData = [NSJSONSerialization dataWithJSONObject:@{@"eduline":@"1",@"courseId":_sourceId,@"courseType":_courseType} options:NSJSONWritingPrettyPrinted error:nil];
//            NSString * str = [[NSString alloc] initWithData:shareData encoding:NSUTF8StringEncoding];
            [self showHudInView:self.view showHint:@"复制口令成功"];
        }
    }
}

//生成二维码
- (void)GetCodeImage {
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据
    NSString *dataStr = @"暂不支持";
    if (SWNOTEmptyDictionary(_shareContentDict)) {
        if ([[_shareContentDict allKeys] containsObject:@"share_url_h5"]) {
            dataStr = [NSString stringWithFormat:@"%@",_shareContentDict[@"share_url_h5"]];
        }
    }
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

- (void)getShareContentInfo {
    if (SWNOTEmptyStr(_type) && SWNOTEmptyStr(_sourceId)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path shareContentInfoNet] WithAuthorization:nil paramDic:@{@"type":_type,@"id":_sourceId} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    
                    _shareContentDict = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
                    
                    [self makeShareContentUI];
                    
                    [self GetCodeImage];
                    
                    [self makeBottomView];
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}


//截图功能

-(void)jiepingBtn{

UIImage * image = [self captureImageFromView:self.posterImageView];

ALAssetsLibrary * library = [ALAssetsLibrary new];

NSData * data = UIImageJPEGRepresentation(image, 1.0);

    [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        [UMSocialUIManager setShareMenuViewDelegate:self];
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ)]];
        //显示分享面板
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            // 根据获取的platformType确定所选平台进行下一步操作
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:nil descr:nil thumImage:image];
            //设置网页地址
            shareObject.shareImage = image;
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    UMSocialLogInfo(@"************Share fail with error %@*********",error);
                }else{
                    if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                        UMSocialShareResponse *resp = data;
                        //分享结果消息
                        UMSocialLogInfo(@"response message is %@",resp.message);
                        //第三方原始返回的数据
                        UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    }else{
                        UMSocialLogInfo(@"response data is %@",data);
                    }
                }
            }];
        }];
    }];

}

-(UIImage *)captureImageFromView:(UIView *)view{

UIGraphicsBeginImageContextWithOptions(view.frame.size,NO, 0);

[[UIColor clearColor] setFill];

[[UIBezierPath bezierPathWithRect:view.bounds] fill];

CGContextRef ctx = UIGraphicsGetCurrentContext();

[view.layer renderInContext:ctx];

UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

UIGraphicsEndImageContext();

return image;
    
}

//不需要改变父窗口则不需要重写此协议
- (UIView*)UMSocialParentView:(UIView*)defaultSuperView
{
    return self.view;
}

@end