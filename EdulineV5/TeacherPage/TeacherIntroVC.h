//
//  TeacherIntroVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

@interface TeacherIntroVC : BaseViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate,WKUIDelegate,WKNavigationDelegate,ZLPhotoPickerBrowserViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource>

@property (strong, nonatomic) UIScrollView *mainScroll;
@property (strong ,nonatomic) WKWebView *ClassIntroWeb;
@property (assign, nonatomic) CGFloat tabelHeight;

@property (strong ,nonatomic)NSDictionary   *dataSource;
@property (strong, nonatomic) NSString *courseId;

@end

NS_ASSUME_NONNULL_END
