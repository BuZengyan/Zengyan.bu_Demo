//
//  CreateBarImageViewController.m
//  Zengyan.bu_Demo
//
//  Created by zengyan.bu on 2018/1/17.
//  Copyright © 2018年 zengyan.bu. All rights reserved.
//  条形码生成器

#define kHistory @"history"
#define kTopY (120.0f)
#define kDistanceX (20.0f)
#define kDistanceY (40.0f)
#define kBarImageViewWidth (kScreenWidth - kDistanceX * 2)
#define kBarImageViewHeight (120.0f)
#define kButtonHeight (44.0f)
#define kButtonWidth (80.0f)
#define kBarTextFeildWidth (kScreenWidth - kDistanceX * 3 - kButtonWidth)
#define kBarTextFeildHeight (44.0f)
#define kShowBarCodeLabelHeight (25.0f)
#define kCellHeight (60.0f)

#import "CreateBarImageViewController.h"

@interface CreateBarImageViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong)   UIImageView *barImageView;  /// 条形码展示视图
@property (nonatomic, strong)   UITextField *barTextFeild;  /// 输入barCode
@property (nonatomic, strong)   UIButton    *createButton;  /// 生成button
@property (nonatomic, strong)   UITableView *mainTableView; /// 显示历史记录的tableView
@property (nonatomic, copy)     NSString    *barCodeStr;
@property (nonatomic, strong)   UILabel     *remindLabel;
@property (nonatomic, strong)   UILabel     *showBarCodeLabel;  /// 显示条形码label
@property (nonatomic, strong)   NSMutableArray  *historyArray; /// 历史记录
@property (nonatomic, strong)   UIView      *headerView;
@property (nonatomic, strong)   UIView      *noDataView;



@end

@implementation CreateBarImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"条形码生成器(内测版)";
    self.view.backgroundColor = UIColorHex(0xFFFFFF);
    [self.view addSubview:self.barImageView];
    [self.view addSubview:self.remindLabel];
    [self.view addSubview:self.showBarCodeLabel];
    [self.view addSubview:self.barTextFeild];
    [self.view addSubview:self.createButton];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView addSubview:self.noDataView];
    
    [self showOrHiddenNoDataView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
#pragma mark - 初始化数据源
- (NSMutableArray *)historyArray{
    if (!_historyArray) {
        _historyArray = [[NSMutableArray alloc] init];
    }
    return _historyArray;
}

#pragma mark - 初始化各个控件
- (UIImageView *)barImageView{
    if (!_barImageView) {
        _barImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - kBarImageViewWidth) / 2, kDistanceY + kNaviHeight + kDistanceY / 2 + kBarTextFeildHeight, kBarImageViewWidth, kBarImageViewHeight)];
        _barImageView.backgroundColor = [UIColor clearColor];
    }
    return _barImageView;
}

- (UILabel *)remindLabel{
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - kBarImageViewWidth) / 2, self.barImageView.frame.origin.y, kBarImageViewWidth, kBarImageViewHeight)];
        _remindLabel.textColor = UIColorHex(0xF0F0F1);
        _remindLabel.font = [UIFont boldSystemFontOfSize:20];
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        _remindLabel.layer.masksToBounds = YES;
        _remindLabel.layer.borderWidth = 1;
        _remindLabel.layer.borderColor = UIColorHex(0xF0F0F1).CGColor;
        _remindLabel.text = @"条形码生成器";
    }
    return _remindLabel;
}

- (UILabel *)showBarCodeLabel{
    if (!_showBarCodeLabel) {
        _showBarCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - kBarImageViewWidth) / 2, self.barImageView.frame.origin.y + self.barImageView.frame.size.height, kBarImageViewWidth, kShowBarCodeLabelHeight)];
        _showBarCodeLabel.textColor = UIColorHex(0xF0F0F1);
        _showBarCodeLabel.font = [UIFont boldSystemFontOfSize:14];
        _showBarCodeLabel.textAlignment = NSTextAlignmentCenter;
        _showBarCodeLabel.text = @"条形码：";
    }
    return _showBarCodeLabel;
}


- (UITextField *)barTextFeild{
    if (!_barTextFeild) {
        _barTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(kDistanceX, kNaviHeight + kDistanceY, kBarTextFeildWidth, kBarTextFeildHeight)];
        _barTextFeild.delegate = self;
        _barTextFeild.layer.masksToBounds = YES;
        _barTextFeild.layer.cornerRadius = 4;
        _barTextFeild.layer.borderColor = UIColorHex(0x0079BF).CGColor;
        _barTextFeild.layer.borderWidth = 1;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, kBarTextFeildHeight)];
        _barTextFeild.leftView = leftView;
        _barTextFeild.placeholder = @"请输入barCode";
        _barTextFeild.leftViewMode = UITextFieldViewModeAlways;
    }
    return _barTextFeild;
}

- (UIButton *)createButton{
    if (!_createButton) {
        _createButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _createButton.frame = CGRectMake(kScreenWidth - kDistanceX - kButtonWidth, self.barTextFeild.frame.origin.y, kButtonWidth, kButtonHeight);
        _createButton.backgroundColor = UIColorHex(0xF0F0F1);
        [_createButton setTitle:@"生成" forState:UIControlStateNormal];
        [_createButton setTitleColor:UIColorHex(0xFFFFFF) forState:UIControlStateNormal];
        _createButton.layer.masksToBounds = YES;
        _createButton.layer.cornerRadius = 4;
        [_createButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _createButton.enabled = NO;
    }
    return _createButton;
}

- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.frame.origin.y + kBarTextFeildHeight, kScreenWidth, kScreenHeight - (self.headerView.frame.origin.y + kBarTextFeildHeight)) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTableView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.showBarCodeLabel.frame.origin.y + kDistanceY / 2 + kShowBarCodeLabelHeight, kScreenWidth, kBarTextFeildHeight)];
        _headerView.backgroundColor = UIColorHex(0xF0F0F1);
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDistanceX, 0, 100, kBarTextFeildHeight)];
        leftLabel.text = @"历史记录";
        leftLabel.textColor = UIColorHex(0xCCCCCC);
        leftLabel.font = [UIFont systemFontOfSize:18];
        [_headerView addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 100 - kDistanceX, 1, 100, kBarTextFeildHeight - 2)];
        rightLabel.text = @"清除历史";
        rightLabel.textColor = UIColorHex(0x0079BF);
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.font = [UIFont systemFontOfSize:18];
        [_headerView addSubview:rightLabel];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(kScreenWidth - 100 - kDistanceX, 0, 100, kBarTextFeildHeight);
        [rightButton addTarget:self action:@selector(clearClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:rightButton];
    }
    return _headerView;
}

- (UIView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.mainTableView.frame.size.height)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.mainTableView.frame.size.height)];
        label.text = @"暂无历史记录！";
        label.textColor = UIColorHex(0xCCCCCC);
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        [_noDataView addSubview:label];
    }
    return _noDataView;
}

#pragma mark - UITextFeildDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.location > 0 || (range.location == 0 && string.length > 0)) {
        [self updateButtonColor:YES];
    }else{
        [self updateButtonColor:NO];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.barCodeStr = textField.text;
    NSLog(@"barCode = %@",self.barCodeStr);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self hiddenKeyBoard];
    [self hiddenRemindLabel];
    if (textField.text.length > 0) {
        [self updateButtonColor:YES];
        [self updateShowBarCodelabelColor:YES];
    }else{
        [self updateButtonColor:NO];
        [self updateShowBarCodelabelColor:NO];
    }
    [self createBarCodeImage];
    return YES;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self callOutData].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr = @"cellStr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCellHeight - 1, kScreenWidth, 1)];
        lineView.backgroundColor = UIColorHex(0xF0F0F1);
        [cell.contentView addSubview:lineView];
    }
    cell.textLabel.text = [[self callOutData] objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.barCodeStr = [[self callOutData] objectAtIndex:indexPath.row];
    [self createBarCodeImage];
    [self updateButtonColor:YES];
    [self updateShowBarCodelabelColor:YES];
    self.barTextFeild.text = self.barCodeStr;
    [self hiddenKeyBoard];
    [self hiddenRemindLabel];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    // 删除模型
    [self.historyArray removeObjectAtIndex:indexPath.row];
    [self saveData];
    // 刷新
    [self.mainTableView reloadData];
    
    [self showOrHiddenNoDataView];
}

/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}

#pragma mark - 更新按钮背景色
- (void)updateButtonColor:(BOOL)isSelected{
    if (isSelected) {
        self.createButton.enabled = YES;
        [self.createButton setBackgroundColor:UIColorHex(0x0079BF)];
        
    }else{
        self.createButton.enabled = NO;
        [self.createButton setBackgroundColor:UIColorHex(0xF0F0F1)];
    }
}

#pragma mark - 更改barCode显示文字颜色
- (void)updateShowBarCodelabelColor:(BOOL)isSelected{
    if (isSelected) {
        self.showBarCodeLabel.textColor = UIColorHex(0x333333);
        NSString *barCode = [self subStrWithStr:self.barCodeStr];
        self.showBarCodeLabel.text = [NSString stringWithFormat:@"条形码：%@",barCode];
    }else{
        self.showBarCodeLabel.textColor = UIColorHex(0xCCCCCC);
        self.showBarCodeLabel.text =@"条形码：";
    }
}
#pragma mark - 点击事件
- (void)tapClick:(UITapGestureRecognizer *)tap{
    [self hiddenKeyBoard];
}

#pragma mark - 生成按钮事件
- (void)btnClick:(UIButton *)btn{
    [self hiddenKeyBoard];
    [self hiddenRemindLabel];
    if (self.barCodeStr.length > 0) {
        [self updateButtonColor:YES];
         [self updateShowBarCodelabelColor:YES];
    }else{
        [self updateButtonColor:NO];
        [self updateShowBarCodelabelColor:NO];
    }
    // 生成条形码
    [self createBarCodeImage];
    
    [self showOrHiddenNoDataView];
}

#pragma mark - 清楚按钮事件
- (void)clearClick:(UIButton *)btn{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定要清空历史吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert] ;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyle)UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.historyArray removeAllObjects];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHistory];
        [self.mainTableView reloadData];
        [self showOrHiddenNoDataView];
    } ];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
}

#pragma mark - 生成条形码
- (void)createBarCodeImage{
    UIImage *image = [[self class] createBarImageWithBarStr:self.barCodeStr rect:self.barImageView.bounds ];
    self.barImageView.image = image;
    
    // 保存条形码
    for (NSString *tempStr in self.historyArray) {
        if ([tempStr isEqualToString:self.barCodeStr]) {
            return;
        }
    }
    
    // 保存数组
    [self.historyArray addObject:self.barCodeStr];
    [self saveData];
    [self.mainTableView reloadData];
}

#pragma mark - 隐藏键盘
- (void)hiddenKeyBoard{
    if ([self.barTextFeild isFirstResponder]) {
        [self.barTextFeild resignFirstResponder];
    }
}

#pragma mark - 隐藏提示label
- (void)hiddenRemindLabel{
    self.remindLabel.hidden = YES;
}

#pragma mark - 无历史记录视图
- (void)showOrHiddenNoDataView{
    if ([self callOutData].count > 0) {
        self.noDataView.hidden = YES;
    }else{
        self.noDataView.hidden = NO;
    }
}

#pragma mark ----- 条形码 -----
//创建条形码图片
+(UIImage*)createBarImageWithBarStr:(NSString*)str{
    // 创建条形码
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    // 6. 将CIImage转换成UIImage，并放大显示
    UIImage* image =  [UIImage imageWithCIImage:outputImage scale:0 orientation:UIImageOrientationUp];
    return image;
}

//高清条形码图片
+(UIImage*)createBarImageWithBarStr:(NSString*)str rect:(CGRect)rect{
    // 创建条形码
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    // 6.获取高清图片
    UIImage* image =  [[self class] createNonInterpolatedUIImageFormCIImage:outputImage withRect:rect];
    return image;
}

//高清图片
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withRect:(CGRect)rect {
    CGRect extent = CGRectIntegral(image.extent);
    // 1.width 比例
    CGFloat widthScale = rect.size.width/CGRectGetWidth(extent);
    CGFloat heightScale = rect.size.height/CGRectGetHeight(extent);
    // 创建bitmap（位图）;
    size_t width = CGRectGetWidth(extent) * widthScale;
    size_t height = CGRectGetHeight(extent) * heightScale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, widthScale, heightScale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - 字符串截取
- (NSString *)subStrWithStr:(NSString *)barCodeStr{
    NSString *newStr = @"";
    NSInteger count = barCodeStr.length % 3 == 0 ? barCodeStr.length/3 : barCodeStr.length/3 + 1;
    NSMutableArray *subStrArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < count; i++) {
        NSString *subStr = nil;
        if (barCodeStr.length % 3 == 0) {
            subStr = [barCodeStr substringWithRange:NSMakeRange(i * 3, 3)];
            [subStrArray addObject:subStr];
        }else{
            if (i == count - 1) {
                subStr = [barCodeStr substringWithRange:NSMakeRange(i * 3, 3 - (count * 3 - barCodeStr.length))];
            }else{
                subStr = [barCodeStr substringWithRange:NSMakeRange(i * 3, 3)];
            }
            [subStrArray addObject:subStr];
        }
    }
    
    for (NSString *str in subStrArray) {
        newStr = [NSString stringWithFormat:@"%@  %@",newStr, str];
    }
    return newStr;
}

#pragma mark - 保存数据
- (void)saveData{
    [[NSUserDefaults standardUserDefaults] setObject:self.historyArray forKey:kHistory];
}

#pragma mark - 取出保存的数据
- (NSMutableArray *)callOutData{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    dataArray = [[[NSUserDefaults standardUserDefaults] objectForKey:kHistory] mutableCopy];
    self.historyArray = dataArray;
    return dataArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
