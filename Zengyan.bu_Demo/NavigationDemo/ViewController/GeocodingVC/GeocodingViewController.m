//
//  GeocodingViewController.m
//  NavigationDemo
//
//  Created by zengyan.bu on 17/3/28.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  地理编码VC

#define kDistanceX (15.0f)
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kSearchViewHeight (64.0f)
#define kNavigationBarHeight (64.0f)
#define kButtonWidth (80)
#define kBgViewHeight (70.0f)
//系统版本号是否大于8.0
#define IS_SystemVersionGreaterThanEight  ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0)



#import "GeocodingViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>

/// 自定义view
#import "CustomMAAnnotationView.h"
#import "HeaderSearchView.h"
#import "CityView.h"

#import <MapKit/MapKit.h>

@interface GeocodingViewController ()<AMapSearchDelegate,MAMapViewDelegate>
/// mapView
@property (nonatomic, strong)   MAMapView *mapView;
/// 搜索
@property (nonatomic, strong)   AMapSearchAPI *search;
/// 地理编码查询参数
@property (nonatomic, strong)   AMapGeocodeSearchRequest *request;
/// 输入具体搜索地址
@property (nonatomic, strong)   HeaderSearchView *headerSearchView;
/// 数据源
@property (nonatomic, strong)   NSMutableArray *annototionArray;
/// 城市列表视图
@property (nonatomic, strong)   CityView *cityView;
/// 城市列表数据源
@property (nonatomic, strong)   NSMutableArray *cityArray;
/// 导航栏右侧按钮
@property (nonatomic, strong)   UIBarButtonItem *rightItem;


/* 文字显示背景View */
@property (nonatomic, strong)   UIView *bgView;
/* 显示文字label */
@property (nonatomic, strong)   UILabel *label;
/* 跳转button */
@property (nonatomic, strong)   UIButton *stipButton;
/* 导航终点坐标 */
@property (nonatomic, assign)   CLLocationCoordinate2D  coordinate;
/* 导航起点坐标 */
@property (nonatomic, assign)   CLLocationCoordinate2D userLocation;

@end

@implementation GeocodingViewController
{
    NSString *_addressStr;
    NSString *_cityStr;
    UIButton *_rightBtn;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kBgViewHeight, kScreenWidth, kBgViewHeight)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.6;
    }
    return _bgView;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(kDistanceX, kScreenHeight - kBgViewHeight, kScreenWidth - kDistanceX*3 - kButtonWidth, kBgViewHeight)];
        _label.font = [UIFont systemFontOfSize:16];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.numberOfLines = 0;
        _label.backgroundColor = [UIColor clearColor];
    }
    return _label;
}

- (void)stipBtnClick:(UIButton *)btn{
    //系统版本高于8.0，使用UIAlertController
    if (IS_SystemVersionGreaterThanEight) {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"导航到设备" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        // 1.自带地图
        [alertController addAction:[UIAlertAction actionWithTitle:@"自带地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 自带地图");
            
            // 上海市经纬度 30.403153 120.511221
//            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];// 自己的位置
            MKMapItem *toLocation =[[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.userLocation.latitude, self.userLocation.longitude) addressDictionary:nil]];
            ;
            
            MKMapItem * currentLocation= [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:nil]];
            
            [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                                       MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
            
            
        }]];
        
        // 2.判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2",self.coordinate.latitude,self.coordinate.longitude]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:urlsting] options:@{} completionHandler:nil];
                
            }]];
        }
        
        // 3.判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
            [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",self.coordinate.latitude,self.coordinate.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting] options:@{} completionHandler:nil];
                
            }]];
        }
        
        // 4.腾讯地图，如果安装了腾讯地图，可以使用腾讯地图
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
            NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
            qqMapDic[@"title"] = @"腾讯地图";
            NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",self.coordinate.latitude, self.coordinate.longitude]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            
            qqMapDic[@"url"] = urlString;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        }
        
        //添加取消选项
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [alertController dismissViewControllerAnimated:YES completion:nil];
            
        }]];
        
        //显示alertController
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (UIButton *)stipButton{
    if (!_stipButton) {
        _stipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _stipButton.frame = CGRectMake(kScreenWidth - kDistanceX - kButtonWidth, kScreenHeight - kBgViewHeight, kButtonWidth, kBgViewHeight);
        [_stipButton setBackgroundColor: [UIColor clearColor]];
        [_stipButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_stipButton setTitle:@"导航" forState:UIControlStateNormal];
        [_stipButton addTarget:self action:@selector(stipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _stipButton;
}



- (NSMutableArray *)annototionArray{
    if (!_annototionArray) {
        _annototionArray = [[NSMutableArray alloc] init];
    }
    return _annototionArray;
}

- (NSMutableArray *)cityArray{
    if (!_cityArray) {
        _cityArray = [[NSMutableArray alloc] initWithObjects:@"北京",@"上海",@"广州",@"深圳", nil];
    }
    return _cityArray;
}

- (UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(0, 0, 64, 64);
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn setTitle:@"上海" forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    }
    return _rightItem;
}

- (CityView *)cityView{
    if (!_cityView) {
        _cityView = [[CityView alloc] initWithFrame:CGRectMake(kScreenWidth - 100, kNavigationBarHeight, 100, 200) dataArray:self.cityArray];
        __weak typeof(self) weakSelf = self;
        _cityView.citySelectedBlock = ^(NSString *cityName){
            [weakSelf selectedCity:cityName];
        };
        _cityView.hidden = YES;
    }
    return _cityView;
}

- (HeaderSearchView *)headerSearchView{
    if (!_headerSearchView) {
        _headerSearchView = [[HeaderSearchView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kSearchViewHeight) placeholder:@"请输入详细信息"];
        
        __weak typeof(self) weakSelf = self;
        _headerSearchView.searchBlock = ^(NSString *detailStr){
            [weakSelf searchBlockClick:detailStr];
        };
    }
    return _headerSearchView;
}

- (MAMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, kSearchViewHeight + kNavigationBarHeight, kScreenWidth, kScreenHeight - kSearchViewHeight)];
        _mapView.delegate = self;
    }
    return _mapView;
}

- (AMapSearchAPI *)search{
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}

- (AMapGeocodeSearchRequest *)request{
    if (!_request) {
        _request = [[AMapGeocodeSearchRequest alloc] init];
        _cityStr = @"上海市";
        _addressStr = @"万荣路1268号";
        _request.address = _addressStr;
    }
    return _request;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地理编码";
    self.navigationItem.rightBarButtonItem = self.rightItem;
    [self.view addSubview:self.headerSearchView];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.cityView];
    
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.label];
    [self.view addSubview:self.stipButton];
    
    //导航到深圳火车站 30.403153 120.511221
    //    self.coordinate = CLLocationCoordinate2DMake(22.53183, 114.117206);
    self.coordinate = CLLocationCoordinate2DMake(31.294397, 121.44030100000001);   // 宝尊电商

    [self geoCodeRequest];
    
    [self.mapView setZoomLevel:17];
    
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow];
}


#pragma mark - 地理编码请求
- (void)geoCodeRequest{
    self.request.address = [NSString stringWithFormat:@"%@%@",_cityStr,_addressStr];
    [self.search AMapGeocodeSearch:self.request];
}

#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *customAnnotationViewStr = @"customAnnotationViewStr";
        CustomMAAnnotationView *customAnnotationView= (CustomMAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:customAnnotationViewStr];
        if (customAnnotationView == nil) {
            customAnnotationView = [[CustomMAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customAnnotationViewStr];
        }
        customAnnotationView.image = [UIImage imageNamed:@"ic_location@2x.png"];
//        customAnnotationView.selected = YES;
        [customAnnotationView setSelected:YES animated:YES];
        return customAnnotationView;
    }
    return nil;
}

#pragma mark - 地理编码请求回调代理
/// 1.
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    if (response.geocodes.count == 0) {
        return;
    }
    
    [self.mapView removeAnnotations:self.annototionArray];
    [self.annototionArray removeAllObjects];

    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MAPointAnnotation *anntotion = [[MAPointAnnotation alloc] init];
        [anntotion setCoordinate:CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude)];
        anntotion.title = obj.city;
        anntotion.subtitle = obj.formattedAddress;
        self.label.text = obj.formattedAddress;
        self.userLocation = CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude);
        [_annototionArray addObject:anntotion];
    }];
    
    [self showPOIAnntotionsWith:_annototionArray];
}

#pragma mark - 地图上展示搜索地点
- (void)showPOIAnntotionsWith:(NSMutableArray *)anntotions{
    [self.mapView addAnnotations:anntotions];
    
    if (anntotions.count == 1) {
        self.mapView.centerCoordinate = [(MAPointAnnotation *)[anntotions objectAtIndex:0] coordinate];
    }else{
        [self.mapView showAnnotations:anntotions animated:YES];
    }
    
}
/// 2.error
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"error = %@",error);
}


#pragma mark - 搜索事件
- (void)searchBlockClick:(NSString *)detailStr{
    _addressStr = detailStr;
    [self geoCodeRequest];
}



#pragma mark - 城市切换事件
- (void)selectedCity:(NSString *)cityName{
    _cityStr = cityName;
    [_rightBtn setTitle:cityName forState:UIControlStateNormal];
    [self showOrHiddenCityView];
    [self geoCodeRequest];
}

#pragma mark - 导航按钮点击事件
- (void)btnClick:(UIButton *)btn{
    [self showOrHiddenCityView];
}

#pragma mark - 城市列表的隐藏或显示
- (void)showOrHiddenCityView{
    if (self.cityView.hidden == YES) {
        self.cityView.hidden = NO;
    }else{
        self.cityView.hidden = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
