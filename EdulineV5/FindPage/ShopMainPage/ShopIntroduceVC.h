//
//  ShopIntroduceVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2022/11/11.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "V5_Constant.h"
#import "ShopDetailViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopIntroduceVC : BaseViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate,WKUIDelegate,WKNavigationDelegate,ZLPhotoPickerBrowserViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource>

@property (strong, nonatomic) UIScrollView *mainScroll;

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *redLineView;
@property (strong, nonatomic) UILabel *introTitleL;
@property (strong, nonatomic) UIView *grayLineView;

@property (strong ,nonatomic) WKWebView *ClassIntroWeb;
@property (assign, nonatomic) CGFloat tabelHeight;
@property (weak, nonatomic) ShopDetailViewController *vc;
@property (assign, nonatomic) BOOL cellTabelCanScroll;

@property (strong ,nonatomic)NSDictionary   *dataSource;
@property (strong, nonatomic) NSString *courseId;

- (void)changeMainScrollViewHeight:(CGFloat)changeHeight;

@end

NS_ASSUME_NONNULL_END
