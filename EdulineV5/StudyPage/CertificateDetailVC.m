//
//  CertificateDetailVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/4/26.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "CertificateDetailVC.h"
#import "V5_Constant.h"
#import "Net_Path.h"

@interface CertificateDetailVC ()<WKUIDelegate, WKNavigationDelegate>

@property (strong, nonatomic) NSDictionary *certificateInfo;

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (strong, nonatomic) UIImageView *posterImageView;
@property (strong, nonatomic) UIButton *saveButton;

@property (strong, nonatomic) UIImageView *commonSealTop;
@property (strong, nonatomic) UIImageView *commonSealBottom;
@property (strong, nonatomic) UILabel *certificateTitle;
@property (strong, nonatomic) WKWebView *certificateContent;

@end

@implementation CertificateDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = @"证书详情";
    [self getCertificateInfoNet];
}

- (void)makeCertificateUI {
    
    _posterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 530*MainScreenHeight/750)];
    [_posterImageView sd_setImageWithURL:EdulineUrlString(_certificateInfo[@"cert_info"][@"background_url"])];
    _posterImageView.userInteractionEnabled = YES;
    [self.view addSubview:_posterImageView];
    
    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(15, MainScreenHeight - MACRO_UI_SAFEAREA - 40 - 11, MainScreenWidth - 30, 40)];
    [_saveButton setTitle:@"保存证书" forState:0];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:0];
    _saveButton.titleLabel.font = SYSTEMFONT(15);
    [_saveButton setBackgroundColor:EdlineV5_Color.themeColor];
    _saveButton.layer.masksToBounds = YES;
    _saveButton.layer.cornerRadius = 5;
    [self.view addSubview:_saveButton];
    [_saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _certificateTitle = [[UILabel alloc] initWithFrame:CGRectMake(76, 54, _posterImageView.width - 76 * 2, 20)];
    _certificateTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _certificateTitle.textAlignment = NSTextAlignmentCenter;
    _certificateTitle.numberOfLines = 0;
    _certificateTitle.textColor = EdlineV5_Color.textFirstColor;
    _certificateTitle.backgroundColor = [UIColor clearColor];
    [_posterImageView addSubview:_certificateTitle];
    _certificateTitle.text = [NSString stringWithFormat:@"%@",_certificateInfo[@"cert_info"][@"title"]];
    
    [_certificateTitle sizeToFit];
    _certificateTitle.frame = CGRectMake(76, 54, _posterImageView.width - 76 * 2, _certificateTitle.height);
    
    _certificateContent = [[WKWebView alloc] initWithFrame:CGRectMake(48, _certificateTitle.bottom + 15, _posterImageView.width - 48 * 2, 1)];
    _certificateContent.backgroundColor = [UIColor clearColor];
    _certificateContent.scrollView.backgroundColor = [UIColor clearColor];
    [_certificateContent setOpaque:NO];
    _certificateContent.scrollView.scrollEnabled = NO;
    _certificateContent.scrollView.showsVerticalScrollIndicator = NO;
    _certificateContent.scrollView.showsHorizontalScrollIndicator = NO;
    _certificateContent.UIDelegate = self;
    _certificateContent.navigationDelegate = self;
    [_posterImageView addSubview:_certificateContent];
    
    if (@available(iOS 11.0, *)) {
        _certificateContent.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _certificateContent.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _certificateContent.scrollView.scrollIndicatorInsets = _certificateContent.scrollView.contentInset;
    }
    
    NSString *content = [NSString stringWithFormat:@"%@",_certificateInfo[@"cert_info"][@"content"]];
    if (content.length>2) {
        NSString *str2 = [content substringWithRange:NSMakeRange(0, 3)];
        if ([str2 isEqualToString:@"<p>"]) {
            content = [content substringFromIndex:3];
        }
        if ([content containsString:@"</p>"]) {
            content = [content stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        }
    }
    
    NSString *str = [NSString stringWithFormat:@"<HTML><HEAD><TITLE></TITLE></HEAD><BODY background:#fff;background-color:transparent;>%@</BODY></HTML>",content];
    [_certificateContent loadHTMLString:str baseURL:nil];
    
    _commonSealTop = [[UIImageView alloc] initWithFrame:CGRectMake(_posterImageView.width - 66 - 15, 53, 66, 66)];
    [_commonSealTop sd_setImageWithURL:EdulineUrlString(_certificateInfo[@"cert_info"][@"official_seal_url"])];
    [_posterImageView addSubview:_commonSealTop];
    _commonSealTop.backgroundColor = [UIColor clearColor];
    
    _commonSealBottom = [[UIImageView alloc] initWithFrame:CGRectMake(_posterImageView.width - 66 - 15, _posterImageView.height - 34 - 66, 66, 66)];
    [_commonSealBottom sd_setImageWithURL:EdulineUrlString(_certificateInfo[@"cert_info"][@"official_seal_url"])];
    [_posterImageView addSubview:_commonSealBottom];
    _commonSealBottom.backgroundColor = [UIColor clearColor];
    
    _commonSealTop.hidden = YES;
    _commonSealBottom.hidden = YES;
    NSString *official_seal_place = [NSString stringWithFormat:@"%@",_certificateInfo[@"cert_info"][@"official_seal_place"]];
    // 【right-top\right-bottom】
    if ([official_seal_place isEqualToString:@"right-top"]) {
        _commonSealTop.hidden = NO;
    } else if([official_seal_place isEqualToString:@"right-bottom"]) {
        _commonSealBottom.hidden = NO;
    } else {
        
    }
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable heigh, NSError * _Nullable error) {
        NSString *height = [NSString stringWithFormat:@"%@", heigh];
        _certificateContent.frame = CGRectMake(48, _certificateTitle.bottom + 15, _posterImageView.width - 48 * 2, (([height floatValue] / 3.0)*2/3.0)*1.3);
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(49, _certificateContent.bottom + 10, _posterImageView.width - 49 * 2, _posterImageView.height - (_certificateContent.bottom + 10 + 52))];
        _mainScrollView.layer.masksToBounds = YES;
        _mainScrollView.layer.borderColor = HEXCOLOR(0xB7BAC1).CGColor;
        _mainScrollView.layer.borderWidth = 1;
        _mainScrollView.backgroundColor = [UIColor clearColor];
        [_posterImageView addSubview:_mainScrollView];
        _mainScrollView.userInteractionEnabled = YES;
        
        [self makeCourseHourseUI:[NSMutableArray arrayWithArray:_certificateInfo[@"course_list"]]];
        [_posterImageView bringSubviewToFront:_commonSealTop];
        [_posterImageView bringSubviewToFront:_commonSealBottom];
    }];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"加载失败");
}

- (void)getCertificateInfoNet {
    
    if (SWNOTEmptyStr(_certificateId)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path certificateDetailNet] WithAuthorization:nil paramDic:@{@"id":_certificateId} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    _certificateInfo = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
                    [self makeCertificateUI];
                }
            }
        } enError:^(NSError * _Nonnull error) {
        }];
    }
    
}

- (void)saveButtonClick {
    UIImage *image = [self saveCertificateInfoImage:_posterImageView];
    ALAssetsLibrary * library = [ALAssetsLibrary new];
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        [self showHudInView:self.view showHint:@"证书已保存"];
    }];
}

- (UIImage *)saveCertificateInfoImage:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.frame.size,NO, 0);

    [[UIColor clearColor] setFill];

    [[UIBezierPath bezierPathWithRect:view.bounds] fill];

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    [view.layer renderInContext:ctx];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
//    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
//    [view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:NO];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
}

// MARK: - 将标签转为富文本并且过滤换行符
- (NSMutableAttributedString *)changeCertificateContentStringToMutA:(NSString *)commonString {
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithData:[commonString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    if (SWNOTEmptyStr(commonString)) {
        NSString *pass = [NSString stringWithFormat:@"%@",[attrString attributedSubstringFromRange:NSMakeRange(attrString.length - 1, 1)]];
        if ([[pass substringToIndex:1] isEqualToString:@"\n"]) {
            [attrString replaceCharactersInRange:NSMakeRange(attrString.length - 1, 1) withString:@""];
        }
    }
    return attrString;
}

- (void)makeCourseHourseUI:(NSMutableArray *)courseArray {
    if (_mainScrollView) {
        [_mainScrollView removeAllSubviews];
        CGFloat YY = 0;
        for (int i = 0; i<courseArray.count; i++) {
            UIView *courseView = [[UIView alloc] initWithFrame:CGRectMake(0, YY, _mainScrollView.width, 21)];
            courseView.backgroundColor = [UIColor clearColor];
            [_mainScrollView addSubview:courseView];
            
            UILabel *courseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, courseView.width, 21)];
            courseLabel.font = SYSTEMFONT(8);
            courseLabel.textColor = EdlineV5_Color.textFirstColor;
            courseLabel.textAlignment = NSTextAlignmentCenter;
            courseLabel.text = [NSString stringWithFormat:@"%@",courseArray[i][@"title"]];
            courseLabel.numberOfLines = 0;
            courseLabel.backgroundColor = [UIColor clearColor];
            [courseView addSubview:courseLabel];
            [courseLabel sizeToFit];
            courseLabel.frame = CGRectMake(0, 0, courseView.width, courseLabel.height);
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, courseLabel.height - 1, courseView.width, 1)];
            line.backgroundColor = HEXCOLOR(0xB7BAC1);
            [courseView addSubview:line];
            [courseView setHeight:line.bottom];
            YY = YY + courseView.height;
            if (i == (courseArray.count - 1)) {
                _mainScrollView.contentSize = CGSizeMake(0, courseView.bottom);
                [_mainScrollView setHeight:MIN(courseView.bottom, _mainScrollView.height)];
            }
        }
        _mainScrollView.hidden = SWNOTEmptyArr(courseArray) ? NO : YES;
    }
}

@end
