//
//  WordListCell.m
//  EnglishReader
//
//  Created by QMTV on 17/1/11.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "WordListCell.h"

@interface WordListCell ()

@end

@implementation WordListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"WordListCell";
    WordListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[WordListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}


@end
