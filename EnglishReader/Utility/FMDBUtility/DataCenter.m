//
//  DataCenter.m
//  Test
//
//  Created by QMTV on 16/5/18.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import "DataCenter.h"
#import <sys/sysctl.h>
#import "FMDBKeyValueTable.h"
#import "NSString+YFExtension.h"
#import "QMCommonHeader.h"
#import "PurchaseActionModel.h"
#import "ResolutionDataModel.h"
#import "LiveCategoryModel.h"
#import "SecretKeyModel.h"
#import "QMTool.h"
#import "PusherLiveRoomModel.h"
#import "PusherLiveRoomArchive.h"
#import "LiveCategoryModel.h"
#import "ZXUserModel.h"

#define MineInfo @"MineInfo"
#define SearchHistory @"SearchHistory"
#define CustomGiftTypeList @"CustomGiftTypeList"
#define GiftTypeList @"GiftTypeList"
#define RecommendPageLastRefreshDate @"RecommendPageLastRefreshDate"
#define AllLivePageLastRefreshDate @"AllLivePageLastRefreshDate"
#define ColumnDetailPageLastRefreshDate @"ColumnDetailPageLastRefreshDate"
#define FindPageLastRefreshDate @"FindPageLastRefreshDate"
#define AttientionPageLastRefreshDate @"AttentionPageLastRegfreshDate"
#define DeviceToken @"DeviceToken"
#define PurchasePersistenceModelKey @"PurchasePersistenceModelKey"
#define PurchaseActionModelKey @"PurchaseActionModelKey"
#define PushLiveLandscapeModelKey @"PushLiveLandscapeModelKey"
#define PushLivePorstraitModelKey @"PushLivePorstraitModelKey"
#define PushLiveSecretModelKey @"PushLiveSecretModelKey"
#define PusherLiveRoomModelKey @"PusherLiveRoomModelKey"
#define PusherLiveRoomArchiveKey @"PusherLiveRoomArchiveKey"
#define PusherLiveRoomArchiveByUserIDKey @"PusherLiveRoomArchiveByUserIDKey"
#define PushLiveLandscapeCategoryKey @"PushLiveLandscapeCategoryKey"
#define MINECENTER_NEEDLOGOUT @"MINECENTER_NEEDLOGOUT"
#define PURCHASEACTIONPAGE @"PurchaseActionPage"
#define kLaunchVideoWatched @"kLaunchVideoWatched"//启动视屏是否观看过
#define CHANGFULLSCREENEBARRAGEFONT @"CHANGFULLSCREENEBARRAGEFONT"//全屏状态的字体通知
#define CHANGETOUMINGDU @"CHANGETOUMINGDU" //弹幕透明度
#define CHANGETEXTPOSITION @"CHANGETEXTPOSITION" //弹幕位置
#define kRequestTimeOut @"kRequestTimeOut"//网络请求超时时间
#define BARRAEGISON @"BARRAEGISON"  //弹幕开关记录
#define GIFIISON @"GIFIISON" //礼物开关记录

#define MEDIADECODE @"MEDIADECODE"             //解码
#define VOICEVALUE @"VOICEVALUE"                //声音
#define BRIGHTNESSVALUE @"BRIGHTNESSVALUE"      //亮度
#define GIFTSWITH @"GIFTSWITH"                  //礼物
#define SCREENGESTURE @"SCREENGESTURE"          //手势
#define VOICEBACKGROUND @"VOICEBACKGROUND"       //后台声音播放
#define REMINDTIME @"REMINDTIME"                 //剩余时间
#define CURRENTTIMERINDEX @"CURRENTTIMERINDEX"    //记录计时器的index
#define TIMEROPENOROFF   @"TIMEROPENOROFF"        //计时器的开关
#define PUSHLIVEDEFINSTION @"PUSHLIVEDEFINSTION"  //推流房间清晰度

#define BARRAGELISTVIEWUSEH5 @"BARRAGELISTVIEWUSEH5" //弹幕列表视图使用H5
#define SAVECHANGEDSLIDERVALUE @"saveChangedSliderValue" //文字slidervalue
#define OftenUsedCategoryArray @"OftenUsedCategoryArray" //常用分类数组
#define ShowWaterMark @"ShowWaterMark" //显示水印
#define NeedPhonenumber @"NeedPhonenumber" //发弹幕是否需要手机
#define PayEnable       @"PayEnable"//支付开关
#define AllowPortraitForOldVersion @"AllowPortraitForOldVersion" //禁止旧版本观看竖屏直播
#define PushLiveState @"PushLiveState" // 推流状态
#define PushLiveVideoState @"PushLiveVideoState"
#define PushLiveMagicState @"PushLiveMagicState"
#define PushLiveMirrorState @"PushLiveMirrorState" //镜像开关
#define PushLiveFlightState @"PushLiveFlightState" //闪光灯

#define NotChecking @"NotChecking" //不在审核
#define FirstOpenPushLive @"FirstOpenPushLive" //第一应用打开
#define kLastSharePlatform @"LastSharePlatform"
#define TabOptionArray @"TabOptionArray" //tab选项
#define LastShowGameCenterTipTime @"LastShowGameCenterTipTime"//最后一次显示游戏中心红点的提示
#define UserClearedOftenUsedCategoryArray @"UserClearedOftenUsedCategoryArray"//用户是否清空了常用分类列表
#define kGiftConfigList @"kGiftConfigList"//礼物配置信息
#define kLiveParametersPlistName @"PusherLiveParameter"
#define kLandscapeResolutionKey @"LandscapeResolution"
#define kPortraitResolutionKey @"PortraitResolution"
#define KObserveNotificationState @"KObserveNotificationState"
#define KGameCenterTipText @"KGameCenterTipText"//游戏中心提示文案
#define KShowGame @"KShowGame"//游戏中心开关
#define kQueryLogRefer @"kQueryLogRefer"//发送网络请求时所在的页面

#define kMD5value @"kMD5value"  //md5
#define kMD5valueLaoction @"kMD5valueLaoction" //大礼物文件地址

#define kMDoc_contentArr @"kMDoc_contentArr" //配置平台配置文案

#define kChangeColumnFlag @"kChangeColumn"//是否改变过分栏
#define kRobedChestIDs @"kRobedChestIDs"//抢过的宝箱ID的数组

#define kSavedAppVersion @"kSavedAppVersion"    //保存的app版本
#define kBannerConfigList @"kBannerConfigList"    //横幅配置列表

////////////////////////////////////////////////////////////////////////
//引导页
////////////////////////////////////////////////////////////////////////
#define kFullScreenGurided @"kFullScreenGurided" //全屏播放引导
#define kScreenshotsShare @"kScreenshotsShare" //截屏引导
#define kFullScreenShake @"kFullScreenShake"  //摇一摇引导


@implementation DataCenter

+ (void)saveUserInfoData:(NSDictionary *)data{
    NSAssert([data isKindOfClass:[NSDictionary class]], @"data must be NSDictionary or subClass");
    
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [[FMDBKeyValueTable shareTable] setDictionary:data forKey:MineInfo];
}

+ (void)setSid:(NSString *)sid {
    [[FMDBKeyValueTable shareTable] setValue:sid forKey:@"user_sid"];
}

+ (NSString *)getSid {
    return [[FMDBKeyValueTable shareTable] getValueForKey:@"user_sid"];
}

+ (void)setToken:(NSString *)token {
    [[FMDBKeyValueTable shareTable] setValue:token forKey:@"user_token"];
}

+ (NSString *)getToken {
    return [[FMDBKeyValueTable shareTable] getValueForKey:@"user_token"];
}

+ (NSDictionary *)getUserInfo {
    NSDictionary *mineDict = [[FMDBKeyValueTable shareTable] getDictionaryForKey:MineInfo];
    if (nil == mineDict) {
        mineDict = [NSDictionary dictionary];
    }
    
    return mineDict;
}

+ (NSString *)getSeedTextStr{
    NSDictionary *userDict = [DataCenter getUserInfo];
    NSString *seedStr = [NSString string];
    if ([userDict getObjectForKey:@"money"]) {
        seedStr = [NSString stringWithFormat:@"%@", [userDict getStringForKey:@"money"]];
    }else{
        seedStr = @"0";
    }
    return [[NSString stringWithFormat:@"%@",seedStr] convertStrWith:3];
}

+ (NSString *)getCoinTextStr{
    NSDictionary *userDict = [DataCenter getUserInfo];
    NSString *coinStr = [NSString string];
    if ([userDict getStringForKey:@"coin"]) {
        coinStr = [NSString stringWithFormat:@"%@", [userDict getStringForKey:@"coin"]];
    }else{
        coinStr = @"0";
    }
    
    return [[NSString stringWithFormat:@"%@",coinStr] convertStrWith:3];
}

+ (NSString *)getNickNameStr{
    NSDictionary *userDict = [DataCenter getUserInfo];
    NSString *nickNameStr = [userDict getStringForKey:@"nickname"];
    if (nickNameStr.length < 1) {
        nickNameStr = @"当前登录用户";
    }
    
    return nickNameStr;
}


+ (NSInteger)getUserID{
    NSInteger userID = 0;
    
    NSDictionary *infoDic = [DataCenter getUserInfo];
//    id idObj = [infoDic getValueForKey:@"id"];
//    if ([idObj respondsToSelector:@selector(integerValue)]) {
//        userID = [idObj integerValue];
//    }
    
    userID = [infoDic getIntForKey:@"id"];
    return userID;
}

+(void)setIsAdmin:(BOOL)isAdmin{
    [[FMDBKeyValueTable shareTable] setValue:@(isAdmin) forKey:@"isAmdin"];
}

+(BOOL)getIsAdmin{
    return [[[FMDBKeyValueTable shareTable] getValueForKey:@"isAmdin"] boolValue];
}

+(void)setIsAnchor:(BOOL)isAnchor{
    [[FMDBKeyValueTable shareTable] setValue:@(isAnchor) forKey:@"isAnchor"];
}

+(BOOL)getIsAnchor{

    return [[[FMDBKeyValueTable shareTable] getValueForKey:@"isAnchor"] boolValue];
}

+ (void)cleanUserInfo{
    [[FMDBKeyValueTable shareTable] deleteValueForKey:MineInfo];
}

+ (void)updateUserIcon:(NSString *)usericon{
    NSAssert([usericon isKindOfClass:[NSString class]], @"usericon must be NSString or subClass");
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:[DataCenter getUserInfo]];
    [tempDict setValue:usericon forKey:@"avatar"];
    [DataCenter saveUserInfoData:tempDict];
}

+ (BOOL)getUserE_MailInfo{
    NSDictionary *mineDict = [DataCenter getUserInfo];
    NSString *email = [mineDict getStringForKey:@"email"];
    if (nil == email || [email isEqualToString:@""]) {
        return NO;
    }else{
        return YES;
    }
}

+ (BOOL)getUserTelNumInfo{
    NSDictionary *mineDict = [DataCenter getUserInfo];
    NSString *mobile = [mineDict getStringForKey:@"mobile"];
    if (nil == mobile || [mobile isEqualToString:@""]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)verifyE_Mail:(NSString *)usereamil{
    NSAssert([usereamil isKindOfClass:[NSString class]], @"usereamil must be NSString or subClass");
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:[DataCenter getUserInfo]];
    [tempDict setValue:usereamil forKey:@"email"];
    [DataCenter saveUserInfoData:tempDict];
}

+ (void)setTelNum:(NSString *)usertelnum{
    NSAssert([usertelnum isKindOfClass:[NSString class]], @"usertelnum must be NSString or subClass");
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:[DataCenter getUserInfo]];
    [tempDict setValue:usertelnum forKey:@"mobile"];
    [DataCenter saveUserInfoData:tempDict];
}

+ (BOOL)getLoginInfo{
    NSDictionary *mineInfo = [DataCenter getUserInfo];
    if (0 == mineInfo.allKeys.count) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)saveUserSearchRecord:(NSString *)recordStr{
    NSArray *oldArray = [[FMDBKeyValueTable shareTable] getArrayForKey:SearchHistory];
    NSMutableArray *historyArray = [NSMutableArray arrayWithArray:oldArray];
    if ([historyArray containsObject:recordStr]) {
        [historyArray removeObject:recordStr];
    }
    [historyArray insertObject:recordStr atIndex:0];
    
    [[FMDBKeyValueTable shareTable] setArray:historyArray forKey:SearchHistory];
}

+ (NSArray *)getUserSearchRecord{
    
    NSArray *historyArray = [[FMDBKeyValueTable shareTable] getArrayForKey:SearchHistory];
    return historyArray;
}

+ (NSArray *)deleteSearchRecord:(NSInteger)index{
    NSArray *oldArray = [[FMDBKeyValueTable shareTable] getArrayForKey:SearchHistory];
    NSMutableArray *historyArray = [NSMutableArray arrayWithArray:oldArray];
    [historyArray removeObjectAtIndex:index];
    [[FMDBKeyValueTable shareTable] setArray:historyArray forKey:SearchHistory];
    
    return historyArray;
}

+ (BOOL)deleteAllSearchRecord{
    return [[FMDBKeyValueTable shareTable] deleteValueForKey:SearchHistory];
}

+ (NSString *)getCurrentDeviceModel{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    return platform;
}

+ (void)saveGiftTypeData:(NSDictionary *)data{
    NSAssert([data isKindOfClass:[NSDictionary class]], @"data must be NSDictionary or subClass");
    
    [[FMDBKeyValueTable shareTable] setDictionary:data forKey:GiftTypeList];
}

+ (NSDictionary *)getGitfType{
    NSDictionary *giftTypeDict = [[FMDBKeyValueTable shareTable] getDictionaryForKey:GiftTypeList];
    
    return giftTypeDict;
}


+ (void)setRecommendPageLastRefreshDate{
    NSDate *curentDate = [DataCenter getCurrentDate];
    NSString *dataString = [DataCenter stringFromDate:curentDate];
    
    [[FMDBKeyValueTable shareTable] setValue:dataString forKey:RecommendPageLastRefreshDate];
}

+ (BOOL)recommendPageNeedRefresh{
    
    BOOL needRefresh = NO;
    
    NSString *lastDateString = [[FMDBKeyValueTable shareTable] getValueForKey:RecommendPageLastRefreshDate];
    
    NSDate *lastDate = [DataCenter dateFromString:lastDateString];
    NSDate *curentDate = [DataCenter getCurrentDate];
    //两个日期之间相隔多少秒
    NSTimeInterval secondsBetweenDates= [curentDate timeIntervalSinceDate:lastDate];
    if (secondsBetweenDates > 30*60) {
        needRefresh = YES;
    }
    
    return needRefresh;
}



+ (void)setAllLivePageLastRefreshDate{
    NSDate *curentDate = [DataCenter getCurrentDate];
    NSString *dataString = [DataCenter stringFromDate:curentDate];
    
    [[FMDBKeyValueTable shareTable] setValue:dataString forKey:AllLivePageLastRefreshDate];
}

+ (BOOL)allLivePageNeedRefresh{
    
    BOOL needRefresh = NO;
    
    NSString *lastDateString = [[FMDBKeyValueTable shareTable] getValueForKey:AllLivePageLastRefreshDate];
    
    NSDate *lastDate = [DataCenter dateFromString:lastDateString];
    NSDate *curentDate = [DataCenter getCurrentDate];
    //两个日期之间相隔多少秒
    NSTimeInterval secondsBetweenDates= [curentDate timeIntervalSinceDate:lastDate];
    if (secondsBetweenDates > 30*60) {
        needRefresh = YES;
    }
    
    return needRefresh;
}


+ (void)setColumnPageLastRefreshDate:(NSString *)slugString{

    NSDate *curentDate = [DataCenter getCurrentDate];
    NSString *dataString = [DataCenter stringFromDate:curentDate];
    NSString *homePageTag = [NSString stringWithFormat:@"%@%@",@"homePageColumns",slugString];
    [[FMDBKeyValueTable shareTable] setValue:dataString forKey:homePageTag];

}

+ (BOOL)columnsPageNeedRefresh:(NSString *)slugString{
    
    BOOL needRefresh = NO;
    NSString *homePageTag = [NSString stringWithFormat:@"%@%@",@"homePageColumns",slugString];
    NSString *lastDateString = [[FMDBKeyValueTable shareTable] getValueForKey:homePageTag];
    
    NSDate *lastDate = [DataCenter dateFromString:lastDateString];
    NSDate *curentDate = [DataCenter getCurrentDate];
    //两个日期之间相隔多少秒
    NSTimeInterval secondsBetweenDates= [curentDate timeIntervalSinceDate:lastDate];
    if (secondsBetweenDates > 30*60) {
        needRefresh = YES;
    }
    
    return needRefresh;
}



+ (void)setColumnDetailPageLastRefreshDate{
    NSDate *curentDate = [DataCenter getCurrentDate];
    NSString *dataString = [DataCenter stringFromDate:curentDate];
    
    [[FMDBKeyValueTable shareTable] setValue:dataString forKey:ColumnDetailPageLastRefreshDate];
}

+ (BOOL)columnDetailNeedRefresh{
    BOOL needRefresh = NO;
    
    NSString *lastDateString = [[FMDBKeyValueTable shareTable] getValueForKey:ColumnDetailPageLastRefreshDate];
    
    NSDate *lastDate = [DataCenter dateFromString:lastDateString];
    NSDate *curentDate = [DataCenter getCurrentDate];
    //两个日期之间相隔多少秒
    NSTimeInterval secondsBetweenDates= [curentDate timeIntervalSinceDate:lastDate];
    if (secondsBetweenDates > 30*60) {
        needRefresh = YES;
    }
    
    return needRefresh;
}

+ (void)setFindPageLastRefreshDate{
    NSDate *curentDate = [DataCenter getCurrentDate];
    NSString *dataString = [DataCenter stringFromDate:curentDate];
    
    [[FMDBKeyValueTable shareTable] setValue:dataString forKey:FindPageLastRefreshDate];
}

+ (BOOL)findPageNeedRefresh{
    BOOL needRefresh = NO;
    
    NSString *lastDateString = [[FMDBKeyValueTable shareTable] getValueForKey:FindPageLastRefreshDate];
    
    NSDate *lastDate = [DataCenter dateFromString:lastDateString];
    NSDate *curentDate = [DataCenter getCurrentDate];
    //两个日期之间相隔多少秒
    NSTimeInterval secondsBetweenDates= [curentDate timeIntervalSinceDate:lastDate];
    if (secondsBetweenDates > 30*60) {
        needRefresh = YES;
    }
    
    return needRefresh;
}

+ (void)setAttentionPageLastRefreshDate{
    NSDate *curentDate = [DataCenter getCurrentDate];
    NSString *dataString = [DataCenter stringFromDate:curentDate];
    
    [[FMDBKeyValueTable shareTable] setValue:dataString forKey:AttientionPageLastRefreshDate];
}

+ (BOOL)attentionPageNeedRefresh{
    BOOL needRefresh = NO;
    
    NSString *lastDateString = [[FMDBKeyValueTable shareTable] getValueForKey:AttientionPageLastRefreshDate];
    
    NSDate *lastDate = [DataCenter dateFromString:lastDateString];
    NSDate *curentDate = [DataCenter getCurrentDate];
    //两个日期之间相隔多少秒
    NSTimeInterval secondsBetweenDates= [curentDate timeIntervalSinceDate:lastDate];
    if (secondsBetweenDates > 30*60) {
        needRefresh = YES;
    }
    
    return needRefresh;
}

+ (NSString *)getDeviceToken{
    return [[FMDBKeyValueTable shareTable] getValueForKey:DeviceToken];
}

+ (void)saveDeviceToken:(NSString *)deviceToken{
    NSAssert([deviceToken isKindOfClass:[NSString class]], @"deviceToken must be NSString or subClass");
    
    [[FMDBKeyValueTable shareTable] setValue:deviceToken forKey:DeviceToken];
}

+ (BOOL)isAllowedNotification{
    //iOS8 check if user allow notification
    if (IOS_VERSION_8_OR_ABOVE) {// system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    } else {//iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }
    
    return NO;
}

+ (void)savePurchasePersistenceModel:(PurchasePersistenceModel *)purchasePersistenceModel{
    NSArray *oldArray = [[FMDBKeyValueTable shareTable] getArrayForKey:PurchasePersistenceModelKey];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:oldArray];
    NSString *modelDict = [purchasePersistenceModel modelToJSONString];
    [mutableArray addObject:modelDict];
    [[FMDBKeyValueTable shareTable] setArray:mutableArray forKey:PurchasePersistenceModelKey];
}

+ (NSArray *)getPurchasePersitenceMutableArrayByState:(PurchaseState)purchaseStae{
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    NSArray *oldArray = [[FMDBKeyValueTable shareTable] getArrayForKey:PurchasePersistenceModelKey];
    
    for (NSString *jsonString in oldArray) {
        PurchasePersistenceModel *purchasePersistenceModel = [PurchasePersistenceModel modelWithJSON:jsonString];
        if (purchasePersistenceModel.purchaseState == purchaseStae && purchasePersistenceModel.userID == kZXUserInfo.uid) {
            [mutableArray addObject:purchasePersistenceModel];
        }
    }
    
    return mutableArray;
}

+ (void)changePurchasePersitenceModelStateForOrderID:(NSInteger)orderID{
    if (orderID == 0) {
        return;
    }
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSArray *oldArray = [[FMDBKeyValueTable shareTable] getArrayForKey:PurchasePersistenceModelKey];
    if (oldArray.count < 1) {
        return;
    }
    
    for (NSString *jsonString in oldArray) {
        PurchasePersistenceModel *purchasePersistenceModel = [PurchasePersistenceModel modelWithJSON:jsonString];
        if (purchasePersistenceModel.purchaseNum == orderID) {
            purchasePersistenceModel.purchaseState = PurchaseStateCompeted;
            //订单已完成从本地移除
            continue;
        }
        [mutableArray addObject:jsonString];
    }
    
    [[FMDBKeyValueTable shareTable] setArray:mutableArray forKey:PurchasePersistenceModelKey];
}

+ (void)savePurchaseActionModel:(PurchaseActionModel *)purchaseActionModel{
    NSString *modelStr = [purchaseActionModel modelToJSONString];
    [[FMDBKeyValueTable shareTable] setValue:modelStr forKey:PurchaseActionModelKey];
}

+ (PurchaseActionModel *)getPurchaseActionModel {
    NSString *modelStr = [[FMDBKeyValueTable shareTable] getValueForKey:PurchaseActionModelKey];
    PurchaseActionModel *actionModel = [PurchaseActionModel modelWithJSON:modelStr];
    if (actionModel == nil || ![actionModel isKindOfClass:[PurchaseActionModel class]]) {
        actionModel = [[PurchaseActionModel alloc] init];
    }
    return actionModel;
}

+ (void)changePurchaseActionState:(BOOL)state {
    PurchaseActionModel *actionModel = [DataCenter getPurchaseActionModel];
    actionModel.purchaseStatus = state;
    [DataCenter savePurchaseActionModel:actionModel];
}


+ (BOOL)purchaseActionStatus{
    BOOL purchaseActionStatus = NO;
    PurchaseActionModel *model = [self getPurchaseActionModel];
    purchaseActionStatus = model.purchaseStatus;
    return purchaseActionStatus;
}

+ (BOOL)isNeedLogout{
    BOOL isNeed = NO;
    
    isNeed = [[[FMDBKeyValueTable shareTable] getValueForKey:MINECENTER_NEEDLOGOUT] boolValue];
    
    return isNeed;
}

+ (void)setLogoutFlag:(BOOL)flag{
    [[FMDBKeyValueTable shareTable] setValue:@(flag) forKey:MINECENTER_NEEDLOGOUT];
}

+ (void)setPurchaseActionFlag:(BOOL)flag {
    NSInteger userID = kZXUserInfo.uid;
    
    NSDictionary *chargeDict = @{@"userID":@(userID),
                                 @"flag":@(flag)};
    NSMutableArray *chargeMutableArray = @[].mutableCopy;
    [chargeMutableArray addObject:chargeDict];
    NSArray *chargeArray = [[FMDBKeyValueTable shareTable] getArrayForKey:PURCHASEACTIONPAGE];
    [chargeMutableArray addObjectsFromArray:chargeArray];
    [[FMDBKeyValueTable shareTable] setArray:chargeMutableArray forKey:PURCHASEACTIONPAGE];
}

+ (BOOL)purchaseActionFlag {
    NSInteger userID = kZXUserInfo.uid;
    BOOL flag = NO;
    NSArray *chargeArray = [[FMDBKeyValueTable shareTable] getArrayForKey:PURCHASEACTIONPAGE];
    for (NSDictionary *dict in chargeArray) {
        if ([dict getIntForKey:@"userID"] == userID) {
            flag = [dict getBoolForKey:@"flag"];
        }
    }
    
    return flag;
}



+(NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat  = @"yyyy/MM/dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    return date;
}

+(NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat  = @"yyyy/MM/dd HH:mm:ss";
    
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)getCurrentDate{
    NSDate *systemDate = [NSDate date];
    //解决时差问题
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:systemDate];
    NSDate *curentDate = [systemDate  dateByAddingTimeInterval:interval];
    
    return curentDate;
}
//弹幕透明度
+ (void)saveChangedTextOpacity:(NSString *)opacity {
    [[FMDBKeyValueTable shareTable] setValue:opacity forKeyPath:CHANGETOUMINGDU];
}
+ (NSString *)textOpacity {
    return [[FMDBKeyValueTable shareTable] getValueForKey:CHANGETOUMINGDU];
}
+ (void)cleanTextOpacity {
    [[FMDBKeyValueTable shareTable] deleteValueForKey:CHANGETOUMINGDU];
}

//文字大小
+ (void)saveChangedTextFont:(NSString *)font {
    [[FMDBKeyValueTable shareTable] setValue:font forKeyPath:CHANGFULLSCREENEBARRAGEFONT];
}
+ (NSString *)textFont {
    return [[FMDBKeyValueTable shareTable] getValueForKey:CHANGFULLSCREENEBARRAGEFONT];
}
+ (void)cleanChangedTextFont {
    [[FMDBKeyValueTable shareTable] deleteValueForKey:CHANGFULLSCREENEBARRAGEFONT];
}
//文字slidervalue SAVECHANGEDSLIDERVALUE
+ (void)saveChangedSliderValue:(NSString *)value {
 [[FMDBKeyValueTable shareTable] setValue:value forKeyPath:SAVECHANGEDSLIDERVALUE];
}
+ (NSString *)sliderValue {
return [[FMDBKeyValueTable shareTable] getValueForKey:SAVECHANGEDSLIDERVALUE];
}
+ (void)cleansliderValue {
 [[FMDBKeyValueTable shareTable] deleteValueForKey:SAVECHANGEDSLIDERVALUE];
}
//弹幕位置 1全2底3上
+ (void)saveBarrageTextPosition:(NSString *)position {
    [[FMDBKeyValueTable shareTable] setValue:position forKeyPath:CHANGETEXTPOSITION];
}
+ (NSString *)textPosition {
    return [[FMDBKeyValueTable shareTable] getValueForKey:CHANGETEXTPOSITION];
}
+ (void)cleanTextPosition {
    [[FMDBKeyValueTable shareTable] deleteValueForKey:CHANGETEXTPOSITION];
}


//弹幕开关  BARRAEGISON
+ (void)saveBarrageIsOn:(NSString *)isOn {
    [[FMDBKeyValueTable shareTable] setValue:isOn forKey:BARRAEGISON];
}
+ (NSString *)getBarrageIsOn {
    return [[FMDBKeyValueTable shareTable] getValueForKey:BARRAEGISON];
}

//记录视频播放软解还是硬结
+ (void)saveMediaDecode:(NSString *)decode {
    [[FMDBKeyValueTable shareTable] setValue:decode forKeyPath:MEDIADECODE];

}
+ (BOOL)getMediaDecode {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:MEDIADECODE] boolValue];
}
+ (void)cleanMediaDecode {
    [[FMDBKeyValueTable shareTable] deleteValueForKey:MEDIADECODE];

}

//声音
+ (void)saveVoiceValue:(NSString *)value {
    [[FMDBKeyValueTable shareTable] setValue:value forKeyPath:VOICEVALUE];

}
+ (CGFloat)getVoiceValue {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:VOICEVALUE] floatValue];
}
+ (void)cleanVoiceValue {
    [[FMDBKeyValueTable shareTable] deleteValueForKey:VOICEVALUE];
}

//亮度
+ (void)saveBrightnessValue:(NSString *)value {
    [[FMDBKeyValueTable shareTable] setValue:value forKeyPath:BRIGHTNESSVALUE];

}
+ (CGFloat)getBrightness {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:BRIGHTNESSVALUE] floatValue];
}
+ (void)cleanBrightness {
    [[FMDBKeyValueTable shareTable] deleteValueForKey:BRIGHTNESSVALUE];

}

//礼物
+ (void)saveGiftSwith:(NSString *)aswith {
    [[FMDBKeyValueTable shareTable] setValue:aswith forKeyPath:GIFTSWITH];

}
+ (BOOL)getGiftSwith {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:GIFTSWITH] boolValue];
}
+ (void)cleanGiftSwith {
    [[FMDBKeyValueTable shareTable] deleteValueForKey:GIFTSWITH];

}

//屏幕手势
+ (void)saveScreenGesture:(NSString *)aswith {
    [[FMDBKeyValueTable shareTable] setValue:aswith forKeyPath:SCREENGESTURE];

}
+ (BOOL)getScreenGesture {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:SCREENGESTURE] boolValue];
}
+ (void)cleanScreenGesture {
    [[FMDBKeyValueTable shareTable] deleteValueForKey:SCREENGESTURE];

}


//后台声音播放
+ (void)saveVoiceBackground:(NSString *)aswith {
    [[FMDBKeyValueTable shareTable] setValue:aswith forKeyPath:VOICEBACKGROUND];

}
+ (BOOL)getVoiceBackground {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:VOICEBACKGROUND] boolValue];
}
+ (void)cleanVoiceBackground {
    [[FMDBKeyValueTable shareTable] deleteValueForKey:VOICEBACKGROUND];

}
//记录倒计时时间 REMINDTIME
+ (void)saveRemainTime:(NSString *)time {
    [[FMDBKeyValueTable shareTable] setValue:time forKeyPath:REMINDTIME];
}
+ (NSInteger)getRemainTime {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:REMINDTIME] integerValue];

}
+ (void)clearRemainTime {
    [[FMDBKeyValueTable shareTable] deleteValueForKey:REMINDTIME];

}
//记录定时器的index
+ (void)saveTimerIndex:(NSString *)index {
    [[FMDBKeyValueTable shareTable] setValue:index forKeyPath:CURRENTTIMERINDEX];

}
+ (NSInteger)getTimerIndex {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:CURRENTTIMERINDEX] integerValue];

}
+ (void)clearTimerIndex {
    [[FMDBKeyValueTable shareTable] deleteValueForKey:CURRENTTIMERINDEX];
}

//记录定时器开关
+ (void)saveTimerOpen:(NSString *)on {
    [[FMDBKeyValueTable shareTable] setValue:on forKeyPath:TIMEROPENOROFF];
}

+ (BOOL)getTimerOpen {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:TIMEROPENOROFF] integerValue];
}

+ (void)clearTimerOpen {
    [[FMDBKeyValueTable shareTable] deleteValueForKey:TIMEROPENOROFF];
}

//推流房间的清晰度记录
+ (void)savePushDefination:(NSString *)defination {
    [[FMDBKeyValueTable shareTable] setValue:defination forKeyPath:PUSHLIVEDEFINSTION];
}

+ (NSString *)getPushDefination {
    return [[FMDBKeyValueTable shareTable] getValueForKey:PUSHLIVEDEFINSTION];
}

+ (void)clearPushDefination {
    [[FMDBKeyValueTable shareTable] deleteValueForKey:PUSHLIVEDEFINSTION];
}


/*设置网络请求超时时间*/
+ (BOOL)setRequestTimeOut:(CGFloat)timeOut {
    return [[FMDBKeyValueTable shareTable] setValue:@(timeOut) forKey:kRequestTimeOut];
}

/*获取网络请求超时时间, 默认是6秒*/
+ (CGFloat)getRequestTimeOut {
    
    CGFloat timeOut = [[[FMDBKeyValueTable shareTable] getValueForKey:kRequestTimeOut] floatValue];
    
    if (timeOut <= 0 || timeOut > 41.0) {
        timeOut = 6.0;
    }
    
    return timeOut;
}
//+ (NSString *)delegate

//礼物效果开关
//+ (void)saveGiftIsOn:(NSString *)isOn {
//     [[FMDBKeyValueTable shareTable] setValue:isOn forKey:GIFIISON];
//}
//+ (NSString *)getGiftIsOn {
//     return [[FMDBKeyValueTable shareTable] getValueForKey:GIFIISON];
//}

+(BOOL)barrageListViewUseH5{
    return [[[FMDBKeyValueTable shareTable] getValueForKey:BARRAGELISTVIEWUSEH5] boolValue];
}

+(void)setBarrageListViewUseH5:(BOOL)useH5{
    [[FMDBKeyValueTable shareTable] setValue:@(useH5) forKey:BARRAGELISTVIEWUSEH5];
}

/**
 *  保存房间里独特的礼物数据
 */
+(void)saveCustomGiftTypeData:(NSDictionary *)giftsInfo{
    NSAssert([giftsInfo isKindOfClass:[NSDictionary class]], @"data must be NSDictionary or subClass");
    
    [[FMDBKeyValueTable shareTable] setDictionary:giftsInfo forKey:CustomGiftTypeList];
}
/**
 *  清除房间里独特的礼物数据
 */
+(void)clearCustomGiftTypeData{
    [[FMDBKeyValueTable shareTable] deleteValueForKey:CustomGiftTypeList];
}
/**
 *  获取房间内自定义的礼物
 *
 *  @return
 */
+(NSDictionary *)getCustomGiftTypeData{
    return [[FMDBKeyValueTable shareTable] getDictionaryForKey:CustomGiftTypeList];
}

/**
 *  保存当前播放的视屏地址的cdn厂家
 */
+(void)saveLog_player_cdnCompany:(NSString *)cdnCompany{
    [[FMDBKeyValueTable shareTable] setValue:cdnCompany forKey:@"cdnCompany"];
}

/**
 *  获取当前播放的视屏地址的cdn厂家
 */
+(NSString *)getLog_player_cdnCompany{
    return [[FMDBKeyValueTable shareTable] getValueForKey:@"cdnCompany"];
}

/**
 *  清除当前播放的视屏地址的cdn厂家
 */
+(void)clearLog_player_cdnCompany{
    [[FMDBKeyValueTable shareTable] deleteValueForKey:@"cdnCompany"];
}

/**
 *  保存当前播放的视屏地址的清晰度
 */
+(void)saveLog_player_definition:(NSString *)definition{
    [[FMDBKeyValueTable shareTable] setValue:definition forKey:@"definition"];
}

/**
 *  获取当前播放的视屏地址的清晰度
 */
+(NSString *)getLog_player_definition{
    return [[FMDBKeyValueTable shareTable] getValueForKey:@"definition"];
}
/**
 *  清除当前播放的视屏地址的清晰度
 */
+(void)clearLog_player_definition{
    [[FMDBKeyValueTable shareTable] deleteValueForKey:@"definition"];
}

/**
 *  保存当前播放的视屏地址的直播间所属分类
 */
+(void)saveLog_player_roomCategory:(NSString *)roomCategory{
    [[FMDBKeyValueTable shareTable] setValue:roomCategory forKey:@"roomCategory"];
}

/**
 *  获取当前播放的视屏地址的直播间所属分类
 */
+(NSString *)getLog_player_roomCategory{
    return [[FMDBKeyValueTable shareTable] getValueForKey:@"roomCategory"];
}

/**
 *  清除当前播放的视屏地址的直播间所属分类
 */
+(void)clearLog_player_roomCategory{
//    [[FMDBKeyValueTable shareTable] deleteValueForKey:@"roomCategory"];
    [[FMDBKeyValueTable shareTable] setValue:@"-1" forKey:@"roomCategory"];
}

/**
 *  保存设备唯一标识符
 *
 *  @param deviceIdentifier
 */
+(void)saveLog_deviceIdentifier:(NSString *)deviceIdentifier{
    [[FMDBKeyValueTable shareTable] setValue:deviceIdentifier forKey:@"deviceIdentifier"];
}

/**
 *  获取设备唯一标识符号
 *
 *  @return
 */
+(NSString *)getLog_deviceIdentifier{
    return [[FMDBKeyValueTable shareTable] getValueForKey:@"deviceIdentifier"];
}

/**
 *  清空设备唯一标识符
 */
+(void)clearLog_deviceIdentifier{
    [[FMDBKeyValueTable shareTable] deleteValueForKey:@"deviceIdentifier"];
}

/**
 *  保存当前所在的直播间ID
 *
 *  @param deviceIdentifier
 */
+(void)saveLog_roomID:(NSString *)roomID{
    [[FMDBKeyValueTable shareTable] setValue:roomID forKey:@"roomID"];
}

/**
 *  获取当前所在的直播间ID
 *
 *  @return
 */
+(NSString *)getLog_roomID{
    return [[FMDBKeyValueTable shareTable] getValueForKey:@"roomID"];
}

/**
 *  清空当前所在的直播间ID
 */
+(void)clearLog_roomID{
//    [[FMDBKeyValueTable shareTable] deleteValueForKey:@"roomID"];
    [[FMDBKeyValueTable shareTable] setValue:@"-1" forKey:@"roomID"];
}

/**
 *  保存当前屏幕状态
 *
 *  @param deviceIdentifier
 */
+(void)saveLog_interfaceOrientation:(NSString *)Orientation{
    [[FMDBKeyValueTable shareTable] setValue:Orientation forKey:@"Orientation"];
}

/**
 *  获取当前屏幕状态
 *
 *  @return
 */
+(NSString *)getLog_interfaceOrientation{
    return [[FMDBKeyValueTable shareTable] getValueForKey:@"Orientation"];
}

/**
 *  清空当前屏幕状态
 */
+(void)clearLog_interfaceOrientation{
    [[FMDBKeyValueTable shareTable] deleteValueForKey:@"Orientation"];
}

/**
 *  保存常用分类的数组
 *
 *  @param oftenUsedArray 常用分类的数组
 */
+ (void)saveOftenUsedCategoryArray:(NSArray *)oftenUsedArray {
    [[FMDBKeyValueTable shareTable] setArray:oftenUsedArray forKey:OftenUsedCategoryArray];
}

/**
 *  获取常用分类的数组
 *
 *  @return 常用分类的数组
 */
+ (NSArray *)getOftenUsedCategoryArray {
    return [[FMDBKeyValueTable shareTable] getArrayForKey:OftenUsedCategoryArray];
}

/**
 *  获取用户是否清空了常用分类列表
 *
 *  @return YES,用户清空了常用分类列表,那么即便常用分类没数据,也不从全部分类里取默认数据
 */
+ (BOOL)getUserClearOftenUsedCategoryArray {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:UserClearedOftenUsedCategoryArray] boolValue];
}

/**
 *  获取用户是否清空了常用分类列表
 *
 *  @return YES,用户清空了常用分类列表,那么即便常用分类没数据,也不从全部分类里取默认数据
 */
+ (void)setUserClearOftenUsedCategoryArray:(BOOL)clear {
    [[FMDBKeyValueTable shareTable] setValue:@(clear) forKey:UserClearedOftenUsedCategoryArray];
}


/**
 *  获取是否显示水印
 *
 *  @return YES显示,NO不显示
 */
+ (BOOL)getWatermarkFlag {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:ShowWaterMark] boolValue];
}

/**
 *  设置是否显示水印的标志
 *
 *  @flag YES显示,NO不显示
 */
+ (void)setWatermarkFlag:(BOOL)flag {
    [[FMDBKeyValueTable shareTable] setValue:@(flag) forKey:ShowWaterMark];
}

/**
 *  获取发弹幕是否需要手机
 *
 *  @return YES显示,NO不显示
 */
+ (BOOL)getNeedPhonenumber {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:NeedPhonenumber] boolValue];

}

/**
 *  设置发弹幕是否需要手机
 *
 *  @flag YES显示,NO不显示
 */
+ (void)setNeedPhonenumberFlag:(BOOL)flag {
    [[FMDBKeyValueTable shareTable] setValue:@(flag) forKey:NeedPhonenumber];

}

/**
 *  获取充值开关配置
 *
 *  @return YES需显示,NO不需要
 */
+ (BOOL)getPayEnable{

    return [[[FMDBKeyValueTable shareTable] getValueForKey:PayEnable] boolValue];
}


/**
 *  设置充值开关配置
 *
 *  @flag YES显示,NO不显示
 */
+ (void)setPayEnableFlag:(BOOL)flag{

   [[FMDBKeyValueTable shareTable] setValue:@(flag) forKey:PayEnable];

}


+ (BOOL)getIsPortaitForbidToOldVersionActivate {
    id resultValue = [[FMDBKeyValueTable shareTable] getValueForKey:AllowPortraitForOldVersion];
    if ([resultValue isKindOfClass:[NSString class]] && ((NSString *)resultValue).length == 0) {
        return NO;
    }
    else {
        return [resultValue boolValue];
    }
}

+ (BOOL)setPortraitAllowToOldVersion:(BOOL)flag {
    return [[FMDBKeyValueTable shareTable] setValue:@(flag) forKey:AllowPortraitForOldVersion];
}

/**
 *  设置推流状态的标志
 *
 *  @state 0 竖屏 1 横屏
 */
+ (void)savePushLiveState:(NSInteger)state {
    [[FMDBKeyValueTable shareTable] setValue:@(state) forKey:PushLiveState];
}

+ (NSInteger)getPushLiveState {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:PushLiveState] integerValue];
}

//+ (void)saveFirstOpenPushLiveState:(NSInteger)state {
//    [[FMDBKeyValueTable shareTable] setValue:@(state) forKey:FirstOpenPushLive];
//}

//+ (NSInteger)getFirstOpenPushLiveState {
//    return [[[FMDBKeyValueTable shareTable] getValueForKey:FirstOpenPushLive] integerValue];
//}

//设置启动视频是否观看过, 只在更新后设置为YES
+ (void)setLaunchVideoWatched:(BOOL)watched {
    [[FMDBKeyValueTable shareTable] setValue:@(watched) forKeyPath:kLaunchVideoWatched];
}

//启动视频是否看过, 如果看过就不再显示
+ (BOOL)launchVideoWatched {
    BOOL watched = [[[FMDBKeyValueTable shareTable] getValueForKey:kLaunchVideoWatched] boolValue];
    
    return watched;
}

+ (void)saveFirstOpenQM_APP:(NSInteger)state{
    
    if ([QMTool appVersionString].length > 0) {
        [[FMDBKeyValueTable shareTable] setValue:@(state) forKey:[QMTool appVersionString]];
    }
}


+ (NSInteger)getFirstOpenQM_APP{
    
    return [[[FMDBKeyValueTable shareTable] getValueForKey:[QMTool appVersionString]] integerValue];

}


+ (void)saveLastShareType:(NSString *)shareType{

    [[FMDBKeyValueTable shareTable] setValue:shareType forKey:kLastSharePlatform];

}
+ (NSString *)getLastShareType{
    
    return [[FMDBKeyValueTable shareTable] getValueForKey:kLastSharePlatform];

}


/**
 *  设置APP的审核状态
 *
 *  @param checking YES正在审核, NO不在审核
 */
+ (void)setCheckingStatus:(BOOL)checking {
    [[FMDBKeyValueTable shareTable] setValue:@(checking) forKey:NotChecking];
}

/**
 *  保存tab的选项
 *
 *  @param optionArray tab选项
 */
+ (void)saveTabOptionArray:(NSArray *)optionArray {
    [[FMDBKeyValueTable shareTable] setArray:optionArray forKey:TabOptionArray];
}

/**
 *  获取tab的选项
 *
 *  @return tab选项
 */
+ (NSArray *)getTabOptionArray {
    return [[FMDBKeyValueTable shareTable] getArrayForKey:TabOptionArray];
}

/**
 *  清空获取tab的选项
 *
 */
+ (void)clearTabOptionArray {
    [[FMDBKeyValueTable shareTable] deleteValueForKey:TabOptionArray];
}

/**
 *  保存最近一次显示游戏中心红点的提示的时间
 *
 */
+ (void)saveLastShowGameCenterTipTime:(NSString *)timeString {
    [[FMDBKeyValueTable shareTable] setValue:timeString forKey:LastShowGameCenterTipTime];
}

/**
 *  获取最近一次显示游戏中心红点的提示的时间
 *
 */
+ (NSString *)getLastShowGameCenterTipTime {
    NSString *lastTimeString = [[FMDBKeyValueTable shareTable] getValueForKey:LastShowGameCenterTipTime];
    return lastTimeString;
}

/**
 *  获取游戏中心提示文案
 *
 *  @return 保存的提示文案
 */
+ (NSString *)getGameCenterTipText {
    NSString *tipText = [[FMDBKeyValueTable shareTable] getValueForKey:KGameCenterTipText];
    return tipText;
}

/**
 *  保存游戏中心提示文案
 *
 *  @tipString 从网络获取的提示文案
 */
+ (void)saveGameCenterTipText:(NSString *)tipText {
    [[FMDBKeyValueTable shareTable] setValue:tipText forKey:KGameCenterTipText];
}

/**
 *  保存是否显示游戏中心的开关
 *
 *  @return YES显示游戏中心,NO不显示游戏中心
 */
+ (BOOL)showGameCenterFlag {
    id value = [[FMDBKeyValueTable shareTable] getValueForKey:KShowGame];
    BOOL show  = [value boolValue];
    return show;
}

/**
 *  保存是否显示游戏中心的开关
 *
 *  @param flag YES显示游戏,NO不显示游戏中心
 */
+ (void)setShowGameCenterFlag:(BOOL)flag {
    [[FMDBKeyValueTable shareTable] setValue:@(flag) forKey:KShowGame];
}

/**
 *  保存发送网络请求时所在的页面
 *
 *  @param refer 页面名字
 */
+ (void)saveQueryLog_refer:(NSString *)refer {
    [[FMDBKeyValueTable shareTable] setValue:refer forKey:kQueryLogRefer];
}

/**
 *  清除发送网络请求时所在的页面
 */
+ (void)clearQueryLog_refer {
    [[FMDBKeyValueTable shareTable] deleteValueForKey:kQueryLogRefer];
}

/**
 *  获取发送网络请求时所在的页面
 *
 *  @return 发送网络请求时所在的页面
 */
+ (NSString *)getQueryLog_refer {
    return [[FMDBKeyValueTable shareTable] getValueForKey:kQueryLogRefer];
}

/**
 *   保存md5值
 *
 */
+ (void)saveMD5:(NSString *)md5String {
    [[FMDBKeyValueTable shareTable] setValue:md5String forKey:kMD5value];
}
/**
 *   读取MD5
 *
 */
+ (NSString *)getMD5 {
    return [[FMDBKeyValueTable shareTable] getValueForKey:kMD5value];
}
/**
 *   保存配置文案
 *
 */
+ (void)saveDoc_contentArr:(NSArray *)arr{
     [[FMDBKeyValueTable shareTable] setValue:[[FMDBKeyValueTable shareTable] arrayToJsonString:arr] forKey:kMDoc_contentArr];
}
/**
 *   读取配置文案
 *
 */
+ (NSString *)getDoc_contentWithKey:(NSString *)key {
    if ([key isKindOfClass:[NSString class]] == NO) {
        NSLog(@"%s:key必须是字符串", __func__);
        return @"未知信息";
    }
    
    NSString *targetContet = nil;
    
    NSArray *docFromServer = [[FMDBKeyValueTable shareTable] getArrayForKey:kMDoc_contentArr];
    
    if (docFromServer.count == 0) {
        docFromServer = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"default_doc" ofType:@"plist"]];
    }
    
    if ([docFromServer isKindOfClass:[NSArray class]] && docFromServer.count > 0) {
        for (NSDictionary *dict in docFromServer) {
            if ([dict containsObjectForKey:@"doc_name"]) {
                NSString *nameStr = [dict getStringForKey:@"doc_name"];
                if ([nameStr isEqualToString:key]) {
                    targetContet = [dict getStringForKey:@"doc_content"];
                    break;
                }
            }
        }
    }
    else {
        targetContet = @"未知信息";
    }
    
    return targetContet;
}


#pragma mark ----- private

+ (NSDictionary *)configDictionary {
    NSString *configPath = [[NSBundle mainBundle] pathForResource:kLiveParametersPlistName ofType:@"plist"];
    return [[NSDictionary alloc] initWithContentsOfFile:configPath];
}

+ (NSArray *)readLandscapeResolutionDataSource {
    NSMutableArray *outputArray = [[NSMutableArray alloc] init];
    NSArray *arr = self.configDictionary[kLandscapeResolutionKey];
    for (NSDictionary *dic in arr) {
        ResolutionDataModel *data = [[ResolutionDataModel alloc] init];
        [data setValuesForKeysWithDictionary:dic];
        [outputArray addObject:data];
    }
    return outputArray;
}

+ (NSArray *)readPortraitScapeResolutionDataSource {
    NSMutableArray *outputArray = [[NSMutableArray alloc] init];
    NSArray *arr = self.configDictionary[kPortraitResolutionKey];
    for (NSDictionary *dic in arr) {
        ResolutionDataModel *data = [[ResolutionDataModel alloc] init];
        [data setValuesForKeysWithDictionary:dic];
        
        [outputArray addObject:data];
    }
    return outputArray;
}


+ (void)saveObserveNotificationState:(NSInteger )state {
    [[FMDBKeyValueTable shareTable] setValue:@(state) forKey:KObserveNotificationState];
}

+ (NSInteger)getObserveNotificationSate {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:KObserveNotificationState] integerValue];
}

+ (void)saveLandscapeListCategoryModel:(LiveCategoryModel *)liveCategoryModel {
    NSString *modelStr = [liveCategoryModel modelToJSONString];
    [[FMDBKeyValueTable shareTable] setValue:modelStr forKey:PushLiveLandscapeModelKey];
}
+ (LiveCategoryModel *)getLandscapeLiveCategoryModel {
    NSString *modelStr = [[FMDBKeyValueTable shareTable] getValueForKey:PushLiveLandscapeModelKey];
    LiveCategoryModel *categoryModel = [LiveCategoryModel modelWithJSON:modelStr];
    if (categoryModel == nil || ![categoryModel isKindOfClass:[LiveCategoryModel class]]) {
        categoryModel = [[LiveCategoryModel alloc] init];
    }
    return categoryModel;
}
+ (void)savePorstraitListCategoryModel:(LiveCategoryModel *)liveCategoryModel {
    NSString *modelStr = [liveCategoryModel modelToJSONString];
    [[FMDBKeyValueTable shareTable] setValue:modelStr forKey:PushLivePorstraitModelKey];
}
+ (LiveCategoryModel *)getPorstraitLiveCategoryModel {
    NSString *modelStr = [[FMDBKeyValueTable shareTable] getValueForKey:PushLivePorstraitModelKey];
    LiveCategoryModel *categoryModel = [LiveCategoryModel modelWithJSON:modelStr];
    if (categoryModel == nil || ![categoryModel isKindOfClass:[LiveCategoryModel class]]) {
        categoryModel = [[LiveCategoryModel alloc] init];
    }
    return categoryModel;
}

+ (void)savePushLiveVideoState:(VideoSettingPosition)state {
    [[FMDBKeyValueTable shareTable] setValue:@(state) forKey:PushLiveVideoState];
}

+ (VideoSettingPosition)getPushLiveVideoState {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:PushLiveVideoState] integerValue];
}

+ (void)savePushLiveMagicState:(MagicSettingType)state {
    [[FMDBKeyValueTable shareTable] setValue:@(state) forKey:PushLiveMagicState];
}

+ (MagicSettingType)getPushLiveMagicState {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:PushLiveMagicState] integerValue];
}
/**
 保存镜像的开关,默认关
 */
+ (void)savePushMirrorState:(BOOL)state {
    [[FMDBKeyValueTable shareTable] setValue:@(state) forKey:PushLiveMirrorState];
}

+ (BOOL)getPushMirrorState {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:PushLiveMirrorState] boolValue];
}

/**
 保存镜像的开关,默认关
 */
+ (void)savePushFlashState:(BOOL)state {
    [[FMDBKeyValueTable shareTable] setValue:@(state) forKey:PushLiveFlightState];
}

+ (BOOL)getPushFlashState {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:PushLiveFlightState] boolValue];
}


+ (void)saveSecretKeyModel:(SecretKeyModel *)secretKeyModel {
    NSString *modelStr = [secretKeyModel modelToJSONString];
    [[FMDBKeyValueTable shareTable] setValue:modelStr forKey:PushLiveSecretModelKey];
}
+ (SecretKeyModel *)getSecretKeyModel {
    NSString *modelStr = [[FMDBKeyValueTable shareTable] getValueForKey:PushLiveSecretModelKey];
    SecretKeyModel *secretKeyModel = [SecretKeyModel modelWithJSON:modelStr];
    if (secretKeyModel == nil || ![secretKeyModel isKindOfClass:[SecretKeyModel class]]) {
        secretKeyModel = [[SecretKeyModel alloc] init];
    }
    return secretKeyModel;
}

//+ (void)savePusherLiveRoomModel:(PusherLiveRoomModel *)pusherLiveRoomModel {
//    NSString *modelStr = [pusherLiveRoomModel modelToJSONString];
//    [[FMDBKeyValueTable shareTable] setValue:modelStr forKey:PusherLiveRoomModelKey];
//}
//
//+ (PusherLiveRoomModel *)getPusherLiveRoomModel {
//    NSString *modelStr = [[FMDBKeyValueTable shareTable] getValueForKey:PusherLiveRoomModelKey];
//    PusherLiveRoomModel *pusherLiveRoomModel = [PusherLiveRoomModel modelWithJSON:modelStr];
//    if (pusherLiveRoomModel == nil || ![pusherLiveRoomModel isKindOfClass:[PusherLiveRoomModel class]]) {
//        pusherLiveRoomModel = [[PusherLiveRoomModel alloc] init];
//    }
//    return pusherLiveRoomModel;
//}

+ (void)savePusherLiveRoomArchiveModel:(PusherLiveRoomArchive *)pusherLiveRoomArchive {
    NSString *modelStr = [pusherLiveRoomArchive modelToJSONString];
    [[FMDBKeyValueTable shareTable] setValue:modelStr forKey:PusherLiveRoomArchiveKey];
}

+ (PusherLiveRoomArchive *)getPusherLiveRoomArchiveModel {
    NSString *modelStr = [[FMDBKeyValueTable shareTable] getValueForKey:PusherLiveRoomArchiveKey];
    PusherLiveRoomArchive *pusherLiveRoomArchive = [PusherLiveRoomArchive modelWithJSON:modelStr];
    if (pusherLiveRoomArchive == nil || ![pusherLiveRoomArchive isKindOfClass:[PusherLiveRoomArchive class]]) {
        pusherLiveRoomArchive = [[PusherLiveRoomArchive alloc] init];
    }
    return pusherLiveRoomArchive;
}

+ (void)savePusherLiveRoomArchiveModelSensitiveUserID:(PusherLiveRoomArchive *)pusherLiveRoomArchive {
    NSString *modelStr = [pusherLiveRoomArchive modelToJSONString];
    NSDictionary *pusherRoomArchiveDict = [[FMDBKeyValueTable shareTable] getDictionaryForKey:PusherLiveRoomArchiveByUserIDKey];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:pusherRoomArchiveDict];
    if (kZXUserInfo.uid == 0) return;
    [mutableDict setValue:modelStr forKey:[NSString stringWithFormat:@"%zd",kZXUserInfo.uid]];
    [[FMDBKeyValueTable shareTable] setDictionary:mutableDict forKey:PusherLiveRoomArchiveByUserIDKey];
}

+ (PusherLiveRoomArchive *)getPusherLiveRoomArchiveModelSensitiveUserID {
    NSDictionary *pusherRoomArchiveDict = [[FMDBKeyValueTable shareTable] getDictionaryForKey:PusherLiveRoomArchiveByUserIDKey];
    if (kZXUserInfo.uid == 0) {
        return [[PusherLiveRoomArchive alloc] init];
    }
    NSString *modelStr = pusherRoomArchiveDict[[NSString stringWithFormat:@"%zd",kZXUserInfo.uid]];
    if (modelStr == nil || [modelStr isEqualToString:@""]) {
        return [[PusherLiveRoomArchive alloc] init];
    }
    PusherLiveRoomArchive *pusherLiveRoomArchive = [PusherLiveRoomArchive modelWithJSON:modelStr];
    return pusherLiveRoomArchive;
}

+ (void)saveLandscapeCategoryList:(NSArray *)categoryArray {
    NSMutableArray *saveArray = @[].mutableCopy;
    for (LiveCategoryModel *categoryModel in categoryArray) {
        NSString *jsonStr = [categoryModel modelToJSONString];
        [saveArray addObject:jsonStr];
    }
    
    [[FMDBKeyValueTable shareTable] setArray:saveArray forKey:PushLiveLandscapeCategoryKey];
}

+ (NSArray *)getLandscapeCategoryList {
    NSMutableArray *resultArray = @[].mutableCopy;
    NSArray *oldArray = [[FMDBKeyValueTable shareTable] getArrayForKey:PushLiveLandscapeCategoryKey];
    for (NSString *categoryJsonStr in oldArray) {
        LiveCategoryModel *categoryModel = [LiveCategoryModel modelWithJSON:categoryJsonStr];
        [resultArray addObject:categoryModel];
    }
    return resultArray;
}


+ (void)saveUserHaschangeColumn:(BOOL)isChange{

    [[FMDBKeyValueTable shareTable] setValue:@(isChange) forKey:kChangeColumnFlag];
}

+ (BOOL)getUserHaschangeColumn{

     return [[[FMDBKeyValueTable shareTable] getValueForKey:kChangeColumnFlag] boolValue];

}


+ (void)saveAppVersion:(NSString *)versionStr {
    if ([QMTool appVersionString].length > 0) {
        [[FMDBKeyValueTable shareTable] setValue:versionStr forKey:kSavedAppVersion];
    }
}

+ (NSString *)getSavedAppVersion {
    return [[FMDBKeyValueTable shareTable] getValueForKey:kSavedAppVersion];
}

/*
 保存横幅配置列表
 */
+ (BOOL)saveBannerConfigList:(NSArray *)configList {
    
    return [[FMDBKeyValueTable shareTable] setArray:configList forKey:kBannerConfigList];
}

/*
 获取横幅配置列表
 */
+ (NSArray *)getBannerConfigList {
    NSArray *configList = [[FMDBKeyValueTable shareTable] getArrayForKey:kBannerConfigList];
    
    if ([configList isKindOfClass:[NSArray class]]) {
        return configList;
    } else {
        return [NSArray array];
    }
}

/*
 保存礼物配置信息
 */
+ (BOOL)saveGiftConfigList:(NSArray *)configList {
    return [[FMDBKeyValueTable shareTable] setArray:configList forKey:kGiftConfigList];
}

/*
 获取礼物配置列表
 */
+ (NSArray *)getGiftConfigList {
    NSArray *configList = [[FMDBKeyValueTable shareTable] getArrayForKey:kGiftConfigList];
    
    if ([configList isKindOfClass:[NSArray class]]) {
        return configList;
    } else {
        return [NSArray array];
    }
}

/*
 保存抢过的宝箱的ID, 如果抢过了, 后面再进入房间收到这个宝箱就不要显示这个宝箱
 */
+ (BOOL)addRobedChestID:(NSInteger)chestID {
    NSDictionary *oldIds = [[FMDBKeyValueTable shareTable] getDictionaryForKey:kRobedChestIDs];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:oldIds];
    NSArray *oldArray = [oldIds allValues];
    if (![oldArray containsObject:@(chestID)]) {//chestID是value, 时间戳是key
        [tempDict setValue:@(chestID) forKey:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]]];
    }
    
    return [[FMDBKeyValueTable shareTable] setDictionary:tempDict forKey:kRobedChestIDs];
}

//清空之前保存的抢过的宝箱的ID
+ (BOOL)cleanRobedChestIDs {
    NSDictionary *oldIds = [[FMDBKeyValueTable shareTable] getDictionaryForKey:kRobedChestIDs];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:oldIds];
    NSArray *keys = [oldIds allKeys];
    for (NSString *key in keys) {
        NSTimeInterval interval = [key doubleValue];
        NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
        double timeInterval = nowInterval - interval;
        if (timeInterval > 1*60*60) {//超过一小时的移除
            [tempDict removeObjectForKey:key];
        }
    }
    
    return [[FMDBKeyValueTable shareTable] setDictionary:tempDict forKey:kRobedChestIDs];
}

//之前保存的抢过的宝箱的ID数组
+ (NSArray *)robedChestIDs {
    NSDictionary *oldIds = [[FMDBKeyValueTable shareTable] getDictionaryForKey:kRobedChestIDs];
    NSArray *oldArray = [oldIds allValues];
    
    if ([oldArray isKindOfClass:[NSArray class]]) {
        return oldArray;
    } else {
        return [NSArray array];
    }
}

#pragma mark - 引导页

////获取用户是否展示过版本引导页
//+ (BOOL)newVersionGurided {
//    return [[[FMDBKeyValueTable shareTable] getValueForKey:[QMTool appVersionString]] integerValue];
//}
//
////设置用户是否展示过版本引导页
//+ (void)setNewVersionGurided:(BOOL)isSaved {
//    if ([QMTool appVersionString].length > 0) {
//        [[FMDBKeyValueTable shareTable] setValue:@(isSaved) forKey:[QMTool appVersionString]];
//    }
//}


//获取用户是否展示过全屏播放引导页
+ (BOOL)fullScreenGurided {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:kFullScreenGurided] integerValue];
}

//设置用户是否展示过全屏播放引导页
+ (void)setFullScreenGurided:(BOOL)isSaved {
    [[FMDBKeyValueTable shareTable] setValue:@(isSaved) forKey:kFullScreenGurided];
}

//获取用户是否展示过 摇一摇
+ (BOOL)fullScreenShakeGuide {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:kFullScreenShake] integerValue];
}

//设置 摇一摇
+ (void)setFullScreenShakeGuide:(BOOL)isSaved {
    [[FMDBKeyValueTable shareTable] setValue:@(isSaved) forKey:kFullScreenShake];
}


//获取用户是否展示过截屏引导页
+ (BOOL)screenshotsShareGuride {
    return [[[FMDBKeyValueTable shareTable] getValueForKey:kScreenshotsShare] integerValue];
}

//设置用户是否展示过截屏引导页
+ (void)setScreenshotsShareGuride:(BOOL)isSaved {
    [[FMDBKeyValueTable shareTable] setValue:@(isSaved) forKey:kScreenshotsShare];
}


@end
