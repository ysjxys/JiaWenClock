//
//  YSJTableViewDataSource.m
//  ysjLib
//
//  Created by ysj on 16/5/20.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import "YSJTableViewDataSource.h"
@interface YSJTableViewDataSource()
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) CellBlock cellBlock;

@end
@implementation YSJTableViewDataSource


- (instancetype)initWithItems:(NSArray *)items cellIdentifier:(NSString *)identifier cellBlock:(CellBlock)cellBlock{
    if (self = [super init]) {
        _dataArr = [NSArray arrayWithArray:items];
        _identifier = identifier;
        _cellBlock = cellBlock;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}


@end
