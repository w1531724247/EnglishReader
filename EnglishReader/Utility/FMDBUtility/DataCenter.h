//
//  DataCenter.h
//  Test
//
//  Created by QMTV on 16/5/18.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PurchasePersistenceModel.h"


@class PurchaseActionModel;
@class LiveCategoryModel;
@class SecretKeyModel;
@class PusherLiveRoomModel;
@class PusherLiveRoomArchive;
typedef NS_ENUM(NSInteger, VideoSettingPosition) {
    VideoSettingPositionFront         = 0, //前置摄像头
    VideoSettingPositionBack          = 1, //后置摄像头
};

typedef NS_ENUM(NSInteger, MagicSettingType) {
    MagicSettingTypeOpen         = 0,   //美颜开启
    MagicSettingTypeClosed       = 1,   //美颜关闭
};

@interface DataCenter : NSObject

+ (void)setSid:(NSString *)sid;
+ (NSString *)getSid;

+ (void)setToken:(NSString *)token;
+ (NSString *)getToken;


+(void)setIsAdmin:(BOOL)isAdmin;
+(BOOL)getIsAdmin;

+(void)setIsAnchor:(BOOL)isAnchor;
+(BOOL)getIsAnchor;


+ (void)updateUserIcon:(NSString *)usericon;

+ (BOOL)getUserE_MailInfo;

+ (BOOL)getUserTelNumInfo;

+ (void)verifyE_Mail:(NSString *)usereamil;

+ (void)setTelNum:(NSString *)usertelnum;




+ (void)saveUserSearchRecord:(NSString *)RecordStr;

+ (NSArray *)getUserSearchRecord;

+ (NSArray *)deleteSearchRecord:(NSInteger)index;

+ (BOOL)deleteAllSearchRecord;

+ (NSString *)getCurrentDeviceModel;

+ (void)saveGiftTypeData:(NSDictionary *)data;

+ (NSDictionary *)getGitfType;

+ (void)setRecommendPageLastRefreshDate;
+ (BOOL)recommendPageNeedRefresh;

+ (void)setAllLivePageLastRefreshDate;
+ (BOOL)allLivePageNeedRefresh;

+ (void)setColumnPageLastRefreshDate:(NSString *)slugString;
+ (BOOL)columnsPageNeedRefresh:(NSString *)slugString;


+ (void)setColumnDetailPageLastRefreshDate;
+ (BOOL)columnDetailNeedRefresh;
+ (void)setFindPageLastRefreshDate;
+ (BOOL)findPageNeedRefresh;
+ (void)setAttentionPageLastRefreshDate;
+ (BOOL)attentionPageNeedRefresh;
+ (NSString *)getDeviceToken;
+ (void)saveDeviceToken:(NSString *)deviceToken;
+ (BOOL)isAllowedNotification;

+ (void)savePurchasePersistenceModel:(PurchasePersistenceModel *)purchasePersistenceModel;
+ (NSArray *)getPurchasePersitenceMutableArrayByState:(PurchaseState)purchaseStae;
+ (void)changePurchasePersitenceModelStateForOrderID:(NSInteger)orderID;
+ (BOOL)isNeedLogout;

+ (void)savePurchaseActionModel:(PurchaseActionModel *)purchaseActionModel;
+ (PurchaseActionModel *)getPurchaseActionModel;
+ (void)changePurchaseActionState:(BOOL)state;
+ (BOOL)purchaseActionStatus;

+ (void)setLogoutFlag:(BOOL)flag;
+ (void)setPurchaseActionFlag:(BOOL)flag;
+ (BOOL)purchaseActionFlag;

//弹幕透明度
+ (void)saveChangedTextOpacity:(NSString *)opacity;
+ (NSString *)textOpacity;
+ (void)cleanTextOpacity;
//文字大小
+ (void)saveChangedTextFont:(NSString *)font;
+ (NSString *)textFont;
+ (void)cleanChangedTextFont;
//文字透明度
+ (void)saveChangedSliderValue:(NSString *)value;
+ (NSString *)sliderValue;
+ (void)cleansliderValue;

//弹幕位置 //0-全屏 1-上半屏 2-下半屏 3-隐藏弹幕
+ (void)saveBarrageTextPosition:(NSString *)position;
+ (NSString *)textPosition;
+ (void)cleanTextPosition;

//0 -关 1-开
//弹幕开关
+ (void)saveBarrageIsOn:(NSString *)isOn;
+ (NSString *)getBarrageIsOn;

//记录视频播放软解还是硬结 0 - 是开启 1 -关闭
+ (void)saveMediaDecode:(NSString *)decode;
+ (BOOL)getMediaDecode;
+ (void)cleanMediaDecode;

//声音
+ (void)saveVoiceValue:(NSString *)value;
+ (CGFloat)getVoiceValue;
+ (void)cleanVoiceValue;

//亮度
+ (void)saveBrightnessValue:(NSString *)value;
+ (CGFloat)getBrightness;
+ (void)cleanBrightness;

//礼物 0 - 开 1-是关
+ (void)saveGiftSwith:(NSString *)aswith;
+ (BOOL)getGiftSwith;
+ (void)cleanGiftSwith;

//屏幕手势 1-开 0-关
+ (void)saveScreenGesture:(NSString *)aswith;
+ (BOOL)getScreenGesture;
+ (void)cleanScreenGesture;


//后台声音播放
+ (void)saveVoiceBackground:(NSString *)aswith;
+ (BOOL)getVoiceBackground;
+ (void)cleanVoiceBackground;

//记录倒计时时间
+ (void)saveRemainTime:(NSString *)time;
+ (NSInteger)getRemainTime;
+ (void)clearRemainTime;

//记录定时器的index
+ (void)saveTimerIndex:(NSString *)index;
+ (NSInteger)getTimerIndex;
+ (void)clearTimerIndex;

//记录定时器开关
+ (void)saveTimerOpen:(NSString *)on;
+ (BOOL)getTimerOpen;
+ (void)clearTimerOpen;

//推流房间的清晰度记录
+ (void)savePushDefination:(NSString *)defination;
+ (NSString *)getPushDefination;
+ (void)clearPushDefination;



+(BOOL)barrageListViewUseH5;
+(void)setBarrageListViewUseH5:(BOOL)useH5;
/**
 *  保存房间里独特的礼物数据
 */
+(void)saveCustomGiftTypeData:(NSDictionary *)giftsInfo;
/**
 *  清除房间里独特的礼物数据
 */
+(void)clearCustomGiftTypeData;
/**
 *  获取房间内自定义的礼物
 *
 *  @return
 */
+(NSDictionary *)getCustomGiftTypeData;

/**
 *  保存当前播放的视屏地址的cdn厂家
 */
+(void)saveLog_player_cdnCompany:(NSString *)cdnCompany;

/**
 *  获取当前播放的视屏地址的cdn厂家
 */
+(NSString *)getLog_player_cdnCompany;
/**
 *  清除当前播放的视屏地址的cdn厂家
 */
+(void)clearLog_player_cdnCompany;

/**
 *  保存当前播放的视屏地址的清晰度
 */
+(void)saveLog_player_definition:(NSString *)definition;

/**
 *  获取当前播放的视屏地址的清晰度
 */
+(NSString *)getLog_player_definition;
/**
 *  清除当前播放的视屏地址的清晰度
 */
+(void)clearLog_player_definition;

/**
 *  保存当前播放的视屏地址的直播间所属分类
 */
+(void)saveLog_player_roomCategory:(NSString *)roomCategory;

/**
 *  获取当前播放的视屏地址的直播间所属分类
 */
+(NSString *)getLog_player_roomCategory;
/**
 *  清除当前播放的视屏地址的直播间所属分类
 */
+(void)clearLog_player_roomCategory;

/**
 *  保存设备唯一标识符
 *
 *  @param deviceIdentifier
 */
+(void)saveLog_deviceIdentifier:(NSString *)deviceIdentifier;

/**
 *  获取设备唯一标识符号
 *
 *  @return
 */
+(NSString *)getLog_deviceIdentifier;

/**
 *  清空设备唯一标识符
 */
+(void)clearLog_deviceIdentifier;

/**
 *  保存当前所在的直播间ID
 *
 *  @param deviceIdentifier
 */
+(void)saveLog_roomID:(NSString *)roomID;

/**
 *  获取当前所在的直播间ID
 *
 *  @return
 */
+(NSString *)getLog_roomID;

/**
 *  清空当前所在的直播间ID
 */
+(void)clearLog_roomID;

/**
 *  保存当前屏幕状态
 *
 *  @param deviceIdentifier
 */
+(void)saveLog_interfaceOrientation:(NSString *)Orientation;

/**
 *  获取当前屏幕状态
 *
 *  @return
 */
+(NSString *)getLog_interfaceOrientation;

/**
 *  清空当前屏幕状态
 */
+(void)clearLog_interfaceOrientation;

/**
 *  保存常用分类的数组
 *
 *  @param oftenUsedArray 常用分类的数组
 */
+ (void)saveOftenUsedCategoryArray:(NSArray *)oftenUsedArray;

/**
 *  获取常用分类的数组
 *
 *  @return 常用分类的数组
 */
+ (NSArray *)getOftenUsedCategoryArray;

/**
 *  获取用户是否清空了常用分类列表
 *
 *  @return YES,用户清空了常用分类列表,那么即便常用分类没数据,也不从全部分类里取默认数据
 */
+ (BOOL)getUserClearOftenUsedCategoryArray;

/**
 *  获取用户是否清空了常用分类列表
 *
 *  @return YES,用户清空了常用分类列表,那么即便常用分类没数据,也不从全部分类里取默认数据
 */
+ (void)setUserClearOftenUsedCategoryArray:(BOOL)clear;

/**
 *  获取是否显示水印
 *
 *  @return YES显示,NO不显示
 */
+ (BOOL)getWatermarkFlag;

/**
 *  设置是否显示水印的标志
 *
 *  @flag YES显示,NO不显示
 */
+ (void)setWatermarkFlag:(BOOL)flag;

/**
 *  获取发弹幕是否需要手机
 *
 *  @return YES需要,NO不需要
 */
+ (BOOL)getNeedPhonenumber;

/**
 *  设置发弹幕是否需要手机
 *
 *  @flag YES需要,NO不需要
 */
+ (void)setNeedPhonenumberFlag:(BOOL)flag;

/**
 *  获取充值开关配置
 *
 *  @return YES需显示,NO不需要
 */
+ (BOOL)getPayEnable;


/**
 *  设置充值开关配置
 *
 *  @flag YES显示,NO不显示
 */
+ (void)setPayEnableFlag:(BOOL)flag;


/**
 * 获取是否允许旧版观看竖屏直播
 */
+ (BOOL)getIsPortaitForbidToOldVersionActivate;

/**
 * 设置是否允许旧版观看竖屏直播
 */
+ (BOOL)setPortraitAllowToOldVersion:(BOOL)flag;

/**
 *  设置推流状态的标志
 *
 *  @state 0 默认 1 横屏 2竖屏
 */
+ (void)savePushLiveState:(NSInteger)state;
/**
 *  获取推流状态的标志
 *
 *  @state 0 默认 1 横屏 2竖屏
 */
+ (NSInteger)getPushLiveState;

///**
// *  保存用户是否初次进入开播设置界面
// *
// *  @param state 1:进入过 0:未进入过
// */
//+ (void)saveFirstOpenPushLiveState:(NSInteger)state;
///**
// *  获取用户是否进入过开播设置界面标识
// *
// *  @return 0:未进入过 1:进入过
// */
//+ (NSInteger)getFirstOpenPushLiveState;


/**
 *  获取APP的审核状态
 *
 *  @return YES正在审核,NO不在审核
 */
+ (BOOL)getCheckingState;

/**
 *  设置APP的审核状态
 *
 *  @param checking YES正在审核, NO不在审核
 */
+ (void)setCheckingStatus:(BOOL)checking;

/**
 *  保存tab的选项
 *
 *  @param optionArray tab选项
 */
+ (void)saveTabOptionArray:(NSArray *)optionArray;

/**
 *  获取tab的选项
 *
 *  @return tab选项
 */
+ (NSArray *)getTabOptionArray;

/**
 *  清空获取tab的选项
 *
 */
+ (void)clearTabOptionArray;

/**
 *  保存最近一次显示游戏中心红点的提示的时间
 *
 */
+ (void)saveLastShowGameCenterTipTime:(NSString *)timeString;

/**
 *  获取最近一次显示游戏中心红点的提示的时间
 *
 */
+ (NSString *)getLastShowGameCenterTipTime;

+ (NSArray *)readLandscapeResolutionDataSource;

+ (NSArray *)readPortraitScapeResolutionDataSource;

/**
 *  保存上次选择的分享平台
 *
 *  @param shareType 分享平台
 */
+ (void)saveLastShareType:(NSString *)shareType;

/**
 *  获得上次选择的分享平台
 *
 *  @return 分享平台
 */
+ (NSString *)getLastShareType;
/**
 *  设置和获取是否在推流模块，如果在就不接受推送通知
 *
 *  @return 1 不监听 0 监听
 */
+ (void)saveObserveNotificationState:(NSInteger )state;
+ (NSInteger)getObserveNotificationSate;

/**
 *  获取游戏中心提示文案
 *
 *  @return 保存的提示文案
 */
+ (NSString *)getGameCenterTipText;

/**
 *  保存游戏中心提示文案
 *
 *  @tipText 从网络获取的提示文案
 */
+ (void)saveGameCenterTipText:(NSString *)tipText;

/**
 *  保存是否显示游戏中心的开关
 *
 *  @return YES显示游戏中心,NO不显示游戏中心
 */
+ (BOOL)showGameCenterFlag;

/**
 *  保存是否显示游戏中心的开关
 *
 *  @param flag YES显示游戏,NO不显示游戏中心
 */
+ (void)setShowGameCenterFlag:(BOOL)flag;

+ (void)saveLandscapeListCategoryModel:(LiveCategoryModel *)liveCategoryModel;
+ (LiveCategoryModel *)getLandscapeLiveCategoryModel;
+ (void)savePorstraitListCategoryModel:(LiveCategoryModel *)liveCategoryModel;
+ (LiveCategoryModel *)getPorstraitLiveCategoryModel;

/**
 *  保存开播设置摄像头状态
 *
 *  @param state VideoSettingPositionFront:前置摄像头 VideoSettingPositionBack:后置摄像头
 */
+ (void)savePushLiveVideoState:(VideoSettingPosition)state;

+ (VideoSettingPosition)getPushLiveVideoState;
/**
 *  保存开播设置页面美颜状态
 *
 *  @param state MagicSettingTypeOpen:开启 MagicSettingTypeClosed:关闭
 */
+ (void)savePushLiveMagicState:(MagicSettingType)state;

+ (MagicSettingType)getPushLiveMagicState;

/**
 保存镜像的开关,默认关
 */
+ (void)savePushMirrorState:(BOOL)state;

+ (BOOL)getPushMirrorState;
/**
 保存闪光灯的开关,默认关
 */
+ (void)savePushFlashState:(BOOL)state;
+ (BOOL)getPushFlashState;


/**
 *  保存发送网络请求时所在的页面
 *
 *  @param refer 页面名字
 */
+ (void)saveQueryLog_refer:(NSString *)refer;

/**
 *  清除发送网络请求时所在的页面
 */
+ (void)clearQueryLog_refer;

/**
 *  获取发送网络请求时所在的页面
 *
 *  @return 发送网络请求时所在的页面
 */
+ (NSString *)getQueryLog_refer;

+ (void)saveSecretKeyModel:(SecretKeyModel *)secretKeyModel;
+ (SecretKeyModel *)getSecretKeyModel;


/**
 *   保存md5值
 *
  */
+ (void)saveMD5:(NSString *)md5String;
/**
 *   读取MD5
 *
 */
+ (NSString *)getMD5;

/**
 *   保存配置文案
 *
 */
+ (void)saveDoc_contentArr:(NSArray *)arr;
/**
 *   读取配置文案
 *
 */
+ (NSString *)getDoc_contentWithKey:(NSString *)key;

//+ (void)savePusherLiveRoomModel:(PusherLiveRoomModel *)pusherLiveRoomModel;
//+ (PusherLiveRoomModel *)getPusherLiveRoomModel;
//保存开播设置页面 获取房间
+ (void)savePusherLiveRoomArchiveModel:(PusherLiveRoomArchive *)pusherLiveRoomArchive;
+ (PusherLiveRoomArchive *)getPusherLiveRoomArchiveModel;

+ (void)savePusherLiveRoomArchiveModelSensitiveUserID:(PusherLiveRoomArchive *)pusherLiveRoomArchive;
+ (PusherLiveRoomArchive *)getPusherLiveRoomArchiveModelSensitiveUserID;

// 缓存开播设置页面列表数据
+ (void)saveLandscapeCategoryList:(NSArray *)categoryArray;
+ (NSArray *)getLandscapeCategoryList;

//用户是否改变过首页分栏
+ (void)saveUserHaschangeColumn:(BOOL)isChange;

+ (BOOL)getUserHaschangeColumn;


/**
 *  保存用户是否第一次进入全民app
 *
 *  @param state
 */
+ (void)saveFirstOpenQM_APP:(NSInteger)state;
/**
 *  获取用户是否第一次进入全民app
 *
 *  @return 0:未进入过 1:进入过
 */
+ (NSInteger)getFirstOpenQM_APP;


/**
 *  保存本地保存的version值
 *
 *  @param state
 */
+ (void)saveAppVersion:(NSString *)versionStr;
/**
 *  获取用户是否第一次进入全民app
 *
 *  @return 保存的version
 */
+ (NSString *)getSavedAppVersion;

/*
    保存横幅配置列表
*/
+ (BOOL)saveBannerConfigList:(NSArray *)configList;

/*
    获取横幅配置列表
 */
+ (NSArray *)getBannerConfigList;

/*
    保存礼物配置信息
 */
+ (BOOL)saveGiftConfigList:(NSArray *)configList;

/*
    获取礼物配置列表
 */
+ (NSArray *)getGiftConfigList;

/*设置网络请求超时时间*/
+ (BOOL)setRequestTimeOut:(CGFloat)timeOut;

/*获取网络请求超时时间, 默认是6秒*/
+ (CGFloat)getRequestTimeOut;

/*
    保存抢过的宝箱的ID, 如果抢过了, 后面再进入房间收到这个宝箱就不要显示这个宝箱
 */
+ (BOOL)addRobedChestID:(NSInteger)chestID;

//清空之前保存的抢过的宝箱的ID
+ (BOOL)cleanRobedChestIDs;

//之前保存的抢过的宝箱的ID数组
+ (NSArray *)robedChestIDs;

/*
 获取礼物配置列表
 */
+ (NSArray *)getGiftConfigList;

//设置启动视频是否观看过, 只在更新后设置为YES
+ (void)setLaunchVideoWatched:(BOOL)watched;

//启动视频是否看过, 如果看过就不再显示
+ (BOOL)launchVideoWatched;

#pragma mark - 引导图相关

////////////////////////////////////////////////////////////////////////
//新版本引导
////////////////////////////////////////////////////////////////////////

////获取用户是否展示过版本引导页
//+ (BOOL)newVersionGurided;
//
////设置用户是否展示过版本引导页
//+ (void)setNewVersionGurided:(BOOL)isSaved;


////////////////////////////////////////////////////////////////////////
//全屏播放器引导
////////////////////////////////////////////////////////////////////////

//获取用户是否展示过全屏播放引导页
+ (BOOL)fullScreenGurided;
//设置用户是否展示过全屏播放引导页
+ (void)setFullScreenGurided:(BOOL)isSaved;

//获取用户是否展示过 摇一摇
+ (BOOL)fullScreenShakeGuide;
//设置 摇一摇
+ (void)setFullScreenShakeGuide:(BOOL)isSaved;


//获取用户是否展示过截屏引导页
+ (BOOL)screenshotsShareGuride;
//设置用户是否展示过截屏引导页
+ (void)setScreenshotsShareGuride:(BOOL)isSaved;



@end
