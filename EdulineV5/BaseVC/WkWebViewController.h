//
//  WkWebViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WkWebViewController : BaseViewController

@property (strong, nonatomic) WKWebView *wkwebView;
@property (strong, nonatomic) NSString *agreementKey;
@property (strong, nonatomic) NSString *titleString;

@end

NS_ASSUME_NONNULL_END
