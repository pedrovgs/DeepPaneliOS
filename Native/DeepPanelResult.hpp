//
//  DeepPanelResult.hpp
//  DeepPanel
//
//  Created by Pedro Gómez on 11/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

#ifndef DeepPanelResult_hpp
#define DeepPanelResult_hpp

#include <stdio.h>
#include "Panel.hpp"
#include "ConnectedComponentResult.hpp"

class DeepPanelResult {
public:
    ConnectedComponentResult connected_components;
    Panel *panels;
};

#endif /* DeepPanelResult_hpp */
