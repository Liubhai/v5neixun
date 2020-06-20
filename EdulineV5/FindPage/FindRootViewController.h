//
//  FindRootViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FindRootViewController : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL cellType;// 一排两个还是一排一个

@end

NS_ASSUME_NONNULL_END
