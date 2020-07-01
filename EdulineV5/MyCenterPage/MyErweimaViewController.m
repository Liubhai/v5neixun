//
//  MyErweimaViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/1.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "MyErweimaViewController.h"
#import "V5_Constant.h"
#import <UShareUI/UShareUI.h>
#import "AppDelegate.h"

@interface MyErweimaViewController ()

@property (strong, nonatomic) UIImageView *backView;
@property (strong, nonatomic) UIImageView *codeImageView;
@property (strong, nonatomic) UIImage *shareImage;

@end

@implementation MyErweimaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    _backView.image = Image(@"erweima_bg");
    _backView.clipsToBounds = YES;
    _backView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_backView];
    
    _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 155, 155)];
    _codeImageView.center = CGPointMake(MainScreenWidth / 2.0, MainScreenHeight / 2.0);
    [_backView addSubview:_codeImageView];
    
    [self.view bringSubviewToFront:_titleImage];
    [_leftButton setImage:Image(@"nav_back_white") forState:0];
    _titleImage.backgroundColor = [UIColor clearColor];
    _titleLabel.hidden = YES;
    [_rightButton setImage:Image(@"nav_fenxiang_white") forState:0];
    _rightButton.hidden = NO;
    _lineTL.hidden = YES;
    
    [self GetCodeImage];
//    _shareImage = [self screenImageWithSize:self.view.bounds.size];
    UIGraphicsBeginImageContext(self.view.bounds.size);     //currentView 当前的view  创建一个基于绘图的图形上下文并指定大小为当前视图的bounds
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
    _shareImage = viewImage;
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
    self.codeImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
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

- (void)rightButtonClick:(id)sender {
    //显示分享面板
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sina)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareImageObject *imageObject = [[UMShareImageObject alloc] init];
        imageObject.shareImage = _shareImage;//_codeImageView.image;
        //创建网页内容对象
//        NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
//        UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:@"来玩呀" descr:@"这里要什么样的都有哦" thumImage:self.codeImageView.image];
//        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"来玩呀客官" descr:@"这里要什么样的都有哦" thumImage:self.codeImageView.image];
        //设置网页地址
//        shareObject.webpageUrl = HeaderUrl_V5;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = imageObject;
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
}

- (UIImage *)screenImageWithSize:(CGSize)imgSize {
    UIGraphicsBeginImageContext(imgSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window.layer renderInContext:context];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
