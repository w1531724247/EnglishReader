//
//  DocumentListCell.m
//  EnglishReader
//
//  Created by QMTV on 17/1/9.
//  Copyright © 2017年 LFC. All rights reserved.
//

#import "DocumentListCell.h"

@implementation DocumentListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"DocumentListCell";
    DocumentListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[DocumentListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

@end
