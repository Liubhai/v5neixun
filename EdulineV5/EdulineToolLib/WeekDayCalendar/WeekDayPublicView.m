//
//  WeekDayPublicView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/12/15.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "WeekDayPublicView.h"
#import "WeekDayCollectionViewCell.h"

@interface WeekDayPublicView () <WeekDayCollectionViewCellDelegate> {
    NSInteger sundayApart;// 当天和上一个星期天相差多久
    NSInteger selectedRow;// 选中的点击的下标
    NSString *currentYYMMDD;// 当前天的年月日格式
}

@end

@implementation WeekDayPublicView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.nsdateArray = [[NSMutableArray alloc] init];
        self.dateArray = [[NSMutableArray alloc] init];
        self.hasClassScheduleArray = [[NSMutableArray alloc] init];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        currentYYMMDD = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
        selectedRow = 30;
        [self initDataSource];
        [self makeCollectionView];
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:30 + (7 - sundayApart - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    return self;
}

// MARK: - 准备当前这天前后一个月时间的数据
- (void)initDataSource {
    /// 前后一个月数据(年月日周数组形式)
    self.dateArray = [self getDateArrCarFro:30 chaTo:30];
    /// 前后一个月数据(date形式)
    self.nsdateArray = [self getNsDateArrCarFro:30 chaTo:30];
    
    sundayApart = [self getLocalDayChaToSunday:[self getNowWeek]];
}

- (void)makeCollectionView {
    
    UICollectionViewFlowLayout *cellLayout = [[UICollectionViewFlowLayout alloc] init];
    cellLayout.itemSize = CGSizeMake(MainScreenWidth/7.0, 78);
    cellLayout.minimumInteritemSpacing = 0;
    cellLayout.minimumLineSpacing = 0;
    
    cellLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cellLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 78) collectionViewLayout:cellLayout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[WeekDayCollectionViewCell class] forCellWithReuseIdentifier:@"WeekDayCollectionViewCell"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:_collectionView];
}

// MARK: - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _nsdateArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WeekDayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WeekDayCollectionViewCell" forIndexPath:indexPath];
    [cell setWeekCellDeatilInfo:self.nsdateArray[indexPath.row] hasWeekDayArray:self.dateArray[indexPath.row] isSelected:(indexPath.row == selectedRow) ? YES : NO currentDay:currentYYMMDD cellindexpath:indexPath hasScheduleArray:_hasClassScheduleArray];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    selectedRow = indexPath.row;
    [_collectionView reloadData];
    // 处理点击后的UI变化效果
    if (_delegate && [_delegate respondsToSelector:@selector(selectedDay:)]) {
        [_delegate selectedDay:self.dateArray[indexPath.row]];
    }
}

- (void)reloadDataHasClassScheculeList:(NSMutableArray *)array {
    if (SWNOTEmptyArr(array)) {
        [_hasClassScheduleArray removeAllObjects];
        [_hasClassScheduleArray addObjectsFromArray:array];
        [_collectionView reloadData];
    }
}

//// 获取当前这个星期格式化的时间
- (NSMutableArray *)getDateArrCarFro:(NSInteger)chafro chaTo:(NSInteger)chato{
    NSMutableArray *dateArr = [NSMutableArray array];
    for (NSInteger i = 1; i<=chafro; i++) {
        NSDate * date = [NSDate date];//当前时间
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60*i sinceDate:date];//前i天
        [dateArr insertObject:[self getDateArr:lastDay] atIndex:0];
    }
    [dateArr addObject:[self getDateArr:[NSDate date]]];
    for (NSInteger i = 1; i<=chato; i++) {
        NSDate * date = [NSDate date];//当前时间
        NSDate *lastDay = [NSDate dateWithTimeInterval:+24*60*60*i sinceDate:date];//后i天
        [dateArr addObject:[self getDateArr:lastDay]];
    }
    return dateArr;
}

//// 获取当前这个星期标准时间
- (NSMutableArray *)getNsDateArrCarFro:(NSInteger)chafro chaTo:(NSInteger)chato{
    NSMutableArray *dateArr = [NSMutableArray array];
    for (NSInteger i = 1; i<=chafro; i++) {
        NSDate * date = [NSDate date];//当前时间
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60*i sinceDate:date];//前i天
        [dateArr insertObject:lastDay atIndex:0];
    }
    [dateArr addObject:[NSDate date]];
    for (NSInteger i = 1; i<=chato; i++) {
        NSDate * date = [NSDate date];//当前时间
        NSDate *lastDay = [NSDate dateWithTimeInterval:+24*60*60*i sinceDate:date];//后i天
        [dateArr addObject:lastDay];
    }
    return dateArr;
}

//// 获取当前日期 显示为标题时间
- (NSString *)getNowDate:(NSDate *)senddate{
    //获取系统当前的时间
    NSCalendar *cal=[NSCalendar  currentCalendar];
    NSUInteger unitFlags= NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday;
    NSDateComponents *conponent= [cal components:unitFlags fromDate:senddate];
    //获取年、月、日
    NSInteger year =  [conponent year];
    NSInteger month = [conponent month];
    NSInteger day   = [conponent day];
    //周
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"EEEE"];
    NSString *weekString = [dateformatter stringFromDate:senddate];
    NSString *dateStr = [NSString stringWithFormat:@"%ld年%ld月%ld日 %@",year,month,day,[self getLocalWeekChinese:weekString]];
    return dateStr;
}

//根据传进来的date 返回一个由 年，月，日 星期组成的数组。。。。
- (NSArray *)getDateArr:(NSDate *)senddate{
    NSCalendar *cal=[NSCalendar  currentCalendar];
    NSUInteger unitFlags= NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday;
    NSDateComponents *conponent= [cal components:unitFlags fromDate:senddate];
    //获取年、月、日
    NSInteger year =  [conponent year];
    NSInteger month = [conponent month];
    NSInteger day   = [conponent day];
    //周
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"EEEE"];
    NSString *weekString = [dateformatter stringFromDate:senddate];
    NSArray *arr = @[[NSString stringWithFormat:@"%ld",year],[NSString stringWithFormat:@"%ld",month],[NSString stringWithFormat:@"%ld",day],[self getLocalWeekChinese:weekString]];
    return arr;
}

/// 获取当前这天是星期几
- (NSString *)getNowWeek{
    NSDate  * senddate=[NSDate date];
    //周
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"EEEE"];
    NSString *weekString = [dateformatter stringFromDate:senddate];
    return weekString;
}

/// 计算当前这天与周一相差几天
- (NSInteger)getDayChafromMonday:(NSString *)week{
    if ([week isEqualToString:@"Monday"]) {
        return 0;
    }else if ([week isEqualToString:@"Tuesday"]){
        return 1;
    }else if ([week isEqualToString:@"Wednesday"]){
        return 2;
    }else if ([week isEqualToString:@"Thursday"]){
        return 3;
    }else if ([week isEqualToString:@"Friday"]){
        return 4;
    }else if ([week isEqualToString:@"Saturday"]){
        return 5;
    }else{
        return 6;
    }
}

/// 计算当前这天与周日相差几天
- (NSInteger)getDayChaToSunday:(NSString *)week{
    if ([week isEqualToString:@"Monday"]) {
        return 6;
    }else if ([week isEqualToString:@"Tuesday"]){
        return 5;
    }else if ([week isEqualToString:@"Wednesday"]){
        return 4;
    }else if ([week isEqualToString:@"Thursday"]){
        return 3;
    }else if ([week isEqualToString:@"Friday"]){
        return 2;
    }else if ([week isEqualToString:@"Saturday"]){
        return 1;
    }else{
        return 0;
    }
}

/// 计算当前这天与周日相差几天
- (NSInteger)getLocalDayChaToSunday:(NSString *)week{
    if ([week isEqualToString:@"星期一"]) {
        return 1;
    }else if ([week isEqualToString:@"星期二"]){
        return 2;
    }else if ([week isEqualToString:@"星期三"]){
        return 3;
    }else if ([week isEqualToString:@"星期四"]){
        return 4;
    }else if ([week isEqualToString:@"星期五"]){
        return 5;
    }else if ([week isEqualToString:@"星期六"]){
        return 6;
    }else{
        return 0;
    }
}

- (NSString *)getWeekChinese:(NSString *)week{
    if ([week isEqualToString:@"Monday"]) {
        return @"一";
    }else if ([week isEqualToString:@"Tuesday"]){
        return @"二";
    }else if ([week isEqualToString:@"Wednesday"]){
        return @"三";
    }else if ([week isEqualToString:@"Thursday"]){
        return @"四";
    }else if ([week isEqualToString:@"Friday"]){
        return @"五";
    }else if ([week isEqualToString:@"Saturday"]){
        return @"六";
    }else{
        return @"日";
    }
}

- (NSString *)getLocalWeekChinese:(NSString *)week{
    if ([week isEqualToString:@"星期一"]) {
        return @"一";
    }else if ([week isEqualToString:@"星期二"]){
        return @"二";
    }else if ([week isEqualToString:@"星期三"]){
        return @"三";
    }else if ([week isEqualToString:@"星期四"]){
        return @"四";
    }else if ([week isEqualToString:@"星期五"]){
        return @"五";
    }else if ([week isEqualToString:@"星期六"]){
        return @"六";
    }else{
        return @"日";
    }
}

- (void)cellDayButtonClick:(NSIndexPath *)cellIndexPath {
    selectedRow = cellIndexPath.row;
    [_collectionView reloadData];
    // 处理点击后的UI变化效果
    if (_delegate && [_delegate respondsToSelector:@selector(selectedDay:)]) {
        [_delegate selectedDay:self.dateArray[cellIndexPath.row]];
    }
}

// MARK: - 回到当前日期
- (void)fastReturnToToday {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:30 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:30 inSection:0]];
}

@end
