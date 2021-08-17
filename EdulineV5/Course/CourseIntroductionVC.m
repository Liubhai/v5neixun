//
//  CourseIntroductionVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/19.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseIntroductionVC.h"
#import "Net_Path.h"

@interface CourseIntroductionVC () {
    BOOL isShowImageTouch;
    NSString *_imageBigUrl;
    NSString *_imageSmallUrl;
    NSMutableArray* _webImageUrlStrArray;
}

@property(nonatomic,strong) NSMutableArray *originalImageArray;

@end

@implementation CourseIntroductionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleImage.hidden = YES;
    self.originalImageArray = [[NSMutableArray alloc]init];
    _mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _tabelHeight)];
    _mainScroll.delegate = self;
    _mainScroll.backgroundColor = [UIColor whiteColor];
    _mainScroll.showsVerticalScrollIndicator = NO;
    _mainScroll.contentSize = CGSizeMake(MainScreenWidth, _tabelHeight + 10);
    [self.view addSubview:_mainScroll];
    _mainScroll.contentSize = CGSizeMake(MainScreenWidth, _ClassIntroWeb.bottom > _tabelHeight ? _ClassIntroWeb.bottom : (_tabelHeight + 10));
    
//    _introTitleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, MainScreenWidth - 30, 21)];
//    _introTitleL.text = @"课程信息";
//    _introTitleL.font = SYSTEMFONT(15);
//    _introTitleL.textColor = EdlineV5_Color.textFirstColor;
//    [_mainScroll addSubview:_introTitleL];
    
    [self getCourseInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopVoicePaly) name:@"stopWKVoicePlay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continueload) name:@"continueWKVoicePlay" object:nil];
}

- (void)makeClassInfoWebView {
    
    _ClassIntroWeb = [[WKWebIntroview alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.5)];//_introTitleL.bottom + 12
    _ClassIntroWeb.backgroundColor = [UIColor whiteColor];
    _ClassIntroWeb.scrollView.scrollEnabled = NO;
    _ClassIntroWeb.scrollView.pagingEnabled = YES;
    _ClassIntroWeb.UIDelegate = self;
    _ClassIntroWeb.navigationDelegate = self;
    [_mainScroll addSubview:_ClassIntroWeb];
    NSString *allStr = [NSString stringWithFormat:@"%@",_dataSource[@"info"]];

    [_ClassIntroWeb loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:allStr]]];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap1:)];
//    [_ClassIntroWeb addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.cellTabelCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        if (self.vc) {
            if (self.vc.canScrollAfterVideoPlay == YES) {
                self.cellTabelCanScroll = NO;
                scrollView.contentOffset = CGPointZero;
                self.vc.canScroll = YES;
            }
        } else {
            if (self.detailVC.canScrollAfterVideoPlay == YES) {
                self.cellTabelCanScroll = NO;
                scrollView.contentOffset = CGPointZero;
                self.detailVC.canScroll = YES;
            }
        }
    }
}

- (void)changeMainScrollViewHeight:(CGFloat)changeHeight {
    [_mainScroll setHeight:changeHeight];
    _mainScroll.contentSize = CGSizeMake(MainScreenWidth, _mainScroll.contentSize.height > _tabelHeight ? _mainScroll.contentSize.height : _tabelHeight + 10);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap1:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:_ClassIntroWeb];
    NSString *imgStr = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    [_ClassIntroWeb evaluateJavaScript:imgStr completionHandler:^(id _Nullable urlToSav, NSError * _Nullable error) {
        NSString *urlToSave = [NSString stringWithFormat:@"%@", urlToSav];
        NSString *orignalStr = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).getAttribute('_src')", pt.x, pt.y];
        // NSString *orignalUrl = [_webView stringByEvaluatingJavaScriptFromString:orignalStr];
        [self.ClassIntroWeb evaluateJavaScript:orignalStr completionHandler:^(id _Nullable orignalUr, NSError * _Nullable error) {
            NSString *orignalUrl = [NSString stringWithFormat:@"%@", orignalUr];
            if (urlToSave.length > 0&&[urlToSave rangeOfString:@"/expression/"].location==NSNotFound&&[urlToSave rangeOfString:@"/emotion/"].location==NSNotFound) {
                self->_imageBigUrl = orignalUrl;
                self->_imageSmallUrl = urlToSave;
                self->isShowImageTouch = YES;
                ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
                pickerBrowser.delegate = self;
                pickerBrowser.dataSource = self;
                // 是否可以删除照片
                pickerBrowser.editing = NO;
    
                int row;
                
                for (int i = 0; i < _webImageUrlStrArray.count; i ++) {
                    if ([_imageSmallUrl isEqualToString:_webImageUrlStrArray[i]]) {
                        row = i;
                        break;
                    }
                }
                pickerBrowser.currentIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
                
                
                // 展示控制器
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    [pickerBrowser showPickerVc:window.rootViewController];
                });
                
            }
        }];
    }];
}

//开始加载调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"开始加载");
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"完成加载");
    
#pragma mark --- 解析图片标签
    [webView evaluateJavaScript:@"document.body.style.backgroundColor='#f9f9f9';" completionHandler:nil];//设置背景颜色
    [webView evaluateJavaScript:@"document.body.style.zoom=1.0" completionHandler:nil];
    [webView evaluateJavaScript:@"document.body.style.backgroundColor='#f9f9f9';" completionHandler:nil];
    [webView evaluateJavaScript:@"ResizeImages();" completionHandler:nil];
//    [webView evaluateJavaScript:botySise completionHandler:nil];
    [webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id _Nullable heigh, NSError * _Nullable error) {
        NSString *height = [NSString stringWithFormat:@"%@", heigh];
        [self.ClassIntroWeb setHeight:[height floatValue] + 20];
        self.mainScroll.contentSize = CGSizeMake(MainScreenWidth, self.ClassIntroWeb.bottom > self.tabelHeight ? self.ClassIntroWeb.bottom : (self.tabelHeight + 10));
        self->_webImageUrlStrArray = nil;
        
        static  NSString * const jsGetImages =
        @"function getImages(){\
        var objs = document.getElementsByTagName(\"img\");\
        var imgScr = '';\
        for(var i=0;i<objs.length;i++){\
        if(objs[i].class != 'emot')\
        imgScr = imgScr + objs[i].src + '+';\
        };\
        return imgScr;\
        };";
        // 获取原图的JS
        static  NSString * const jsGetOriginalImages =
        @"function getOriginalImages(){\
        var objs = document.getElementsByTagName(\"img\");\
        var imgScr = '';\
        for(var i=0;i<objs.length;i++){\
        if(objs[i].class != 'emot')\
        imgScr = imgScr + objs[i].getAttribute('_src') + '+';\
        };\
        return imgScr;\
        };";
        [webView evaluateJavaScript:jsGetImages completionHandler:nil];//注入js方法
        [webView evaluateJavaScript:jsGetOriginalImages completionHandler:nil];//注入js方法
        [webView evaluateJavaScript:@"getImages()" completionHandler:^(id _Nullable urlResurl, NSError * _Nullable error) {
            NSString *urlResurlt = [NSString stringWithFormat:@"%@", urlResurl];
            self->_webImageUrlStrArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
            if (self->_webImageUrlStrArray.count >= 2) {
                [self->_webImageUrlStrArray removeLastObject];
            }
            
            NSMutableArray* delateArray = [[NSMutableArray alloc]init];
            NSMutableArray* tempArray = [[NSMutableArray alloc]initWithArray:self->_webImageUrlStrArray];
            
            // TS系统中的 新版本（16.10月以后）动态表情头
            NSString* headerUrl =[NSString stringWithFormat:@"%@resources/theme/stv1/_static/js/um/dialogs/emotion",HeaderUrl_V5];
            //  旧版本（16.10月之前）动态表情头
            //  需要过滤掉这部分表情图片
            NSString *oldeHeaderUrl = [NSString stringWithFormat:@"%@addons",HeaderUrl_V5];
            
            for (NSString* tempUrl in self->_webImageUrlStrArray) {
                if ([tempUrl hasPrefix:headerUrl] || [tempUrl hasPrefix:oldeHeaderUrl]) {
                    [delateArray addObject:tempUrl];
                }
            }
            
            for (NSString* temp in self->_webImageUrlStrArray) {
                for (NSString* delate in delateArray) {
                    if ([delate isEqualToString:temp]) {
                        [tempArray removeObject:temp];
                        break;
                    }
                }
            }
            self->_webImageUrlStrArray = tempArray;
        }];
        [webView evaluateJavaScript:@"getOriginalImages()" completionHandler:^(id _Nullable urlResurl, NSError * _Nullable error) {
            NSString *urlResurlt = [NSString stringWithFormat:@"%@", urlResurl];
            self.originalImageArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
            if (self.originalImageArray.count >= 2) {
                [self.originalImageArray removeLastObject];
            }
            
            NSMutableArray* delateArray = [[NSMutableArray alloc]init];
            NSMutableArray* tempArray = [[NSMutableArray alloc]initWithArray:self.originalImageArray];
            
            // TS系统中的 新版本（16.10月以后）动态表情头
            NSString* headerUrl =[NSString stringWithFormat:@"%@resources/theme/stv1/_static/js/um/dialogs/emotion",HeaderUrl_V5];
            //  旧版本（16.10月之前）动态表情头
            //  需要过滤掉这部分表情图片
            NSString *oldeHeaderUrl = [NSString stringWithFormat:@"%@addons",HeaderUrl_V5];
            
            for (NSString* tempUrl in self.originalImageArray) {
                if ([tempUrl hasPrefix:headerUrl] || [tempUrl hasPrefix:oldeHeaderUrl]) {
                    [delateArray addObject:tempUrl];
                }
            }
            
            for (NSString* temp in self.originalImageArray) {
                for (NSString* delate in delateArray) {
                    if ([delate isEqualToString:temp]) {
                        [tempArray removeObject:temp];
                        break;
                    }
                }
            }
            self.originalImageArray = tempArray;
        }];
    }];
}

//加载失败调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"加载失败");
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *requestURL = navigationAction.request.URL;
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ]) && ( navigationAction.navigationType == WKNavigationTypeLinkActivated ) ) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return _webImageUrlStrArray.count;
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    ZLPhotoPickerBrowserPhoto *photo;
    NSString *imageURLStr;
    // 如果没有原图，会拿到一个null字符串，注意是字符串
    if (![self.originalImageArray[indexPath.row] isEqualToString:@"null"]) {
        imageURLStr = self.originalImageArray[indexPath.row];
    }
    else{
        imageURLStr = _webImageUrlStrArray[indexPath.row];
    }
    photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:[NSURL URLWithString:imageURLStr]];
    
    return photo;
}

- (void)getCourseInfo {
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path courseInfo:_courseId] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        NSLog(@"课程详情 = %@",responseObject);
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                _dataSource = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                [self makeClassInfoWebView];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        NSLog(@"课程详情请求失败 = %@",error);
    }];
}

- (void)stopVoicePaly {
    [self.ClassIntroWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
}

- (void)continueload {
    NSString *allStr = [NSString stringWithFormat:@"%@",_dataSource[@"info"]];

    [_ClassIntroWeb loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:allStr]]];
}

- (void)dealloc {
    NSLog(@"1111111111111");
}

@end
