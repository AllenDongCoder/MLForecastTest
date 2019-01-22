//
//  AreaModel.h
//  MLForecastText
//
//  Created by mac on 2019/1/22.
//  Copyright © 2019 chenxin · luo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface label_location : NSObject
@property(nonatomic,copy) NSString * latitude;
@property(nonatomic,copy) NSString * longitude;
@end
@interface AreaModel : NSObject
@property(nonatomic,copy) NSString * name; //地区名字
@property(nonatomic,strong)label_location * label_location ;

@property(nonatomic,copy) NSString * forecast; //天气预报
@end

NS_ASSUME_NONNULL_END
