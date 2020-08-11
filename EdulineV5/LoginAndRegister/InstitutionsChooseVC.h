//
//  InstitutionsChooseVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/8/11.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface InstitutionsChooseVC : BaseViewController

@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UITextField *searchTextF;
@property (strong, nonatomic) UIView *historyView;
@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) NSMutableArray *searchDataSource;
@property (strong, nonatomic) UIButton *moreBtn;


@end

NS_ASSUME_NONNULL_END
