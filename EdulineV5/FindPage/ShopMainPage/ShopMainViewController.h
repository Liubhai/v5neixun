//
//  ShopMainViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/8/12.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopMainViewController : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

NS_ASSUME_NONNULL_END
