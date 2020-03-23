//
//  CourseSearchListVC.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseSearchListVC.h"
#import "V5_Constant.h"
#import "CourseSearchListCell.h"

@interface CourseSearchListVC ()

@end

@implementation CourseSearchListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = @"课程";
    _leftButton.hidden = YES;
    _cellType = NO;
    if (SWNOTEmptyStr(_themeTitle)) {
        _titleLabel.text = _themeTitle;
        _leftButton.hidden = NO;
    }
    [self makeCollectionView];
}

- (void)makeCollectionView {
    UICollectionViewFlowLayout *cellLayout = [[UICollectionViewFlowLayout alloc] init];
    if (_cellType) {
        cellLayout.itemSize = CGSizeMake((MainScreenWidth - 12) / 2.0, (MainScreenWidth/2.0 - 6 - 15) * 90 / 165.0 + 6 + 20 + 13 + 16 + 10);
        cellLayout.minimumInteritemSpacing = 6;
//        cellLayout.minimumLineSpacing = 0;
    } else {
        cellLayout.itemSize = CGSizeMake(MainScreenWidth, 106);
        cellLayout.minimumInteritemSpacing = 0;
        cellLayout.minimumLineSpacing = 0;
    }
    
    cellLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 45, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45) collectionViewLayout:cellLayout];
    [_collectionView registerClass:[CourseSearchListCell class] forCellWithReuseIdentifier:@"CourseSearchListCell"];
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
    return 3;//_dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CourseSearchListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CourseSearchListCell" forIndexPath:indexPath];
    [cell setCourseListInfo:nil cellIndex:indexPath cellType:_cellType];
    return cell;
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
