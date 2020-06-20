//
//  HomePageTeacherCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/10.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "HomePageTeacherCell.h"
#import "V5_Constant.h"

@implementation HomePageTeacherCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    _teacherScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 190)];
    _teacherScrollView.backgroundColor = [UIColor whiteColor];
    _teacherScrollView.showsVerticalScrollIndicator = NO;
    _teacherScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_teacherScrollView];
}

- (void)setTeacherArrayInfo:(NSMutableArray *)infoArray {
    [_teacherScrollView removeAllSubviews];
    CGFloat TeaViewWidth = 115;
    CGFloat TeaViewHight = 160;
    
    _teacherScrollView.contentSize = CGSizeMake(15 * 2 + (TeaViewWidth + 12) * infoArray.count - 12, 160 + 30);
    
    for (int i = 0 ; i < infoArray.count; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15 + (TeaViewWidth + 12) * i, 15, TeaViewWidth, TeaViewHight)];
        view.userInteractionEnabled = YES;
        view.tag = i;
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 10;
        view.backgroundColor = EdlineV5_Color.backColor;
        view.layer.shadowColor = HEXCOLOR(0xCDCDCD).CGColor;
        //剪切边界 如果视图上的子视图layer超出视图layer部分就截取掉 如果添加阴影这个属性必须是NO 不然会把阴影切掉
        //阴影半径，默认3
        view.layer.shadowRadius = 3;
        //shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
        view.layer.shadowOffset = CGSizeMake(0.0f,0.0f);
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 0.9f;
        [_teacherScrollView addSubview:view];
        
        //添加头像
        UIImageView *TeaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 80, 80)];
        NSString *urlStr = [NSString stringWithFormat:@"%@",[infoArray[i] objectForKey:@"avatar_url"]];
        [TeaImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:DefaultUserImage];
        TeaImageView.layer.masksToBounds = YES;
        TeaImageView.layer.cornerRadius = 40;
        TeaImageView.centerX = TeaViewWidth / 2.0;
        [view addSubview:TeaImageView];
        
        //添加名字
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(TeaImageView.frame) + 13, TeaViewWidth, 20)];
        name.text = [NSString stringWithFormat:@"%@",[infoArray[i] objectForKey:@"title"]];
        name.textAlignment = NSTextAlignmentCenter;
        name.font = SYSTEMFONT(14);
        name.textColor = EdlineV5_Color.textFirstColor;
        [view addSubview:name];
        
        //添加讲师等级
        UILabel *teacherLevel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(name.frame) + 3, TeaViewWidth, 17)];
        teacherLevel.text = [NSString stringWithFormat:@"%@",[infoArray[i] objectForKey:@"level_text"]];
        teacherLevel.textAlignment = NSTextAlignmentCenter;
        teacherLevel.font = SYSTEMFONT(12);
        teacherLevel.textColor = EdlineV5_Color.textThirdColor;
        [view addSubview:teacherLevel];
        
        //添加手势
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(teacherViewClick:)]];
    }
    [_teacherScrollView setHeight:infoArray.count > 0 ? 190 : 0];
    [self setHeight:infoArray.count > 0 ? 190 : 0];
}

- (void)teacherViewClick:(UITapGestureRecognizer *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(goToTeacherMainPage:)]) {
        [_delegate goToTeacherMainPage:sender.view.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
