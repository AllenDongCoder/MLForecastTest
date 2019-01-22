//
//  ForecastModel.h
//  MLForecastText
//
//  Created by mac on 2019/1/22.
//  Copyright © 2019 chenxin · luo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ForecastModel : NSObject
@property(nonatomic,copy) NSString * area ;// "string",
@property(nonatomic,copy) NSString * forecast; //天气预报
@end

NS_ASSUME_NONNULL_END
