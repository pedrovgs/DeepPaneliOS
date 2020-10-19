//
//  deep-panel-ios.hpp
//  DeepPanel
//
//  Created by Pedro Gómez on 11/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

#ifndef deep_panel_ios_hpp
#define deep_panel_ios_hpp

#include <stdio.h>
#include "DeepPanelResult.hpp"

using namespace std;

namespace native {
        DeepPanelResult extract_panels_info_native(float *prediction, float scale, int original_image_width, int original_image_height);
}

#endif /* deep_panel_ios_hpp */
