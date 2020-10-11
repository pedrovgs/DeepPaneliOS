//
//  RawPanelsInfo.h
//  DeepPanel
//
//  Created by Pedro Gómez on 11/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RawPanel.h"
#ifndef RawPanelsInfo_h
#define RawPanelsInfo_h

@interface RawPanelsInfo : NSObject
    @property(nonatomic, readwrite) int **connectedAreas;
    @property(nonatomic, readwrite) NSArray * panels;
@end

#endif /* RawPanelsInfo_h */
