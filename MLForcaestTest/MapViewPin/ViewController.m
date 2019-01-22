//
//  ViewController.m
//  Foecast
//
//  Created by apple on 2019/1/22.
//  Copyright © 2017年 Allen · luo. All rights reserved.
//

/*
 info.plist 配置的两个定位参数 如果上架 要说明使用定位是干什么用的，否则可能会拒绝你的应用请求（没有说明绝大部分会被拒）
 NSLocationAlwaysUsageDescription
 NSLocationWhenInUseUsageDescription
 */

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "KCAnnotation.h"
#import "JZLocationConverter.h"
#import <AFNetworking.h>
#import "IDCMConfig.h"
#import "UIView+Extension.h"
#define URL @"https://api.data.gov.sg/v1/environment/2-hour-weather-forecast"
@interface ViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;  //!< 地图

@property (nonatomic, strong) CLLocationManager *locManager; //!< 定位

@property(nonatomic,strong)UILabel * forecastLabel; ///< 天气
@property(nonatomic,strong)UIButton * refreshBtn ; ///< 刷新按钮
@property(nonatomic,strong)UIButton * areaBtn ; ///< 地区
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,strong)NSMutableArray * areaArrM ;//
@property(nonatomic,strong)NSMutableArray * forecastArrM;//

@property(nonatomic,strong)AreaModel * currentArea;
@property(nonatomic,assign)BOOL isReresh; ///< 是否手动刷新

@property(nonatomic,assign)BOOL isTimerRequest ;
@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self mapView]; // 显示地图
    [self startLocation]; //启动跟踪定位
    [self initView];
    
    __weak typeof(self)weakSelf = self;
    self.timer = [NSTimer timerWithTimeInterval:2.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
        weakSelf.isTimerRequest = YES;
        [weakSelf getData];
    }];
    
    [self getData];
}

- (void)setlocation{
    double latitude = self.currentArea.label_location.latitude.doubleValue;
    double longtitude = self.currentArea.label_location.longitude.doubleValue;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude,longtitude);
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    
    MKCoordinateRegion region = {coordinate,span};
    [self.mapView setRegion:region animated:YES];
    [self addAnnotation:coordinate];
}
-(void)initView{
    UILabel * forecastLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 90, 100, 60)];

    forecastLabel.numberOfLines = 0 ;
    forecastLabel.textAlignment = NSTextAlignmentCenter;
    forecastLabel.font = SetPingFangSCMedium(15.0f);
    [self.view addSubview:forecastLabel];
    [forecastLabel rounded:5.0f width:1.5 color:SetColor(46, 127, 208)];
    self.forecastLabel = forecastLabel;
    
    UIButton * areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    areaBtn.frame = CGRectMake(10, 30, 100, 30);
    [areaBtn.titleLabel setFont:SetPingFangSCMedium(15.0f)];
    [areaBtn setTitle:@"City" forState:UIControlStateNormal];
    [areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [areaBtn rounded:5.0f width:1.5 color:SetColor(46, 127, 208)];
    [self.view addSubview:areaBtn];
    [areaBtn addTarget:self action:@selector(clickAreaBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.areaBtn = areaBtn;
    //刷新按钮
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_WIDTH - 70, 30, 60, 40);
    [btn.titleLabel setFont:SetPingFangSCMedium(15.0f)];
    [btn setTitle:@"刷新" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn rounded:5.0f width:1.5 color:SetColor(46, 127, 208)];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(refreshClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.refreshBtn = btn;
}

- (void)clickAreaBtn:(UIButton *)btn{
    CityViewController * cityVC =  [CityViewController new];
    cityVC.dataArr = self.areaArrM;
    cityVC.popBlock = ^(AreaModel * _Nonnull model) {
        self.currentArea = model ;
        [self refreshUI];
        NSLog(@"model == select %@",model);
    };
    [self.navigationController pushViewController:cityVC animated:YES];
    
}
- (void)refreshClickBtn:(UIButton *)btn{
    self.isReresh = YES;
    self.isTimerRequest = NO;
    [self getData];
}
-(void)getData{
    AFHTTPSessionManager  * manager = [AFHTTPSessionManager manager];
    NSDictionary * dic = @{};
    if (!self.isTimerRequest) {
        [SVProgressHUD showWithStatus:@"loading..."];
    }
    [manager GET:URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject&&[responseObject[@"api_info"][@"status"] isEqualToString:@"healthy"]) {
              NSArray * areA = responseObject[@"area_metadata"];
              NSArray * foreA = [responseObject[@"items"] firstObject][@"forecasts"];
              if (areA&&foreA&&(areA.count == foreA.count)) {
                  
                  [self.areaArrM removeAllObjects];
                  [areA enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                      AreaModel * areModel = [AreaModel mj_objectWithKeyValues:obj];
                      NSDictionary * areaDic = [foreA objectAtIndex:idx];
                      if ([areModel.name isEqualToString:areaDic[@"area"]]) {
                          areModel.forecast = areaDic[@"forecast"];
                      }
                      [self.areaArrM addObject:areModel];
                  }];
                  if (!self.isReresh) {
                       self.currentArea = self.areaArrM.firstObject;
                  }else{
                      NSString * areaName = self.currentArea.name;
                      for (AreaModel * model in self.areaArrM) {
                          if ([areaName isEqualToString:model.name]) {
                              self.currentArea = model;
                          }
                      }
                  }
                 
                  [self refreshUI];
             }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - 刷新数据
-(void)refreshUI{
      [self setlocation];
      self.forecastLabel.text = self.currentArea?[NSString stringWithFormat:@"%@ \n %@",self.currentArea.name,self.currentArea.forecast]:@"";
}
// 重写get方法（懒加载）
- (NSMutableArray *)areaArrM{
    if (!_areaArrM) {
        _areaArrM = @[].mutableCopy;
    }
    return _areaArrM;
}
- (NSMutableArray *)forecastArrM{
    if (!_forecastArrM) {
        _forecastArrM = @[].mutableCopy;
        
    }
    return _forecastArrM;
}

- (MKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        _mapView.delegate = self; // 设置代理
        // 以下所有属性均为YES
        _mapView.zoomEnabled   = YES; // 允许地图缩放
        _mapView.scrollEnabled = YES; // 允许滚动地图
        _mapView.rotateEnabled = YES; // 允许两个手指捏合循转
        [self.view addSubview:_mapView];
    }
    return _mapView;
}

- (CLLocationManager *)locManager{
    if (!_locManager) {
        _locManager = [[CLLocationManager alloc] init];
        _locManager.delegate=self; //设置代理
        //设置定位精度
        _locManager.desiredAccuracy=kCLLocationAccuracyBest;
    }
    return _locManager;
}

// 开始定位
- (void)startLocation
{
    [self.locManager startUpdatingLocation];
}

// 停止定位
- (void)stopLocation
{
    [self.locManager stopUpdatingLocation];
}

#pragma mark - MKMapViewDelegate
- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[KCAnnotation class]])
    {
        // 跟tableViewCell的创建一样的原理
        static NSString *identifier = @"kkk";
    
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        annotationView.canShowCallout = YES; // 显示大头针小标题
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        leftBtn.frame = CGRectMake(0, 0, 50, 50);
        leftBtn.backgroundColor = [UIColor orangeColor];
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        rightBtn.frame = CGRectMake(0, 0, 50, 50);
        rightBtn.backgroundColor = [UIColor purpleColor];
        annotationView.leftCalloutAccessoryView = leftBtn; // 显示左右按钮
        annotationView.rightCalloutAccessoryView = rightBtn;
        // 自定义图片(如果使用系统大头针可以使用<MKPinAnnotationView>类)
        annotationView.image = [UIImage imageNamed:@"car"];
        return annotationView;
    }
    return nil; // 设为nil  自动创建系统大头针(唯一区别就是图片的设置)
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{ // 定位管理设置代理 立刻会走该方法,如果你在后台修改了定位模式（如，改为了"永不"，"使用期间","始终"）回到前台都会调用
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
        {
            // 系统优先使用的是 requestWhenInUseAuthorization
            if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [manager requestWhenInUseAuthorization];
            }
            if ([manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [manager requestAlwaysAuthorization];
            }
        }
            break;
        case kCLAuthorizationStatusDenied:
        {
            NSLog(@"请开启定位功能！");
        }
            break;
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"定位无法使用！");
        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"一直使用定位！");
        }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"使用期间使用定位!");
        }
            break;
        default:
            break;
    }
}

// 开启了 startUpdatingLocation 就会走这个方法
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"%s",__func__);

    /* 设置的定位是best 所以整个方法都会多次调用，调用方法最后一次为理论的最精确，每一次取数组最后的值也为理论的最精确值 */
    CLLocation *loc = locations.lastObject;
    
    /* 大概意思是 定位到的时间和回调方法在这一刻有一个时间差 这个差值可以自己定义用来过滤掉一些认为延时太长的数据  */
    NSTimeInterval time = [loc.timestamp timeIntervalSinceNow];
    
    // 过滤一些不太满意的数据
    
    if(fabs(time) > 10) return; // 过滤掉10秒之外的(我们只对10秒之内的定位感兴趣)
    
    // 水平精度小于0是无效的定位 必须要大于0 (正数越小越精确)
    if (loc.horizontalAccuracy < 0)  return;
    // verticalAccuracy 这个参数代表的是海拔 暂时不做处理
    
    // 停止定位，否则会一直定位下去（系统会根据偏移的距离来适当的回调，并不是该回调方法一直走，也有可能会走，需要不断地去测试）
    [self stopLocation]; // 已经定位到了我们要的位置
    
    //判断是不是属于国内范围
    if (![JZLocationConverter isLocationOutOfChina:[loc coordinate]])
    {
        // 查找地图上是否有大头针
        for (id <MKAnnotation> obj in _mapView.annotations)
        {
            // 有这个类型的大头针先删除掉
            if ([obj isKindOfClass:[KCAnnotation class]])
            {
                // 移除添加的大头针 否则会出现满屏的大头针(有增有删)
                [_mapView removeAnnotation:obj];
            }
        }
        // 转国内火星坐标（不转的的话，偏移特别大，其实我也一直想用系统自带的）
        CLLocationCoordinate2D coor = [JZLocationConverter wgs84ToGcj02:loc.coordinate];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:coor.latitude longitude:coor.longitude];
        CLGeocoder *coder = [[CLGeocoder alloc] init];
        // 经纬度转位置信息（该方法必须要联网才能获取）
        [coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            for (CLPlacemark *place in placemarks) {
                NSLog(@"place=%@",place);
                NSLog(@"位置=%@ 街道=%@ 子街道=%@ 市=%@ 区县=%@ 行政区域(省)=%@ 国家=%@",place.name,place.thoroughfare,place.subThoroughfare,place.locality,place.subLocality,place.administrativeArea,place.country);
            }
        }];
        
        NSLog(@"火星坐标 = %f %f",coor.latitude,coor.longitude);
        
        [self addAnnotation:coor]; // 添加大头针
        
        MKCoordinateSpan span = {0.01,0.01}; // 比例尺 值越小越直观
        
        // 该参数为两个结构体 一个为经纬度，一个为显示比例尺
        MKCoordinateRegion region = {coor,span};
        
        [self.mapView setRegion:region animated:YES]; // 在地图上显示当前比例尺的位置
    } else {
        NSLog(@"国外");
        // 同上一样的代码
        
    }
    
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"点击标注");
}
// 选中大头针
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"选中大头针");
}
// 取消选中大头针
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"取消选中大头针");
}
// 添加大头针
- (void)addAnnotation:(CLLocationCoordinate2D)coordinate
{
    // 查找地图上是否有大头针
    for (id <MKAnnotation> obj in _mapView.annotations)
    {
        // 有这个类型的大头针先删除掉
        if ([obj isKindOfClass:[KCAnnotation class]])
        {
            // 移除添加的大头针 否则会出现满屏的大头针(有增有删)
            [_mapView removeAnnotation:obj];
        }
    }
    
    // 要添加大头针，只能遵循<MKAnnotation>创建一个类出来，系统没有提供
    KCAnnotation *annotation = [[KCAnnotation alloc]init];
    annotation.title      = self.currentArea.name?self.currentArea.name:@"";
    annotation.subtitle   = self.currentArea.forecast?self.currentArea.forecast:@"";
    annotation.coordinate = coordinate;
//     添加大头针，会调用代理方法 mapView:viewForAnnotation:
    [_mapView addAnnotation:annotation];
    // addAnnotations: 该方法可以添加一组大头针
    
}

@end
