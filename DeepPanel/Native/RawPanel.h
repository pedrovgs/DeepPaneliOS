//
//  RawPanel.h
//  DeepPanel
//
//  Created by Pedro Gómez on 11/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef RawPanel_h
#define RawPanel_h

@interface RawPanel : NSObject
    @property(nonatomic, readwrite) int left;
    @property(nonatomic, readwrite) int top;
    @property(nonatomic, readwrite) int right;
    @property(nonatomic, readwrite) int bottom;
@end

#endif /* RawPanel_h */
