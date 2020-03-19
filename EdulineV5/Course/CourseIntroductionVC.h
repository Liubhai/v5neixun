//
//  CourseIntroductionVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/19.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "CourseMainViewController.h"
#import "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseIntroductionVC : BaseViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate,WKUIDelegate,WKNavigationDelegate,ZLPhotoPickerBrowserViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource>

@property (strong, nonatomic) UIScrollView *mainScroll;
@property (strong ,nonatomic) WKWebView *ClassIntroWeb;
@property (assign, nonatomic) CGFloat tabelHeight;
@property (strong, nonatomic) CourseMainViewController *vc;
@property (assign, nonatomic) BOOL cellTabelCanScroll;
@property (assign, nonatomic) BOOL isZhibo;

@property (strong ,nonatomic)NSDictionary   *dataSource;

- (void)changeMainScrollViewHeight:(CGFloat)changeHeight;

@end

NS_ASSUME_NONNULL_END
