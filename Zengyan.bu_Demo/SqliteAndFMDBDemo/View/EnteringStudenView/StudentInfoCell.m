//
//  StudentInfoCell.m
//  StudentInfoDemo
//
//  Created by zengyan.bu on 2017/12/8.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  学生信息明细

#define kCellHeight (44.0f)
#define kNormalLabelWidth (kScreenWidth / 4)
#import "StudentInfoCell.h"
#import "StudentInfoModel.h"

@interface StudentInfoCell()

@property (nonatomic, strong)   UILabel *serialNumberLabel;     /// 序号
@property (nonatomic, strong)   UILabel *studentNumberLabel;    /// 学号
@property (nonatomic, strong)   UILabel *studentNameLabel;      /// 名称
@property (nonatomic, strong)   UILabel *studentSexLabel;       /// 性别
@property (nonatomic, strong)   UILabel *studentAgeLabel;       /// 年龄

@end

@implementation StudentInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

#pragma mark - 初始化控件
- (void)initView{
//    [self.contentView addSubview:self.serialNumberLabel];
    [self.contentView addSubview:self.studentNumberLabel];
    [self.contentView addSubview:self.studentNameLabel];
    [self.contentView addSubview:self.studentSexLabel];
    [self.contentView addSubview:self.studentAgeLabel];
    [self addLineView];
}

- (UILabel *)serialNumberLabel{
    if (!_serialNumberLabel) {
        _serialNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kNormalLabelWidth, kCellHeight)];
        _serialNumberLabel.font = [UIFont systemFontOfSize:14];
        _serialNumberLabel.textColor = [UIColor blackColor];
        _serialNumberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _serialNumberLabel;
}

- (UILabel *)studentNumberLabel{
    if (!_studentNumberLabel) {
        _studentNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kNormalLabelWidth, kCellHeight)];
        _studentNumberLabel.font = [UIFont systemFontOfSize:14];
        _studentNumberLabel.textColor = [UIColor blackColor];
        _studentNumberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _studentNumberLabel;
}

- (UILabel *)studentNameLabel{
    if (!_studentNameLabel) {
        _studentNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kNormalLabelWidth * 1, 0, kNormalLabelWidth, kCellHeight)];
        _studentNameLabel.font = [UIFont systemFontOfSize:14];
        _studentNameLabel.textColor = [UIColor blackColor];
        _studentNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _studentNameLabel;
}

- (UILabel *)studentSexLabel{
    if (!_studentSexLabel) {
        _studentSexLabel = [[UILabel alloc] initWithFrame:CGRectMake(kNormalLabelWidth * 2, 0, kNormalLabelWidth, kCellHeight)];
        _studentSexLabel.font = [UIFont systemFontOfSize:14];
        _studentSexLabel.textColor = [UIColor blackColor];
        _studentSexLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _studentSexLabel;
}

- (UILabel *)studentAgeLabel{
    if (!_studentAgeLabel) {
        _studentAgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kNormalLabelWidth * 3, 0, kNormalLabelWidth, kCellHeight)];
        _studentAgeLabel.font = [UIFont systemFontOfSize:14];
        _studentAgeLabel.textColor = [UIColor blackColor];
        _studentAgeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _studentAgeLabel;
}

- (void)addLineView{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCellHeight - 1, kScreenWidth, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:lineView];
}
#pragma mark - 绑定数据
- (void)bindDataWithModel:(id)model{
    if ([model isKindOfClass:[StudentInfoModel class]]) {
        StudentInfoModel *studentModel = (StudentInfoModel*)model;
//        self.serialNumberLabel.text = studentModel.serialNumber;
        self.studentNumberLabel.text = studentModel.studentNumber;
        self.studentNameLabel.text = studentModel.studentName;
        self.studentSexLabel.text = studentModel.studentSex;
        self.studentAgeLabel.text = studentModel.studentAge;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
