//
//  StorageManager.m
//  WFKit
//
//  Created by  GaoGao on 2020/2/18.
//  Copyright © 2020年 王宇. All rights reserved.
//

#import "StorageManager.h"
#import <FMDB/FMDB.h>


static StorageManager *_instance = nil;

// Table SQL
static NSString *const CreatePageTableSQL = @"CREATE TABLE IF NOT EXISTS PageCollectTable(ObjectData BLOB NOT NULL,CreatehDate TEXT NOT NULL);";

static NSString *const CreateEventTableSQL = @"CREATE TABLE IF NOT EXISTS EventCollectTable(ObjectData BLOB NOT NULL,CreatehDate TEXT NOT NULL);";

// Table Name
static NSString *const PageCollectModelTable = @"PageCollectTable";

static NSString *const EventCollectModelTable = @"EventCollectTable";

// Column Name
static NSString *const ObjectDataColumn = @"ObjectData";

static NSString *const CreateDateColumn = @"CreatehDate";

@interface StorageManager ()

//db
@property (strong , nonatomic) FMDatabaseQueue * dbQueue;

@end

@implementation StorageManager


// init
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[StorageManager alloc] init];
        [_instance initDB];
    });
    return _instance;
}

/**保存数据 type 1 页面 2事件*/
- (void)saveData:(NSData *)data withType:(int)type;{
    
    if ([self insertData:data WithTable:(type==1?PageCollectModelTable:EventCollectModelTable)])
        // 查询所有数据
        [self getAllDatas];
    
    
}



/** 删除数据 */
- (BOOL)deletePageData:(NSArray *)pageArray andeEventData:(NSArray *)eventArray;{
    
    return ([self removeData:pageArray withTable:PageCollectModelTable] &&[self removeData:eventArray withTable:EventCollectModelTable]);
    
//    [self removeData:pageArray withTable:PageCollectModelTable];
    
//    [self removeData:eventArray withTable:EventCollectModelTable];
    
}


/** 根据 table删除数据*/

-(BOOL)removeData:(NSArray *)dataArray withTable:(NSString *)table{
    
    NSMutableArray *dataArrayCopy = [[NSMutableArray alloc]initWithArray:dataArray];
    
    for (NSData *data in dataArray) {
        
        __block BOOL ret = NO;
        [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
            NSError *error;
            ret = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",table,ObjectDataColumn] values:@[data] error:&error];
            if (ret) {
                [dataArrayCopy removeObjectAtIndex:0];
            }
        }];
    }
    return !dataArrayCopy.count;
    
    
    
}


// 查询所有数据
- (void)getAllDatas {
    // 调用代理方法
    [self.delegate inceptPageData:[self queryDataWithTable:PageCollectModelTable] andeEventData:[self queryDataWithTable:EventCollectModelTable]];
    
    
}



// 插入数据

-(BOOL)insertData:(NSData*)data WithTable:(NSString *)tabelName{
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([[NSDate date] timeIntervalSince1970]*1000)];
    
    __block NSArray *arguments = @[data, timeSp,];
    __block BOOL ret = NO;
    
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSError *error;
        ret = [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@(%@,%@) VALUES (?,?);",tabelName,ObjectDataColumn,CreateDateColumn] values:arguments error:&error];
        if (!ret) {
            NSLog(@"INSERT DATA fail,Error = %@",error.localizedDescription);
        } else {
            NSLog(@"INSERT DATA success!");
            
        }
    }];
    
    return ret;
}



// 根据表格查询数据
- (NSArray *)queryDataWithTable:(NSString *)tableName {
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *set = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",tableName]];
        while ([set next]) {
            NSData *objectData = [set dataForColumn:ObjectDataColumn];
            [dataArray addObject:objectData];
        }
    }];
    
    return dataArray.copy;
}




//初始化 db
- (void)initDB {
    // 获取地址 Documen
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    doc = [doc stringByAppendingPathComponent:@"DBTool"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:doc]) {
        NSError *error;
        [[NSFileManager  defaultManager] createDirectoryAtPath:doc withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"DB创建失败, error = %@",error.description);
        }
        NSAssert(!error, error.description);
    }
    NSString *filePath = [doc stringByAppendingPathComponent:@"DBTool.db"];
    
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    NSLog(@"DB-FilePath--->:%@",filePath);
    __block BOOL page = NO;
    __block BOOL action = NO;
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        // 控制器
        page = [db executeUpdate:CreatePageTableSQL];
        // 事件
        action = [db executeUpdate:CreateEventTableSQL];
        if (!page) {
            NSLog(@"PAGE TABLE 创建失败");
        }
        if(!action){
            NSLog(@"EVENT TABLE 创建失败");
        }
    }];
}



@end
