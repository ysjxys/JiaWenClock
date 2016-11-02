//
//  YSJTableViewDataSource.h
//  ysjLib
//
//  Created by ysj on 16/5/20.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CellBlock)(UITableViewCell *cell, id cellModel);
@interface YSJTableViewDataSource : UIViewController<UITableViewDataSource>


//+ (instancetype)item

- (instancetype)initWithItems:(NSArray *)items cellIdentifier:(NSString *)identifier cellBlock:(CellBlock)cellBlock;
@end
