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

@interface CertificateDetailVC ()

@property (strong, nonatomic) NSDictionary *certificateInfo;

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (strong, nonatomic) UIImageView *posterImageView;
@property (strong, nonatomic) UIButton *saveButton;

@property (strong, nonatomic) UIImageView *commonSealTop;
@property (strong, nonatomic) UIImageView *commonSealBottom;
@property (strong, nonatomic) UILabel *certificateTitle;
@property (strong, nonatomic) UITextView *certificateContent;

@end

@implementation CertificateDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = @"证书详情";
    [self getCertificateInfoNet];
}

- (void)makeCertificateUI {
    
    _posterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 530)];
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
    _certificateTitle.textColor = EdlineV5_Color.textFirstColor;
    _certificateTitle.backgroundColor = [UIColor clearColor];
    [_posterImageView addSubview:_certificateTitle];
    _certificateTitle.text = [NSString stringWithFormat:@"%@",_certificateInfo[@"cert_info"][@"title"]];
    
    [_certificateTitle sizeToFit];
    _certificateTitle.frame = CGRectMake(76, 54, _posterImageView.width - 76 * 2, _certificateTitle.height);
    
    _certificateContent = [[UITextView alloc] initWithFrame:CGRectMake(48, _certificateTitle.bottom + 15, _posterImageView.width - 48 * 2, 20)];
    _certificateContent.showsVerticalScrollIndicator = NO;
    _certificateContent.showsHorizontalScrollIndicator = NO;
    _certificateContent.editable = NO;
    _certificateContent.scrollEnabled = NO;
    _certificateContent.font = SYSTEMFONT(9);
    _certificateContent.textColor = EdlineV5_Color.textFirstColor;
    _certificateContent.backgroundColor = [UIColor clearColor];
    [_posterImageView addSubview:_certificateContent];
    
    NSMutableAttributedString *attrString = [self changeCertificateContentStringToMutA:[NSString stringWithFormat:@"%@",_certificateInfo[@"cert_info"][@"content"]]];
    [attrString addAttributes:@{NSFontAttributeName:SYSTEMFONT(9)} range:NSMakeRange(0, attrString.length)];
    _certificateContent.attributedText = [[NSAttributedString alloc] initWithAttributedString:attrString];
    [_certificateContent sizeToFit];
    _certificateContent.frame = CGRectMake(48, _certificateTitle.bottom + 15, _posterImageView.width - 48 * 2, _certificateContent.height);
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(49, _certificateContent.bottom + 10, _posterImageView.width - 49 * 2, _posterImageView.height - (_certificateContent.bottom + 10 + 52))];
    _mainScrollView.layer.masksToBounds = YES;
    _mainScrollView.layer.borderColor = HEXCOLOR(0xB7BAC1).CGColor;
    _mainScrollView.layer.borderWidth = 1;
    _mainScrollView.backgroundColor = [UIColor clearColor];
    [_posterImageView addSubview:_mainScrollView];
    _mainScrollView.userInteractionEnabled = YES;
    
    [self makeCourseHourseUI:[NSMutableArray arrayWithArray:_certificateInfo[@"course_list"]]];
    
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
        for (int i = 0; i<courseArray.count; i++) {
            UIView *courseView = [[UIView alloc] initWithFrame:CGRectMake(0, 21 * i, _mainScrollView.width, 21)];
            courseView.backgroundColor = [UIColor clearColor];
            [_mainScrollView addSubview:courseView];
            
            UILabel *courseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, courseView.width, 21)];
            courseLabel.font = SYSTEMFONT(8);
            courseLabel.textColor = EdlineV5_Color.textFirstColor;
            courseLabel.textAlignment = NSTextAlignmentCenter;
            courseLabel.text = [NSString stringWithFormat:@"%@",courseArray[i][@"title"]];
            courseLabel.backgroundColor = [UIColor clearColor];
            [courseView addSubview:courseLabel];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 20, courseView.width, 1)];
            line.backgroundColor = HEXCOLOR(0xB7BAC1);
            [courseView addSubview:line];
        }
        _mainScrollView.hidden = SWNOTEmptyArr(courseArray) ? NO : YES;
        _mainScrollView.contentSize = CGSizeMake(0, courseArray.count * 21);
        [_mainScrollView setHeight:MIN(courseArray.count * 21, _mainScrollView.height)];
    }
}

@end
