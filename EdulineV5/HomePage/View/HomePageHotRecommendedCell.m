//
//  HomePageHotRecommendedCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/8.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "HomePageHotRecommendedCell.h"
#import "V5_Constant.h"

@implementation HomePageHotRecommendedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
}

- (void)setRecommendCourseCellInfo:(NSArray *)recommendArray {
    [self removeAllSubviews];
    NSMutableArray *pass = [NSMutableArray new];
    for (int i = 0; i<recommendArray.count; i++) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, MainScreenWidth - 100 - 15, 172)];
        backView.backgroundColor = [UIColor whiteColor];
        backView.tag = 100 + i;
        
        UIImageView *face = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (MainScreenWidth - 100)-30, 136)];
        [face sd_setImageWithURL:EdulineUrlString(@"http://v5.51eduline.com/storage/upload/20200518/f577433b3d66563404a232f21f96bfec.jpg") placeholderImage:DefaultImage];//[recommendArray[i] objectForKey:@"cover_url"]
        face.clipsToBounds = YES;
        face.contentMode = UIViewContentModeScaleAspectFill;
        face.layer.masksToBounds = YES;
        face.layer.cornerRadius = 8;
        [backView addSubview:face];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, face.bottom + 5, face.width, 21)];
        titleLabel.text = @"建筑设计师考证系列课程列课程…";//[NSString stringWithFormat:@"%@",[recommendArray[i] objectForKey:@"title"]];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = SYSTEMFONT(15);
        titleLabel.textColor = EdlineV5_Color.textFirstColor;
        [backView addSubview:titleLabel];
        [pass addObject:backView];
    }
    /**初始化配置项*/
    ZPScrollerScaleViewConfig * config = [[ZPScrollerScaleViewConfig alloc]init];
    config.scaleMin = 0.9;
    config.scaleMax = 1;
    config.pageSize = CGSizeMake(MainScreenWidth - 100, 172);
    config.ItemMaingin = 15;
    
    /**初始化滚动缩放视图*/
    ZPScrollerScaleView *scrollerView = [[ZPScrollerScaleView alloc] initWithConfig:config];
    scrollerView.frame = CGRectMake(0, 15, MainScreenWidth, 172);
    
    //至少要是等于 2-8
    scrollerView.defalutIndex = 2;
    scrollerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:scrollerView];
    //2:将子视图数组传递 ZPScrollerScaleView
    scrollerView.items = pass;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
