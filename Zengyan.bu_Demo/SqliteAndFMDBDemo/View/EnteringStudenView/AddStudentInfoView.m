//
//  AddStudentInfoView.m
//  StudentInfoDemo
//
//  Created by zengyan.bu on 2017/12/8.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  录入学生信息视图

#define kTextFeildHeight (44.0f)
#define kAddStudentInfoViewHeight kTextFeildHeight * 6
#define kLeftLabelWidth (kScreenWidth / 3)
#define kTextFeildWidth (kScreenWidth - kLeftLabelWidth)
#define kButtonWidth (kScreenWidth / 3)
#import "AddStudentInfoView.h"

@interface AddStudentInfoView() <UITextFieldDelegate>

@property (nonatomic, strong)   UILabel     *headerLabel;
@property (nonatomic, strong)   UITextField *studentNumberTextFeild;    ///
@property (nonatomic, strong)   UITextField *studentNameTextFeild;
@property (nonatomic, strong)   UITextField *studentSexTextFeild;
@property (nonatomic, strong)   UITextField *studentAgeTextFeild;
@property (nonatomic, strong)   NSMutableArray  *leftStrArray;  /// 提示语数组
@property (nonatomic, strong)   UIButton    *deleteButton;      /// 删除button
@property (nonatomic, strong)   UIButton    *cancelButton;      /// 取消button
@property (nonatomic, strong)   UIButton    *addButton;

@property (nonatomic, copy)     NSString    *studentNumber;
@property (nonatomic, copy)     NSString    *studentName;
@property (nonatomic, copy)     NSString    *studentSex;
@property (nonatomic, copy)     NSString    *studentAge;

@end

@implementation AddStudentInfoView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始数据源
- (NSMutableArray *)leftStrArray{
    if (!_leftStrArray) {
        _leftStrArray = [[NSMutableArray alloc] initWithObjects:@"学号:",@"姓名:",@"性别:",@"年龄:", nil];
    }
    return _leftStrArray;
}
#pragma mark - 初始化控件
- (void)initView{
    [self addSubview:self.headerLabel];
    [self addLeftRemindLabel];
    [self addSubview:self.studentNumberTextFeild];
    [self addSubview:self.studentNameTextFeild];
    [self addSubview:self.studentSexTextFeild];
    [self addSubview:self.studentAgeTextFeild];
    [self addSubview:self.deleteButton];
    [self addSubview:self.cancelButton];
    [self addSubview:self.addButton];
}

- (UILabel *)headerLabel{
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTextFeildHeight)];
        _headerLabel.backgroundColor = UIColorHex(0x0079BF);
        _headerLabel.textColor = [UIColor whiteColor];
        _headerLabel.font = [UIFont boldSystemFontOfSize:16];
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        _headerLabel.text = @"录入学生信息";
    }
    return _headerLabel;
}

- (void)addLeftRemindLabel{
    for (int i = 0; i < self.leftStrArray.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, kTextFeildHeight + kTextFeildHeight * i, kLeftLabelWidth, kTextFeildHeight);
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        label.text = [self.leftStrArray objectAtIndex:i];
        label.layer.masksToBounds = YES;
        label.layer.borderWidth = 1;
        label.layer.borderColor = UIColorHex(0x0079BF).CGColor;
        label.layer.cornerRadius = 0;
        [self addSubview:label];
    }
}

- (UITextField *)studentNumberTextFeild{
    if (!_studentNumberTextFeild) {
        _studentNumberTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(kLeftLabelWidth, kTextFeildHeight, kTextFeildWidth, kTextFeildHeight)];
        _studentNumberTextFeild.placeholder = @"请输入学号";
        _studentNumberTextFeild.layer.masksToBounds = YES;
        _studentNumberTextFeild.layer.borderColor = UIColorHex(0x0079BF).CGColor;
        _studentNumberTextFeild.layer.borderWidth = 1;
        _studentNumberTextFeild.tag = 111;
        _studentNumberTextFeild.delegate = self;
        _studentNumberTextFeild.leftViewMode = UITextFieldViewModeAlways;
        _studentNumberTextFeild.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, kTextFeildHeight)];
    }
    return _studentNumberTextFeild;
}

- (UITextField *)studentNameTextFeild{
    if (!_studentNameTextFeild) {
        _studentNameTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(kLeftLabelWidth, kTextFeildHeight * 2, kTextFeildWidth, kTextFeildHeight)];
        _studentNameTextFeild.placeholder = @"请输入姓名";
        _studentNameTextFeild.layer.masksToBounds = YES;
        _studentNameTextFeild.layer.borderColor = UIColorHex(0x0079BF).CGColor;
        _studentNameTextFeild.layer.borderWidth = 1;
        _studentNameTextFeild.tag = 222;
        _studentNameTextFeild.delegate = self;
        _studentNameTextFeild.leftViewMode = UITextFieldViewModeAlways;
        _studentNameTextFeild.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, kTextFeildHeight)];
    }
    return _studentNameTextFeild;
}

- (UITextField *)studentSexTextFeild{
    if (!_studentSexTextFeild) {
        _studentSexTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(kLeftLabelWidth, kTextFeildHeight * 3, kTextFeildWidth, kTextFeildHeight)];
        _studentSexTextFeild.placeholder = @"请输入性别";
        _studentSexTextFeild.layer.masksToBounds = YES;
        _studentSexTextFeild.layer.borderColor = UIColorHex(0x0079BF).CGColor;
        _studentSexTextFeild.layer.borderWidth = 1;
        _studentSexTextFeild.tag = 333;
        _studentSexTextFeild.delegate = self;
        _studentSexTextFeild.leftViewMode = UITextFieldViewModeAlways;
        _studentSexTextFeild.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, kTextFeildHeight)];
    }
    return _studentSexTextFeild;
}

- (UITextField *)studentAgeTextFeild{
    if (!_studentAgeTextFeild) {
        _studentAgeTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(kLeftLabelWidth, kTextFeildHeight * 4, kTextFeildWidth, kTextFeildHeight)];
        _studentAgeTextFeild.placeholder = @"请输入年龄";
        _studentAgeTextFeild.layer.masksToBounds = YES;
        _studentAgeTextFeild.layer.borderColor = UIColorHex(0x0079BF).CGColor;
        _studentAgeTextFeild.layer.borderWidth = 1;
        _studentAgeTextFeild.tag = 444;
        _studentAgeTextFeild.delegate = self;
        _studentAgeTextFeild.leftViewMode = UITextFieldViewModeAlways;
        _studentAgeTextFeild.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, kTextFeildHeight)];
    }
    return _studentAgeTextFeild;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(0, kTextFeildHeight * 5, kButtonWidth, kTextFeildHeight);
        _deleteButton.layer.masksToBounds = YES;
        _deleteButton.layer.borderColor = UIColorHex(0x0079BF).CGColor;
        _deleteButton.layer.borderWidth =  1;
        [_deleteButton setTitleColor:UIColorHex(0x0079BF) forState:UIControlStateNormal];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        _deleteButton.tag = 1111;
        [_deleteButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(kButtonWidth, kTextFeildHeight * 5, kButtonWidth, kTextFeildHeight);
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.layer.borderColor = UIColorHex(0x0079BF).CGColor;
        _cancelButton.layer.borderWidth =  1;
        [_cancelButton setTitleColor:UIColorHex(0x0079BF) forState:UIControlStateNormal];
        [_cancelButton setTitle:@"修改" forState:UIControlStateNormal];
        _cancelButton.tag = 2222;
        [_cancelButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(kButtonWidth * 2, kTextFeildHeight * 5, kButtonWidth, kTextFeildHeight);
        _addButton.layer.masksToBounds = YES;
        _addButton.layer.borderColor = UIColorHex(0x0079BF).CGColor;
        _addButton.layer.borderWidth =  1;
        [_addButton setTitleColor:UIColorHex(0x0079BF) forState:UIControlStateNormal];
        [_addButton setTitle:@"添加" forState:UIControlStateNormal];
        _addButton.tag = 3333;
        [_addButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}


#pragma mark - UITextFeildDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    if (textField.tag == 111) {
        // 学号
        self.studentNumber = textField.text;
    }else if ( textField.tag == 222){
        // 姓名
        self.studentName = textField.text;
    }else if(textField.tag == 333){
        // 性别
        self.studentSex = textField.text;
    }else{
        // 年龄
        self.studentAge = textField.text;
    }
    [self putIntoRight];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    if (textField.tag == 111) {
        // 学号
        self.studentNumber = textField.text;
    }else if ( textField.tag == 222){
        // 姓名
        self.studentName = textField.text;
    }else if(textField.tag == 333){
        // 性别
        self.studentSex = textField.text;
    }else{
        // 年龄
        self.studentAge = textField.text;
    }
    [self putIntoRight];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self putIntoRight];
}

#pragma mark - 点击事件
- (void)btnClick:(UIButton *)btn{
    [self endEditing:YES];
    if (btn.tag == 1111) {
        /// 删除
            if (self.addBlock) {
                self.addBlock(btn.tag, self.studentNumber, self.studentName, self.studentSex, self.studentAge);
            }
      
    }else if(btn.tag == 2222){
        /// 修改
        if (self.addBlock) {
            self.addBlock(btn.tag, self.studentNumber, self.studentName, self.studentSex, self.studentAge);
            
        }
    }else{
        /// 添加
        if ([self checkPutIntoStr]) {
            if (self.addBlock) {
                self.addBlock(btn.tag, self.studentNumber, self.studentName, self.studentSex, self.studentAge);
            }
        }
    }
    
}

#pragma mark - 检测是否输入正确
- (BOOL)checkPutIntoStr{
    if (self.studentNumber.length > 0 && self.studentName.length > 0 && self.studentSex.length > 0 && self.studentAge.length > 0) {
        [self putIntoRight];
        return YES;
    }else{
        [self putIntoWrong];
        return NO;
    }
}

#pragma mark - 正确录入信息
- (void)putIntoRight{
    self.headerLabel.text = @"录入学生信息";
    self.headerLabel.textColor = [UIColor whiteColor];
}

- (void)putIntoWrong{
    self.headerLabel.text = @"录入信息有误，请重新输入";
    self.headerLabel.textColor = [UIColor redColor];
}

- (void)hasSameNumber{
    self.headerLabel.text = @"学号重复，请重新输入";
    self.headerLabel.textColor = [UIColor redColor];
}
@end
