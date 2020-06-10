//
//  InstitutionCourseMainVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/10.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface InstitutionCourseMainVC : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic) NSString *institutionID;// 首页各种分类跳转过来的时候会传递参数

@end

NS_ASSUME_NONNULL_END
