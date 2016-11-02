//
//  FMDBHelper.h
//  ysjLib
//
//  Created by ysj on 16/5/24.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

typedef NS_ENUM(NSInteger, AndOrKey) {
    AndKey = 0,
    OrKey,
    NoneKey,
    CommaKey,
};

typedef NS_ENUM(NSInteger, CompareKey) {
    CompareKeyEqual = 0,
    CompareKeyLike,
    CompareKeyBigger,
    CompareKeySmaller
};


#define FMDBVarTypeInteger @"integer"
#define FMDBVarTypeText @"text"
#define FMDBVarTypeDatetime @"datetime"

#define FMDBTypeCharPrimaryKey @" PRIMARY KEY"
#define FMDBTypeCharAutoincrement @" AUTOINCREMENT"
#define FMDBTypeCharNotNull @" NOT NULL"

@interface FMDBHelper : NSObject

/**
 *  创建数据库
 *
 *  @param dbName 数据库名称(带后缀.sqlite)
 */
+ (void)dataBaseWithName:(NSString *)dbName;


/**
 *  获得具体的 = LIKE > < 字符
 */
+ (NSString *)compareKey:(CompareKey)compareKey;


/**
 *  给指定数据库建表
 *
 *  @param db        指定数据库对象
 *  @param tableName 表的名称
 *  @param keyTypeDic   所含字段以及对应字段类型 字典
 */
+ (void)createTable:(NSString *)tableName withKeyTypeDic:(NSDictionary *)keyTypeDic;


/**
 *  判断表是否存在
 *
 *  @param tableName 表名
 */
+ (BOOL)isTableExist:(NSString *)tableName;


/**
 *  给指定数据库的表添加值
 *
 *  @param db        数据库名称
 *  @param keyValueDic 字段及对应的值
 *  @param tableName 表名
 */
+ (void)insertKeyValues:(NSDictionary *)keyValueDic intoTable:(NSString *)tableName;


/**
 *  给指定数据库的表更新值
 *
 *  @param tableName     表名
 *  @param updateArr     需要更新的字段值数组 @{key:value,key:value}
 *  @param andOrKey      筛选条件的衔接符号 and/or/none
 *  @param compareKeyArr 筛选条件组成的数组 @[=,<,>,like]
 *  @param columnArr     筛选条件字段值数组 @[@{key:value},@{key:value}]
 */
+ (void)updateTable:(NSString *)tableName updateDic:(NSDictionary *)updateDic andOrKey:(AndOrKey)andOrKey compareKeyArr:(NSArray<NSString *> *)compareKeyArr columnArr:(NSArray<NSDictionary *> *)columnArr;


/**
 *  条件删除数据
 *
 *  @param tableName     表名
 *  @param andOrKey      筛选条件的衔接符号 and/or/none
 *  @param compareKeyArr 筛选条件组成的数组 @[=,<,>,like]
 *  @param columnArr     筛选条件字段值数组 @[@{key:value},@{key:value}]
 */
+ (void)deleteTable:(NSString *)tableName andOrKey:(AndOrKey)andOrKey compareKeyArr:(NSArray<NSString *> *)compareKeyArr columnArr:(NSArray<NSDictionary *> *)columnArr;


/**
 *  删除表中所有数据
 *
 *  @param db        数据库
 *  @param tableName 表名
 */
+ (void)deleteTable:(NSString *)tableName;


/**
 *  删除表
 *
 *  @param tableName 表名
 */
+ (void)dropTable:(NSString *)tableName;



/**
 *  按条件查询
 *
 *  @param tableName     表名
 *  @param andOrKey      筛选条件的衔接符号 and/or/none
 *  @param compareKeyArr 筛选条件组成的数组 @[=,<,>,like]
 *  @param columnArr     筛选条件字段值数组 @[@{key:value},@{key:value}]
 */
+ (NSArray *)selectDataFromTable:(NSString *)tableName andOrKey:(AndOrKey)andOrKey compareKeyArr:(NSArray<NSString *> *)compareKeyArr columnArr:(NSArray<NSDictionary *> *)columnArr;


/**
 *  查询所有数据
 *
 *  @param tableName 表名
 *
 *  @return 全部数组
 */
+ (NSArray *)selectDataFromTable:(NSString *)tableName;

@end
