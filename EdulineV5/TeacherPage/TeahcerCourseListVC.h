//
//  TeahcerCourseListVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TeahcerCourseListVC : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (assign, nonatomic) CGFloat tabelHeight;
@property (strong, nonatomic) NSString *teacherId;
@end

NS_ASSUME_NONNULL_END
