//
//  ShopMainViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/8/12.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ShopMainViewController.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "ShopMainListCell.h"

@interface ShopMainViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *institutionSearch;
@property (strong, nonatomic) UIImageView *shopFaceImage;
@property (strong, nonatomic) UIView *cateView;//分类视图

@end

@implementation ShopMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = EdlineV5_Color.backColor;
    
    _dataSource = [NSMutableArray new];
    
    _shopFaceImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 213)];
    _shopFaceImage.clipsToBounds = YES;
    _shopFaceImage.contentMode = UIViewContentModeScaleAspectFill;
    _shopFaceImage.image = Image(@"store_banner");
    [self.view addSubview:_shopFaceImage];
    
    [self makeTopSearch];
    _titleImage.backgroundColor = [UIColor clearColor];
    _lineTL.hidden = YES;
    [self.view bringSubviewToFront:_titleImage];
    
    [self makeCateView];
    
    
    UILabel *tuijian = [[UILabel alloc] initWithFrame:CGRectMake(0, _cateView.bottom + 20, 57, 28)];
    tuijian.font = SYSTEMFONT(20);
    tuijian.textColor = EdlineV5_Color.textFirstColor;
    tuijian.text = @"推荐";
    tuijian.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tuijian];
    tuijian.centerX = MainScreenWidth / 2.0;
    
    UIImageView *tuijianLeft = [[UIImageView alloc] initWithFrame:CGRectMake(tuijian.left - 10 - 19, 0, 19, 9)];
    tuijianLeft.image = Image(@"title_icon_left");
    tuijianLeft.centerY = tuijian.centerY;
    [self.view addSubview:tuijianLeft];
    
    UIImageView *tuijianRight = [[UIImageView alloc] initWithFrame:CGRectMake(tuijian.right + 10, 0, 19, 9)];
    tuijianRight.image = Image(@"title_icon_right");
    tuijianRight.centerY = tuijian.centerY;
    [self.view addSubview:tuijianRight];
    
    [self makeCollectionView];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCourseMainList)];
    _collectionView.mj_footer.hidden = YES;
    [_collectionView.mj_header beginRefreshing];
    [_collectionView reloadData];
    [EdulineV5_Tool adapterOfIOS11With:_collectionView];
    
    // Do any additional setup after loading the view.
}

- (void)makeTopSearch {
    // 顶部搜索框和 取消按钮
    _institutionSearch = [[UITextField alloc] initWithFrame:CGRectMake(_leftButton.right, _titleLabel.top, MainScreenWidth - 15 - _leftButton.right , 36)];
    _institutionSearch.font = SYSTEMFONT(14);
    _institutionSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索商品名称" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _institutionSearch.delegate = self;
    _institutionSearch.returnKeyType = UIReturnKeySearch;
    _institutionSearch.layer.cornerRadius = 18;
    _institutionSearch.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.3].CGColor;//backgroundColor = EdlineV5_Color.backColor;
    _institutionSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    _institutionSearch.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 42, 30)];
    _institutionSearch.leftViewMode = UITextFieldViewModeAlways;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(17, 7.5, 15, 15)];
    [button setImage:Image(@"shop_serch_icon") forState:UIControlStateNormal];
    [_institutionSearch.leftView addSubview:button];
    [_titleImage addSubview:_institutionSearch];
}

- (void)makeCateView {
    _cateView = [[UIView alloc] initWithFrame:CGRectMake(15, 167, MainScreenWidth - 30, 140)];
    _cateView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    _cateView.layer.cornerRadius = 7;
    _cateView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08].CGColor;
    _cateView.layer.shadowOpacity = 1;// 阴影透明度，默认0
    _cateView.layer.shadowOffset = CGSizeMake(0, 1);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    _cateView.layer.shadowRadius = 12;
    [self setCateUI];
    [self.view addSubview:_cateView];
}

- (void)setCateUI {
    int count = arc4random() % 9;
    count = (count>8?8:count);
    int m = 0;
    CGFloat HH = 28 + 4 + 16;
    for (int i = 0; i < count; i++) {
        m = i/4;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((i%4)*(_cateView.width/4), m * (HH + 15) + 15, _cateView.width/4, HH);
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        img.clipsToBounds = YES;
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.centerX = btn.width / 2.0;
        img.image = DefaultImage;
//        NSString *imageName = [info[i] objectForKey:@"icon"];
//        if (SWNOTEmptyStr(imageName)) {
//            [img sd_setImageWithURL:EdulineUrlString(imageName) placeholderImage:DefaultImage];
//        } else {
//            img.image = DefaultImage;
//        }
        [btn addSubview:img];
        UILabel *titlelL = [[UILabel alloc] initWithFrame:CGRectMake(0, img.bottom + 4, _cateView.width/4, 16)];
        titlelL.font = SYSTEMFONT(13);
        titlelL.textColor = EdlineV5_Color.textSecendColor;
        titlelL.textAlignment = NSTextAlignmentCenter;
        titlelL.text = @"草泥马";//[info[i] objectForKey:@"title"];
        [btn addSubview:titlelL];
        btn.tag = 66 + i;
        [btn addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cateView addSubview:btn];
        if (i == (count - 1)) {
            [_cateView setHeight:btn.bottom + 15];
        }
    }
}

- (void)typeButtonClick:(UIButton *)sender {
}

- (void)makeCollectionView {
    UICollectionViewFlowLayout *cellLayout = [[UICollectionViewFlowLayout alloc] init];
    cellLayout.itemSize = CGSizeMake(MainScreenWidth / 2.0, (MainScreenHeight - MACRO_UI_UPHEIGHT - 20 * 2)/2.0);
    cellLayout.minimumInteritemSpacing = 0;
    cellLayout.minimumLineSpacing = 0;
    
    cellLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _cateView.bottom + 20 + 28 + 20, MainScreenWidth, MainScreenHeight - (_cateView.bottom + 20 + 28 + 20)) collectionViewLayout:cellLayout];
    [_collectionView registerClass:[ShopMainListCell class] forCellWithReuseIdentifier:@"ShopMainListCell"];
    _collectionView.backgroundColor = EdlineV5_Color.backColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
}

// MARK: - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 0, 20, 0);//分别为上、左、下、右
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShopMainListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShopMainListCell" forIndexPath:indexPath];
    [cell setShopMainListInfo:_dataSource[indexPath.row] cellIndex:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


//版块类型【1:知识点练习  2: 专项练习 3:公开考试 4: 套卷练习】

- (void)getCourseMainList {
    [_collectionView collectionViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:0 isLoading:YES tableViewShowHeight:_collectionView.height];
    [Net_API requestGETSuperAPIWithURLStr:[Net_Path examMainPageNet] WithAuthorization:nil paramDic:nil finish:^(id  _Nonnull responseObject) {
        [_collectionView.mj_header endRefreshing];
        if (SWNOTEmptyDictionary(responseObject)) {
            if ([[responseObject objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[responseObject objectForKey:@"data"]];
                [_collectionView collectionViewDisplayWitMsg:@"暂无内容～" img:@"empty_img" ifNecessaryForRowCount:_dataSource.count isLoading:NO tableViewShowHeight:_collectionView.height];
                [_collectionView reloadData];
            }
        }
    } enError:^(NSError * _Nonnull error) {
        [_collectionView.mj_header endRefreshing];
    }];
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
