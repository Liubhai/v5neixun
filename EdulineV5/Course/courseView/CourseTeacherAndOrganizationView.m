//
//  CourseTeacherAndOrganizationView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/17.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "CourseTeacherAndOrganizationView.h"

@implementation CourseTeacherAndOrganizationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    _teachersHeaderScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 55)];
    _teachersHeaderScrollView.showsVerticalScrollIndicator = NO;
    _teachersHeaderScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_teachersHeaderScrollView];
    
    UIView *downLine = [[UIView alloc] initWithFrame:CGRectMake(0, _teachersHeaderScrollView.bottom, MainScreenWidth, 4)];
    downLine.backgroundColor = EdlineV5_Color.fengeLineColor;
    [self addSubview:downLine];
}

// MARK: - 机构讲师信息赋值
- (void)setTeacherAndOrganizationData:(NSDictionary *)schoolInfo teacherInfo:(NSDictionary *)teacherInfoDict {
    _schoolInfo = schoolInfo;
    _teacherInfoDict = teacherInfoDict;
    if (SWNOTEmptyDictionary(_schoolInfo)) {
        [self setHeight:59];
        self.hidden = NO;
        UIImageView *schoolFace = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 40, 40)];
        UITapGestureRecognizer *schoolTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(instViewClick:)];
        [schoolFace addGestureRecognizer:schoolTap];
        schoolFace.userInteractionEnabled = YES;
        schoolFace.layer.masksToBounds = YES;
        schoolFace.layer.cornerRadius = 20;
        schoolFace.clipsToBounds = YES;
        schoolFace.contentMode = UIViewContentModeScaleAspectFill;
        [schoolFace sd_setImageWithURL:[NSURL URLWithString:SWNOTEmptyStr([_schoolInfo objectForKey:@"logo"]) ? [_schoolInfo objectForKey:@"logo"] : @""] placeholderImage:DefaultImage];
        [_teachersHeaderScrollView addSubview:schoolFace];
        UILabel *schoolName = [[UILabel alloc] initWithFrame:CGRectMake(schoolFace.right + 5, 15, 0, 14)];
        schoolName.textColor = EdlineV5_Color.textFirstColor;
        schoolName.font = SYSTEMFONT(13);
        schoolName.text = [NSString stringWithFormat:@"%@",[_schoolInfo objectForKey:@"title"]];
        [_teachersHeaderScrollView addSubview:schoolName];
        UILabel *schoolOwn = [[UILabel alloc] initWithFrame:CGRectMake(schoolFace.right + 5, schoolName.bottom, 0, 18)];
        schoolOwn.text = @"所属机构";
        schoolOwn.textColor = EdlineV5_Color.textThirdColor;
        schoolOwn.font = SYSTEMFONT(10);
        [_teachersHeaderScrollView addSubview:schoolOwn];
        CGFloat schoolnameWidth = [schoolName.text sizeWithFont:schoolName.font].width + 4;
        CGFloat schoolOwnWidth = [schoolOwn.text sizeWithFont:schoolOwn.font].width + 4;
        [schoolName setWidth:schoolnameWidth];
        [schoolOwn setWidth:schoolOwnWidth];
        if (SWNOTEmptyDictionary(_teacherInfoDict)) {
            UIImageView *teacherFace = [[UIImageView alloc] initWithFrame:CGRectMake(schoolnameWidth > schoolOwnWidth ? (schoolName.right + 20) : (schoolOwn.right + 20), 7, 40, 40)];
            UITapGestureRecognizer *teacherTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(teacherViewClick:)];
            [teacherFace addGestureRecognizer:teacherTap];
            teacherFace.userInteractionEnabled = YES;
            teacherFace.layer.masksToBounds = YES;
            teacherFace.layer.cornerRadius = 20;
            teacherFace.clipsToBounds = YES;
            teacherFace.contentMode = UIViewContentModeScaleAspectFill;
            [teacherFace sd_setImageWithURL:[NSURL URLWithString:[_teacherInfoDict objectForKey:@"avatar_url"]] placeholderImage:DefaultImage];
            [_teachersHeaderScrollView addSubview:teacherFace];
            UILabel *teacherName = [[UILabel alloc] initWithFrame:CGRectMake(teacherFace.right + 5, 15, 0, 14)];
            teacherName.textColor = EdlineV5_Color.textFirstColor;
            teacherName.font = SYSTEMFONT(13);
            teacherName.text = [NSString stringWithFormat:@"%@",[_teacherInfoDict objectForKey:@"title"]];
            [_teachersHeaderScrollView addSubview:teacherName];
            UILabel *taecherOwn = [[UILabel alloc] initWithFrame:CGRectMake(teacherFace.right + 5, teacherName.bottom, 0, 18)];
            taecherOwn.text = @"主讲老师";
            taecherOwn.textColor = EdlineV5_Color.textThirdColor;
            taecherOwn.font = SYSTEMFONT(10);
            [_teachersHeaderScrollView addSubview:taecherOwn];
            CGFloat teacherNameWidth = [teacherName.text sizeWithFont:teacherName.font].width + 4;
            CGFloat taecherOwnWidth = [taecherOwn.text sizeWithFont:taecherOwn.font].width + 4;
            [teacherName setWidth:teacherNameWidth];
            [taecherOwn setWidth:taecherOwnWidth];
        }
    }
}

// MARK: - 讲师点击事件
- (void)teacherViewClick:(UIGestureRecognizer *)ges {
    if (_delegate && [_delegate respondsToSelector:@selector(jumpToTeacher:tapTag:)]) {
        [_delegate jumpToTeacher:_teacherInfoDict tapTag:0];
    }
}

// MARK: - 机构点击事件
- (void)instViewClick:(UIGestureRecognizer *)ges {
    if (_delegate && [_delegate respondsToSelector:@selector(jumpToOrganization:)]) {
        [_delegate jumpToOrganization:_schoolInfo];
    }
}

@end
