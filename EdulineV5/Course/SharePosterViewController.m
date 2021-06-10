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
#import "V5_UserModel.h"

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
    _titleLabel.text = @"推广赚收益";
    
    _posterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 12, 285, 440)];
//    _posterImageView.centerY = MainScreenHeight / 2.0 - 43 / 2.0;
    _posterImageView.centerX = MainScreenWidth / 2.0; // 127 84
    _posterImageView.image = Image(@"share_bg");
    [self.view addSubview:_posterImageView];
    
    [self getShareContentInfo];
}

// MARK: - 布局分享内容
- (void)makeShareContentUI {
    
    _teacherFace = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 45, 45)];
    _teacherFace.layer.masksToBounds = YES;
    _teacherFace.layer.cornerRadius = _teacherFace.height / 2.0;
    _teacherFace.layer.borderColor = [UIColor whiteColor].CGColor;
    _teacherFace.layer.borderWidth = 1.0;
    _teacherFace.centerX = _posterImageView.width / 2.0;
    [_teacherFace sd_setImageWithURL:EdulineUrlString([V5_UserModel avatar]) placeholderImage:DefaultUserImage];
    [_posterImageView addSubview:_teacherFace];
    
    _teacherName = [[UILabel alloc] initWithFrame:CGRectMake(0, _teacherFace.bottom + 6, _posterImageView.width, 15)];
    _teacherName.font = SYSTEMFONT(13);
    _teacherName.textColor = [UIColor whiteColor];
    _teacherName.textAlignment = NSTextAlignmentCenter;
    _teacherName.text = SWNOTEmptyStr([V5_UserModel uname]) ? [V5_UserModel uname] : @"";
    [_posterImageView addSubview:_teacherName];
    
    UILabel *inviteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _teacherName.bottom, _posterImageView.width, 15)];
    inviteLabel.font = SYSTEMFONT(10);
    inviteLabel.textColor = [UIColor whiteColor];
    inviteLabel.textAlignment = NSTextAlignmentCenter;
    inviteLabel.text = @"邀您一起学习";
    [_posterImageView addSubview:inviteLabel];
    
    _courseFace = [[UIImageView alloc] initWithFrame:CGRectMake(27.5, 118, 230, 124)];
    _courseFace.layer.masksToBounds = YES;
    _courseFace.layer.cornerRadius = 5;
    [_posterImageView addSubview:_courseFace];
    
    _courseTitle = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.left, _courseFace.bottom + 5, _courseFace.width, 25)];
    _courseTitle.font = SYSTEMFONT(15);
    _courseTitle.textColor = EdlineV5_Color.textFirstColor;
    [_posterImageView addSubview:_courseTitle];
    
    _coursePricelabel = [[UILabel alloc] initWithFrame:CGRectMake(_courseFace.left, _courseTitle.bottom + 3, _courseFace.width, 19)];
    _coursePricelabel.font = SYSTEMFONT(11);
    _coursePricelabel.textColor = EdlineV5_Color.faildColor;
    [_posterImageView addSubview:_coursePricelabel];
    
    _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _coursePricelabel.bottom + 12, 63, 63)];
    _codeImageView.centerX = _posterImageView.width / 2.0;
    [_posterImageView addSubview:_codeImageView];
    
    _fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _posterImageView.height - 10 - 15, _posterImageView.width, 15)];
    _fromLabel.font = SYSTEMFONT(10);
    _fromLabel.textColor = [UIColor whiteColor];
    _fromLabel.textAlignment = NSTextAlignmentCenter;
    [_posterImageView addSubview:_fromLabel];
    
    UIImageView *tipBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _posterImageView.bottom + 15, 286, 25)];
    tipBackImageView.image = Image(@"income_bg");
    tipBackImageView.centerX = MainScreenWidth / 2.0;
    [self.view addSubview:tipBackImageView];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tipBackImageView.width, 25)];
    _tipLabel.font = SYSTEMFONT(11);
    _tipLabel.textColor = HEXCOLOR(0x5191FF);//EdlineV5_Color.themeColor;
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.center = CGPointMake(tipBackImageView.width / 2.0, tipBackImageView.height / 2.0);
    [tipBackImageView addSubview:_tipLabel];
    
    if (SWNOTEmptyDictionary(_shareContentDict)) {
        [_courseFace sd_setImageWithURL:EdulineUrlString(_shareContentDict[@"cover_url"]) placeholderImage:DefaultImage];
        _courseTitle.text = [NSString stringWithFormat:@"%@",_shareContentDict[@"course_title"]];
        NSString *price = [NSString stringWithFormat:@"%@%@  ",IOSMoneyTitle,[EdulineV5_Tool reviseString:_shareContentDict[@"course_price"]]];
        NSString *scribing_price = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,[EdulineV5_Tool reviseString:_shareContentDict[@"scribing_price"]]];
        
        NSString *finalPrice = [NSString stringWithFormat:@"%@%@",price,scribing_price];
        NSRange rangNow = NSMakeRange(price.length, scribing_price.length);
        NSRange rangOld = NSMakeRange(0, price.length);
        NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:finalPrice];
        [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(15),NSForegroundColorAttributeName: EdlineV5_Color.textPriceColor} range:rangOld];
        [priceAtt addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:EdlineV5_Color.textThirdColor} range:rangNow];
        _coursePricelabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:priceAtt];
//        _coursePricelabel.text = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,[EdulineV5_Tool reviseString:_shareContentDict[@"course_price"]]];
        
        NSString *tipPrice = [NSString stringWithFormat:@"%@%@",IOSMoneyTitle,[EdulineV5_Tool reviseString:_shareContentDict[@"max_profit"]]];
        NSString *tipText = [NSString stringWithFormat:@"每成功邀请一名用户预计最多收入 %@",tipPrice];
        NSMutableAttributedString *atr1 = [[NSMutableAttributedString alloc] initWithString:tipText];
        [atr1 addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.faildColor,NSFontAttributeName:SYSTEMFONT(12)} range:[tipText rangeOfString:tipPrice]];
        _tipLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:atr1];
        
//        [_teacherFace sd_setImageWithURL:EdulineUrlString(_shareContentDict[@"teacher_avatar"]) placeholderImage:DefaultUserImage];
        
//        _teacherName.text = [NSString stringWithFormat:@"%@",_shareContentDict[@"teacher_name"]];
        
        NSString *institutionName = [NSString stringWithFormat:@"%@",_shareContentDict[@"mhm_title"]];
        NSString *finalName = [NSString stringWithFormat:@"%@",_shareContentDict[@"mhm_title"]];
        NSString *fromText = [NSString stringWithFormat:@"本课程由 %@ 提供",institutionName];
        _fromLabel.text = fromText;
//        if (institutionName.length>8) {
//            finalName = [institutionName  substringWithRange:NSMakeRange(0, 8)];
//            fromText = [NSString stringWithFormat:@"本课程由 %@... 提供",finalName];
//        }
//        NSMutableAttributedString *atr2 = [[NSMutableAttributedString alloc] initWithString:fromText];
//        [atr2 addAttributes:@{NSForegroundColorAttributeName:EdlineV5_Color.textFirstColor} range:[fromText rangeOfString:finalName]];
//        _fromLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:atr2];
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
            /**
             "$randomString|$this|$courseType|$courseId"
有活动就加上 "|$activeType|$activeId"
             吥再娛樂  14:44:31
             随机字符串4-8位，this是share_code
             吥再娛樂  14:45:08
             最后拼接得字符串转换成字节数组，每个字节-i+1
             */
            NSString *final = @"";
            NSString *randomString = [self generateTradeNO];
            final = [NSString stringWithFormat:@"%@",randomString];
            
            NSString *shareCode = [NSString stringWithFormat:@"%@",_shareContentDict[@"share_code"]];
            final = [NSString stringWithFormat:@"%@|%@",final,shareCode];
            
            NSString *courseType = [NSString stringWithFormat:@"%@",_courseType];
            final = [NSString stringWithFormat:@"%@|%@",final,courseType];
            
            NSString *courseId = [NSString stringWithFormat:@"%@",_sourceId];
            final = [NSString stringWithFormat:@"%@|%@",final,courseId];
            
            NSString *activityType = [NSString stringWithFormat:@"%@",_activityType];
            NSString *activityid = [NSString stringWithFormat:@"%@",_activityId];
            if (SWNOTEmptyStr(activityType) && SWNOTEmptyStr(activityid)) {
                final = [NSString stringWithFormat:@"%@|%@|%@",final,activityType,activityid];
            }
            
            NSData *shareData = [final dataUsingEncoding:NSUTF8StringEncoding];
            Byte *bytes = (Byte *)[shareData bytes];
            NSString *byteString = @"";
            for (int i = 0; i < shareData.length; i++) {
                bytes[i] = bytes[i] - i + 1;
                //字节数组转换成字符
                NSData *d1 = [NSData dataWithBytes:bytes length:i+1];
                byteString = [[NSString alloc] initWithData:d1 encoding:NSUTF8StringEncoding];
            }
            
            NSString *courseTitle = [NSString stringWithFormat:@"%@",_shareContentDict[@"course_title"]];
            
            NSString *passString = [NSString stringWithFormat:@"￥%@￥Eduline网校【%@】",byteString,courseTitle];
            [[NSUserDefaults standardUserDefaults] setObject:passString forKey:@"localSharePost"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = passString;
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
        
        NSMutableDictionary *param = [NSMutableDictionary new];
        if ([_type isEqualToString:@"1"] || [_type isEqualToString:@"2"]) {
            [param setObject:_type forKey:@"type"];
            [param setObject:_sourceId forKey:@"id"];
        } else if ([_type isEqualToString:@"3"] || [_type isEqualToString:@"4"]) {
            [param setObject:[_type isEqualToString:@"3"] ? @"12" : @"11" forKey:@"type"];
            [param setObject:_activityId forKey:@"id"];
        }
        
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path shareContentInfoNet] WithAuthorization:nil paramDic:param finish:^(id  _Nonnull responseObject) {
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

// MARK: - 随机字符串8位
//产生随机字符串
- (NSString *)generateTradeNO {
    static int kNumber = 8;
    NSString *sourceStr = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
