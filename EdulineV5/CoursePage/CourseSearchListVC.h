//
//  CourseSearchListVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseSearchListVC : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSString *themeTitle;// 顶部标题
@property (strong, nonatomic) NSString *searchKeyWord;// 顶部标题
@property (assign, nonatomic) BOOL isSearch;// yes 是首页过来的搜索页面 no 课程列表主页

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic) NSString *cateStr;// 首页各种分类跳转过来的时候会传递参数
@property (nonatomic, assign) BOOL cellType;// 一排两个还是一排一个

@end

NS_ASSUME_NONNULL_END
