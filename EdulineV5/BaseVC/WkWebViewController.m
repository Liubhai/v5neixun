//
//  WkWebViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "WkWebViewController.h"
#import "V5_Constant.h"
#import "Net_Path.h"

@interface WkWebViewController ()

@end

@implementation WkWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [_rightButton setImage:nil forState:0];
    [_rightButton setTitle:@"刷新" forState:0];
    [_rightButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    _rightButton.hidden = NO;
    
    _titleLabel.text = _titleString;
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.allowsInlineMediaPlayback = YES;
    wkWebConfig.userContentController = wkUController;
    
    _wkwebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT) configuration:wkWebConfig];
    [_wkwebView setUserInteractionEnabled:YES];//是否支持交互
    _wkwebView.scrollView.scrollEnabled = YES;
    [self.view addSubview:_wkwebView];
    [self getAgreementContent];
}

- (void)getAgreementContent {
    if (SWNOTEmptyStr(_urlString)) {
        if ([_urlString containsString:@"http"]) {
            [_wkwebView loadRequest:[NSURLRequest requestWithURL:EdulineUrlString(_urlString)]];
        }
    } else {
        if (SWNOTEmptyStr(_agreementKey)) {
            [Net_API requestGETSuperAPIWithURLStr:[Net_Path agreementContentNet:_agreementKey] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
                if (SWNOTEmptyDictionary(responseObject)) {
                    if ([[responseObject objectForKey:@"code"] integerValue]) {
                        [_wkwebView loadRequest:[NSURLRequest requestWithURL:EdulineUrlString(responseObject[@"data"][@"content"])]];
                        _titleLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"title"]];
                    }
                }
            } enError:^(NSError * _Nonnull error) {
                
            }];
        }
    }
}

- (void)rightButtonClick:(id)sender {
    [self getAgreementContent];
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
