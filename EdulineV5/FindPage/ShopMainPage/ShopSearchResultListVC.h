//
//  ShopSearchResultListVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2022/11/1.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopSearchResultListVC : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *searchKeyWord;

@end

NS_ASSUME_NONNULL_END
