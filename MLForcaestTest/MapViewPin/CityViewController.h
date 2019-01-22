//
//  CityViewController.h
//  MLForecastText
//
//  Created by mac on 2019/1/22.
//  Copyright © 2019 chenxin · luo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CityViewController : UIViewController
@property(nonatomic,strong)NSArray <AreaModel *>* dataArr;

@property(nonatomic,copy) void (^popBlock)(AreaModel * model) ;
@end

NS_ASSUME_NONNULL_END
