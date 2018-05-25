//
//  ReGeocodingViewController.m
//  NavigationDemo
//
//  Created by zengyan.bu on 17/3/28.
//  Copyright © 2017年 zengyan.bu. All rights reserved.
//  地理逆编码（与定位是黄金搭档）

#define kDistanceX (15.0f)
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kSearchViewHeight (64.0f)
#define kNavigationBarHeight (64.0f)

#import "ReGeocodingViewController.h"

/// 地图相关
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "CustomMAAnnotationView.h"

/// cityView
#import "CityView.h"



typedef NS_ENUM(NSInteger, InfoType) {
    AroundType, // 周边
    RoadintersType, // 道路口
    RoadType,      // 道路
    AreaType        // 所在区域
};

@interface ReGeocodingViewController ()<AMapSearchDelegate,MAMapViewDelegate>

/// mapView
@property (nonatomic, strong)   MAMapView *mapView;
/// search
@property (nonatomic, strong)   AMapSearchAPI *search;
/// 逆编码请求
@property (nonatomic, strong)   AMapReGeocodeSearchRequest *reRequest;
/// 经纬度坐标
@property (nonatomic, strong)   AMapGeoPoint *location;
/// 显示标注的数据:(总数据源)
@property (nonatomic, strong)   NSMutableArray *annotionArray;
/// 周边的道路信息数组
@property (nonatomic, strong)   NSMutableArray *roadsArray;
/// 周边的道路口信息数组
@property (nonatomic, strong)   NSMutableArray *roadintersArray;
/// 周边的兴趣点信息
@property (nonatomic, strong)   NSMutableArray *poidsArray;
/// 所在区域信息
@property (nonatomic, strong)   NSMutableArray *aoisArray;

/// cityview
@property (nonatomic, strong)   CityView *cityView;
/// 城市列表数据源
@property (nonatomic, strong)   NSMutableArray *cityArray;
/// 导航栏右侧按钮
@property (nonatomic, strong)   UIBarButtonItem *rightItem;

///
@property (nonatomic, assign)   InfoType infoType;


@end

@implementation ReGeocodingViewController
{
    UIButton *_rightBtn;
    NSString *_cityStr;
}
- (NSMutableArray *)cityArray{
    if (!_cityArray) {
        _cityArray = [[NSMutableArray alloc] initWithObjects:@"周边",@"道路口",@"道路",@"所在区域", nil];
    }
    return _cityArray;
}

- (UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(0, 0, 64, 64);
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn setTitle:@"周边" forState:UIControlStateNormal];
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

#pragma mark - 标注数组
- (NSMutableArray *)annotionArray{
    if (!_annotionArray) {
        _annotionArray = [[NSMutableArray alloc] init];
    }
    return _annotionArray;
}

- (NSMutableArray *)roadsArray{
    if (!_roadsArray) {
        _roadsArray = [[NSMutableArray alloc] init];
    }
    return _roadsArray;
}

- (NSMutableArray *)roadintersArray{
    if (!_roadintersArray) {
        _roadintersArray = [[NSMutableArray alloc] init];
    }
    return _roadintersArray;
}

- (NSMutableArray *)poidsArray{
    if (!_poidsArray) {
        _poidsArray = [[NSMutableArray alloc] init];
    }
    return _poidsArray;
}

- (NSMutableArray *)aoisArray{
    if (!_aoisArray ) {
        _aoisArray = [[NSMutableArray alloc] init];
    }
    return _aoisArray;
}
#pragma mark - mapView
- (MAMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        _mapView.delegate = self;
        _mapView.pausesLocationUpdatesAutomatically = YES;
        _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置

    }
    return _mapView;
}

#pragma mark - search
- (AMapSearchAPI *)search{
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}

#pragma mark - 逆编码请求
- (AMapReGeocodeSearchRequest *)reRequest{
    if (!_reRequest) {
        _reRequest = [[AMapReGeocodeSearchRequest alloc] init];
    }
    return _reRequest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"逆编码";
    self.infoType = AroundType; // 默认
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.cityView];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    [self.mapView setZoomLevel:17];
    
    // 一直定位
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.mapView.showTraffic = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.mapView.showTraffic = NO;
}

#pragma mark - 发送逆编码请求。
- (void)sendReRequest{
    self.reRequest.location = _location;
    self.reRequest.requireExtension = YES;
    [self.search AMapReGoecodeSearch:self.reRequest];
}

#pragma mark - MAMapViewDelegate 
///1.
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *annotionStr = @"annotionStr";
        CustomMAAnnotationView *customAnnotion = (CustomMAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotionStr];
        if (customAnnotion == nil) {
            customAnnotion = [[CustomMAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotionStr];
        }
        customAnnotion.image = [UIImage imageNamed:@"ic_location@2x.png"];
        return customAnnotion;
    }
    return nil;
    
}

/// 3.
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if (updatingLocation) {
        _location = [AMapGeoPoint locationWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
        [self sendReRequest];
    }
}

#pragma mark - AMapSearchDelegate
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    if (response.regeocode == nil) {
        return;
    }

     // 1.显示周边的大建筑兴趣点
    [self.mapView removeAnnotations:self.poidsArray];
    [self.poidsArray removeAllObjects];
   
    [response.regeocode.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        [pointAnnotation setCoordinate:CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude)];
        pointAnnotation.title = obj.name;
        pointAnnotation.subtitle = obj.address;
        [self.poidsArray addObject:pointAnnotation];
        
    }];
    
    // 2.道路口信息数组
    [self.mapView removeAnnotations:self.roadintersArray];
    [self.roadintersArray removeAllObjects];
    [response.regeocode.roadinters enumerateObjectsUsingBlock:^(AMapRoadInter * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        [pointAnnotation setCoordinate:CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude)];
        pointAnnotation.title = obj.firstName;
        pointAnnotation.subtitle = obj.secondName;
        [self.roadintersArray addObject:pointAnnotation];
    }];

    // 3.道路信息数据
    [self.mapView removeAnnotations:self.roadsArray];
    [self.roadsArray removeAllObjects];
    
    
    [response.regeocode.roads enumerateObjectsUsingBlock:^(AMapRoad * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //
        MAPointAnnotation *pointAnntion = [[MAPointAnnotation alloc] init];
        [pointAnntion setCoordinate:CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude)];
        pointAnntion.title = obj.name;
        pointAnntion.subtitle = [NSString stringWithFormat:@"%ld",obj.distance];
        [self.roadsArray addObject:pointAnntion];
    }];
    // 4.兴趣区域
    [self.mapView removeAnnotations:self.aoisArray];
    [self.aoisArray removeAllObjects];
    [response.regeocode.aois enumerateObjectsUsingBlock:^(AMapAOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //
        MAPointAnnotation *pointAnntion = [[MAPointAnnotation alloc] init];
        [pointAnntion setCoordinate:CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude)];
        pointAnntion.title = obj.name;
        pointAnntion.subtitle = [NSString stringWithFormat:@"%f",obj.area];
        [self.aoisArray addObject:pointAnntion];
    }];

    
    if (self.infoType == AroundType) {
        [self showPOIAnntotions:self.poidsArray];
    }else if (self.infoType == RoadintersType){
        [self showPOIAnntotions:self.roadintersArray];
    }else if (self.infoType == RoadType){
        [self showPOIAnntotions:self.roadsArray];
    }else if (self.infoType == AreaType){
        [self showPOIAnntotions:self.aoisArray];
    }
}


#pragma mark - 显示mapViewPOI数据集
- (void)showPOIAnntotions:(NSMutableArray *)annotionArray{
    [self.mapView addAnnotations:annotionArray];
    if (self.annotionArray.count == 1) {
        self.mapView.centerCoordinate = [(MAPointAnnotation *)[self.annotionArray objectAtIndex:0] coordinate];
    }else{
        [self.mapView showAnnotations:self.annotionArray animated:YES];
    }
}

#pragma mark - 城市切换事件
- (void)selectedCity:(NSString *)cityName{
    
    if ([cityName isEqualToString:@"周边"]) {
        self.infoType = AroundType;
        [self.mapView removeAnnotations:self.aoisArray];
        [self.mapView removeAnnotations:self.roadintersArray];
        [self.mapView removeAnnotations:self.roadsArray];
        [self.mapView removeAnnotations:self.poidsArray];
        [self showPOIAnntotions:self.poidsArray];
    }else if ([cityName isEqualToString:@"道路"]){
        self.infoType = RoadType;
        [self.mapView removeAnnotations:self.aoisArray];
        [self.mapView removeAnnotations:self.roadintersArray];
        [self.mapView removeAnnotations:self.roadsArray];
        [self.mapView removeAnnotations:self.poidsArray];
        [self showPOIAnntotions:self.roadsArray];
    }else if ([cityName isEqualToString:@"道路口"]){
        self.infoType = RoadintersType;
        [self.mapView removeAnnotations:self.aoisArray];
        [self.mapView removeAnnotations:self.roadintersArray];
        [self.mapView removeAnnotations:self.roadsArray];
        [self.mapView removeAnnotations:self.poidsArray];
        [self showPOIAnntotions:self.roadintersArray];
    }else{
        self.infoType = AreaType;
        [self.mapView removeAnnotations:self.aoisArray];
        [self.mapView removeAnnotations:self.roadintersArray];
        [self.mapView removeAnnotations:self.roadsArray];
        [self.mapView removeAnnotations:self.poidsArray];
        [self showPOIAnntotions:self.aoisArray];
    }
    
    [_rightBtn setTitle:cityName forState:UIControlStateNormal];
    [self showOrHiddenCityView];
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
