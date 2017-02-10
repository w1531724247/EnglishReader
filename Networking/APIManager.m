//
//  APIManager.m
//  EnglishReader
//
//  Created by QMTV on 17/1/8.
//  Copyright © 2017年 LFC. All rights reserved.
//
/*百度翻译
 APP ID: 20170108000035424
 密钥: rV_JVX5ImM9Lf0bown9M
 */
#define kBaiduAPPID 20170108000035424
#define kBaiduAPPKey @"rV_JVX5ImM9Lf0bown9M"
#define kBaiduHost @"http://api.fanyi.baidu.com/api/trans/vip/translate"
//#define kBaiduHost @"https://fanyi-api.baidu.com/api/trans/vip/translate"

#import "APIManager.h"
#import <CommonCrypto/CommonDigest.h>//MD5加密

@interface APIManager ()
@property (nonatomic, strong, readwrite) AFHTTPSessionManager *networkSessionMananger;

@end

@implementation APIManager

- (void)dealloc {
    [_networkSessionMananger.session invalidateAndCancel];
    _networkSessionMananger = nil;
}

#pragma mark --- public
//从百度翻译API查询结果
- (void)getInterpretFromBaiduServerWithText:(NSString *)text {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (text && [text isKindOfClass:[NSString class]] && text.length > 0) {
        [params setValue:text forKey:@"q"];//必填参数, string
    }
    [params setValue:@"auto" forKey:@"from"];//必填参数, string
    [params setValue:@"zh" forKey:@"to"];//必填参数, 中文, string
    [params setValue:@(kBaiduAPPID) forKey:@"appid"];//必填参数, int
    int salt = arc4random()%1000;
    [params setValue:@(salt) forKey:@"salt"];//必填参数, 随机数, int
    [params setValue:[self getBaiduSignWithText:text salt:salt] forKey:@"sign"];//必填参数, string, appid+q+salt+密钥 的MD5值
    
    [self POST:kBaiduHost parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(getInterpretFromBaiduServerSuccessed:withResponse:)]) {
            [self.delegate getInterpretFromBaiduServerSuccessed:YES withResponse:[self dataToDictionary:responseObject]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(getInterpretFromBaiduServerSuccessed:withResponse:)]) {
            [self.delegate getInterpretFromBaiduServerSuccessed:NO withResponse:error];
        }
    }];
}

#pragma mark --- private

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    if (!URLString || URLString.length < 1) {
        NSURLSessionDataTask *task = [[NSURLSessionDataTask alloc] init];
        return task;
    }
    
    NSURLSessionDataTask *dataTask = [self.networkSessionMananger POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
    
    return dataTask;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    if (!URLString || URLString.length < 1) {
        NSURLSessionDataTask *task = [[NSURLSessionDataTask alloc] init];
        return task;
    }
    
    NSURLSessionDataTask *task = [self.networkSessionMananger GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
    
    return task;
}

- (NSString *)getBaiduSignWithText:(NSString *)text salt:(int)salt {
    NSString *sign = [NSString stringWithFormat:@"%zi%@%d%@", kBaiduAPPID, text, salt, kBaiduAPPKey];
    NSString *md5 = [self md5String:sign];
    
    return md5;
}

//32位小写md5
- (NSString *)md5String:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    NSString *md5 = [NSString stringWithFormat:
                     @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                     result[0], result[1], result[2], result[3],
                     result[4], result[5], result[6], result[7],
                     result[8], result[9], result[10], result[11],
                     result[12], result[13], result[14], result[15]
                     ];
    return md5;
}

- (NSDictionary *)dataToDictionary:(NSData *)data {
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (dictionary && [dictionary isKindOfClass:[NSDictionary class]]) {
        return dictionary;
    } else {
        return [NSDictionary dictionary];
    }
}

#pragma mark --- getter

- (AFHTTPSessionManager *)networkSessionMananger {
    if (!_networkSessionMananger) {
        _networkSessionMananger = [[AFHTTPSessionManager alloc] init];
        _networkSessionMananger.requestSerializer = [AFHTTPRequestSerializer serializer];
        _networkSessionMananger.requestSerializer.timeoutInterval = 10.0;
        _networkSessionMananger.responseSerializer = [AFHTTPResponseSerializer serializer];
        _networkSessionMananger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"image/png", nil];
        [_networkSessionMananger.securityPolicy setAllowInvalidCertificates:YES];
    }
    
    return _networkSessionMananger;
}

@end
