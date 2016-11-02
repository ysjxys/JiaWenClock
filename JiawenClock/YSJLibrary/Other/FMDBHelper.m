//
//  FMDBHelper.m
//  ysjLib
//
//  Created by ysj on 16/5/24.
//  Copyright © 2016年 Harry. All rights reserved.
//

#import "FMDBHelper.h"

#define HelpLog(...) NSLog(__VA_ARGS__)

static NSString *dbHomePath;
static NSArray *compareKeyArr;

@implementation FMDBHelper

+ (void)dataBaseWithName:(NSString *)dbName{
    NSArray *library = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *dbPath = [library[0] stringByAppendingPathComponent:dbName];
    dbHomePath = dbPath;
    HelpLog(@"%@", dbHomePath);
    compareKeyArr = @[@"=", @"LIKE", @">", @"<"];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:dbPath];
    if (![dataBase open]) {
        HelpLog(@"无法获取数据库");
        return;
    }
    [dataBase close];
}

+ (NSString *)compareKey:(CompareKey)compareKey{
    return [compareKeyArr objectAtIndex:compareKey];
}

+ (void)createTable:(NSString *)tableName withKeyTypeDic:(NSDictionary *)keyTypeDic{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbHomePath];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",tableName]];
        int count = 0;
        for (NSString *key in keyTypeDic) {
            count++;
            [sql appendString:key];
            [sql appendString:@" "];
            [sql appendString:[keyTypeDic valueForKey:key]];
            if (count != [keyTypeDic count]) {
                [sql appendString:@", "];
            }
        }
        [sql appendString:@")"];
        HelpLog(@"%@",sql);
        [db executeUpdate:sql];
    }];
}

+ (BOOL)isTableExist:(NSString *)tableName{
    FMDatabase *dataBase = [FMDatabase databaseWithPath:dbHomePath];
    [dataBase open];
    FMResultSet *rs = [dataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next]){
        NSInteger count = [rs intForColumn:@"count"];
        [dataBase close];
        if (0 == count){
            return NO;
        }
        else{
            return YES;
        }
    }
    [dataBase close];
    return NO;
}

+ (void)insertKeyValues:(NSDictionary *)keyValueDic intoTable:(NSString *)tableName{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbHomePath];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSArray *keys = [keyValueDic allKeys];
        NSArray *values = [keyValueDic allValues];
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"INSERT INTO %@ (", tableName]];
        NSInteger count = 0;
        for (NSString *key in keys) {
            [sql appendString:key];
            count ++;
            if (count < [keys count]) {
                [sql appendString:@", "];
            }
        }
        [sql appendString:@") VALUES ("];
        for (int i = 0; i < [values count]; i++) {
            [sql appendString:@"?"];
            if (i < [values count] - 1) {
                [sql appendString:@","];
            }
        }
        [sql appendString:@")"];
        HelpLog(@"%@", sql);
        [db executeUpdate:sql withArgumentsInArray:values];
    }];
}

+ (void)updateTable:(NSString *)tableName updateDic:(NSDictionary *)updateDic andOrKey:(AndOrKey)andOrKey compareKeyArr:(NSArray<NSString *> *)compareKeyArr columnArr:(NSArray<NSDictionary *> *)columnArr{
    if (compareKeyArr.count != columnArr.count) {
        return;
    }
    
    NSMutableArray *updateCompareKeyArr = [NSMutableArray array];
    NSMutableArray *updateArr = [NSMutableArray array];
    for (NSString *str in updateDic.allKeys) {
        [updateCompareKeyArr addObject:[self compareKey:CompareKeyEqual]];
        [updateArr addObject:@{str:updateDic[str]}];
    }
    
    NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"UPDATE %@ SET ",tableName]];
    [sql appendString:[self assembleWithAndOrKey:CommaKey isWhereSQL:NO compareKeyArr:updateCompareKeyArr columnArr:updateArr]];
    [sql appendString:[self assembleWithAndOrKey:andOrKey isWhereSQL:YES compareKeyArr:compareKeyArr columnArr:columnArr]];
    HelpLog(@"%@",sql);
    NSMutableArray *paramArr = [NSMutableArray array];
    [self addArgumentsToArray:paramArr WithColumnArr:updateArr];
    [self addArgumentsToArray:paramArr WithColumnArr:columnArr];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbHomePath];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSError *error;
        BOOL result = [db executeUpdate:sql values:paramArr error:&error];
        if (!result) {
            HelpLog(@"%@",error);
            *rollback = YES;
        }
    }];
}

+ (void)deleteTable:(NSString *)tableName andOrKey:(AndOrKey)andOrKey compareKeyArr:(NSArray<NSString *> *)compareKeyArr columnArr:(NSArray<NSDictionary *> *)columnArr{
    if (compareKeyArr.count != columnArr.count) {
        return;
    }
    NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"DELETE FROM %@ ",tableName]];
    [sql appendString:[self assembleWithAndOrKey:andOrKey isWhereSQL:YES compareKeyArr:compareKeyArr columnArr:columnArr]];
    
    NSMutableArray *paramArr = [NSMutableArray array];
    [self addArgumentsToArray:paramArr WithColumnArr:columnArr];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbHomePath];
    [queue inTransaction:^(FMDatabase *dataBase, BOOL *rollback) {
        NSError *error;
        BOOL result = [dataBase executeUpdate:sql values:paramArr error:&error];
        if (!result) {
            *rollback = YES;
            HelpLog(@"%@",error);
        }
    }];
}

+ (void)deleteTable:(NSString *)tableName{
    [self deleteTable:tableName andOrKey:NoneKey compareKeyArr:nil columnArr:nil];
}

+ (void)dropTable:(NSString *)tableName{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbHomePath];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",tableName];
        [db executeUpdate:sql];
    }];
}


+ (NSArray *)selectDataFromTable:(NSString *)tableName andOrKey:(AndOrKey)andOrKey compareKeyArr:(NSArray<NSString *> *)compareKeyArr columnArr:(NSArray<NSDictionary *> *)columnArr{
    if (compareKeyArr.count != columnArr.count) {
        return nil;
    }
    NSMutableString *sql = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"SELECT * FROM %@ ",tableName]];
    
    [sql appendString:[self assembleWithAndOrKey:andOrKey isWhereSQL:YES compareKeyArr:compareKeyArr columnArr:columnArr]];
    
    NSMutableArray *paramArr = [NSMutableArray array];
    [self addArgumentsToArray:paramArr WithColumnArr:columnArr];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbHomePath];
    __block FMResultSet *resultSet;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSError *error;
        resultSet = [db executeQuery:sql withArgumentsInArray:paramArr];
        if (!resultSet) {
            HelpLog(@"%@",error);
        }
    }];
    
    NSMutableArray *resultArr = [NSMutableArray array];
    while ([resultSet next]) {
        [resultArr addObject:[resultSet resultDictionary]];
    }
    [resultSet close];
    return resultArr;
}

+ (NSArray *)selectDataFromTable:(NSString *)tableName{
    return [self selectDataFromTable:tableName andOrKey:NoneKey compareKeyArr:nil columnArr:nil];
}

#pragma tool method
+ (NSMutableArray *)addArgumentsToArray:(NSMutableArray *)argumentsArray WithColumnArr:(NSArray<NSDictionary *> *)columnArr{
    if (!argumentsArray) {
        return nil;
    }
    if (!columnArr) {
        return argumentsArray;
    }
    for (int i = 0; i < columnArr.count; i++) {
        NSDictionary *dic = columnArr[i];
        [argumentsArray addObject:[dic objectForKey:dic.allKeys.lastObject]];
    }
    return argumentsArray;
}

+ (NSMutableString *)assembleWithAndOrKey:(AndOrKey)andOrKey isWhereSQL:(BOOL)isWhereSQL compareKeyArr:(NSArray<NSString *> *)compareKeyArr columnArr:(NSArray<NSDictionary *> *)columnArr{
    NSMutableString *sql = [NSMutableString stringWithFormat:@""];
    if (!compareKeyArr || !columnArr || compareKeyArr.count == 0 || columnArr.count == 0) {
        return sql;
    }
    if (compareKeyArr.count != columnArr.count) {
        return sql;
    }
    NSUInteger cycleTimes = compareKeyArr.count;
    NSString *connectKey = @"";
    switch (andOrKey) {
        case AndKey:
            connectKey = @"AND";
            break;
        case OrKey:
            connectKey = @"OR";
            break;
        case CommaKey:
            connectKey = @",";
            break;
        case NoneKey:
            cycleTimes = 1;
            break;
        default:
            break;
    }
    for (int i = 0; i < cycleTimes; i++) {
        NSString *colunmKey = columnArr[i].allKeys.lastObject;
        if (i == 0) {
            if (isWhereSQL) {
                [sql appendFormat:@"WHERE %@ %@ ? ",colunmKey, compareKeyArr[i]];
            }else{
                [sql appendFormat:@"%@ %@ ? ",colunmKey, compareKeyArr[i]];
            }
        }else{
            [sql appendFormat:@"%@ %@ %@ ? ", connectKey, colunmKey, compareKeyArr[i]];
        }
    }
    HelpLog(@"%@",sql);
    return sql;
}


+ (void)addArgumentArr:(NSMutableArray *)argumentArr FromDic:(NSDictionary *)dic{
    if (!argumentArr) {
        return;
    }
    if (!dic) {
        return;
    }
    NSArray *dicKeys = dic.allKeys;
    for (int i = 0; i < dicKeys.count; i++) {
        [argumentArr addObject:[dic objectForKey:dicKeys[i]]];
    }
}

+ (FMResultSet *)executeQueryConditionSQL:(NSString *)sql condition:(NSDictionary *)condition{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbHomePath];
    __block FMResultSet *resultSet;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSError *error;
        NSMutableArray *argumentArr = [NSMutableArray array];
        [self addArgumentArr:argumentArr FromDic:condition];
        resultSet = [db executeQuery:sql withArgumentsInArray:argumentArr];
        if (!resultSet) {
            HelpLog(@"%@",error);
        }
    }];
    return resultSet;
}


@end
