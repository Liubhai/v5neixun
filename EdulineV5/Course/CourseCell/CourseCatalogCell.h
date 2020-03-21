//
//  CourseCatalogCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/19.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseCatalogCell : UITableViewCell<UITableViewDelegate, UITableViewDataSource>

//@property (strong, nonatomic) UIView *blueView;
//@property (strong, nonatomic) UILabel *firstTitle;
//@property (strong, nonatomic) UIButton *firstRightBtn;
//@property (strong, nonatomic) UIView *firstLine;

//@property (strong, nonatomic) UILabel *secondTitle;
//@property (strong, nonatomic) UIButton *secondRightBtn;

@property (strong, nonatomic) UIImageView *typeIcon;
@property (strong, nonatomic) UIImageView *lockIcon;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UIButton *courseRightBtn;
@property (strong, nonatomic) UIImageView *learnIcon;
@property (strong, nonatomic) UILabel *learnTimeLabel;
@property (strong, nonatomic) UIImageView *isLearningIcon;



@property (strong, nonatomic) UITableView *cellTableView;
@property (assign, nonatomic) BOOL isClassNew;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIView *cellTableViewSpace;
@property (assign, nonatomic) NSInteger cellRow;
@property (assign, nonatomic) NSInteger cellSection;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier isClassNew:(BOOL)isClassNew cellSection:(NSInteger)cellSection cellRow:(NSInteger)cellRow;

@end

NS_ASSUME_NONNULL_END
