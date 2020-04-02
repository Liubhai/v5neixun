//
//  FindRootViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "FindRootViewController.h"
#import "V5_Constant.h"
#import "FindListCell.h"

@interface FindRootViewController ()

@end

@implementation FindRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _leftButton.hidden = YES;
    _cellType = YES;
    _dataSource = [NSMutableArray new];
    if (_cellType) {
        [_dataSource addObjectsFromArray:@[@{@"image":@"find_album_icon",@"title":@"专辑课"},@{@"image":@"find_test_icon",@"title":@"考试"},@{@"image":@"find_library_icon",@"title":@"文库"},@{@"image":@"find_q&a_icon",@"title":@"问答"},@{@"image":@"find_news_icon",@"title":@"资讯"},@{@"image":@"find_pengyouquan_icon",@"title":@"朋友圈"},@{@"image":@"find_pengyouquan_icon",@"title":@"商城"}]];
    } else {
        [_dataSource addObjectsFromArray:@[@{@"image":@"find_album_list",@"title":@"专辑课"},@{@"image":@"find_test_list",@"title":@"考试"},@{@"image":@"find_library_list",@"title":@"文库"},@{@"image":@"find_q&a_list",@"title":@"问答"},@{@"image":@"find_news_list",@"title":@"资讯"},@{@"image":@"find_pengyouquan_list",@"title":@"朋友圈"},@{@"image":@"find_pengyouquan_list",@"title":@"商城"}]];
    }
    _titleLabel.text = @"发现";
    [_titleLabel setLeft:15];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self makeCollectionView];
}

- (void)makeCollectionView {
    UICollectionViewFlowLayout *cellLayout = [[UICollectionViewFlowLayout alloc] init];
    if (_cellType) {
        cellLayout.itemSize = CGSizeMake((MainScreenWidth - 6) / 2.0, (MainScreenWidth - 6) / 2.0);
        cellLayout.minimumInteritemSpacing = 0;
        cellLayout.minimumLineSpacing = 0;
    } else {
        cellLayout.itemSize = CGSizeMake(MainScreenWidth, 50);
        cellLayout.minimumInteritemSpacing = 0;
        cellLayout.minimumLineSpacing = 0;
    }
    
    cellLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_TABBAR_HEIGHT) collectionViewLayout:cellLayout];
    [_collectionView registerClass:[FindListCell class] forCellWithReuseIdentifier:@"FindListCell"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
}

// MARK: - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FindListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FindListCell" forIndexPath:indexPath];
    [cell setFindListInfo:_dataSource[indexPath.row] cellIndex:indexPath cellType:_cellType];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
