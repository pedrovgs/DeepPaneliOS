DeepPaneliOS ![Build](https://github.com/pedrovgs/DeepPaneliOS/workflows/Build/badge.svg)
================

iOS library used to implement **comic vignettes segmentation using a machine learning method named deep learning**.

DeepPanel let's you extract all the panels' location from a comic page **using a machine learning model trained [here](https://github.com/pedrovgs/DeepPanel). This iOS library does not use Open CV at all, this means the size of the final app you generates will be as small as possible. We've optimized our model in terms of size and performance and implemented the computer vision algorithms we needed without any third party library to optimize the final library size and performance**. Powered by [TensorFlow lite](https://www.tensorflow.org/lite), our already trained panels' segmentation model and some native code, DeepPanel is able to find all the panels' location in less than a second.

<img src="art/screencast.gif" width="300" />

Keep in mind, **this artificial intelligence solution is designed to simulate the human reading behavior and it will group panels that are related as a human would do while reading a comic book page.** When analyzing a page we do not use image processing algorithms in order to find the panels. Our solution is based on deep learning. We do not use contour detection algorithms at all even when the samples analysis can look similar. If you are looking for a panels contouring solution you can use Open CV or any other image analysis tools like [this project](https://github.com/njean42/kumiko) does.


| Original        | Analyzed           |
| ----------------|--------------------|
|![page](art/rawPage1.png)|![page](art/panelsInfo1.png)|
|![page](art/rawPage2.png)|![page](art/panelsInfo2.png)|

In case you are looking for the Android version of this project, you can find it [here](https://github.com/pedrovgs/DeepPanelAndroid).

All the pages used in our sample project are created by [Peper & Carrot](https://www.peppercarrot.com) which is a free comic book you should read right now :heart:

Usage
-----

### Dependency

Include the library in your ``Podfile``

```
pod 'DeepPanel'
```

To start using the library you just need to call `DeepPanel.initialize` . You can initialize this library from any ``ViewController`` or from your ``AppDelegate`` class:

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DeepPanel.initialize()
        return true
    }
}
```

Once you've initialized the library get any comic book page, transform it into a ``UIImage`` instance and extract the panels' information using ``extractPanelsInfo`` method as follows:

```swift
let deepPanel = DeepPanel()
let result = deepPanel.extract(bitmapSamplePage)
result.panels.panelsInfo.forEach { panel in
print("\(panel.left) - \(panel.top) - \(panel.right) - \(panel.bottom)")
}
```

``PredictionResult`` contains a list of panels with the position of every panel on the page and also a 2d matrix of integers with the following labels inside:

* 0 - Label associated to the page of the content.
* N - Content related to the same panel on the page.

Do not invoke DeepPanel ``extractPanelsInfo`` from the main app thread. Even when we can analyze a page in less than 500ms using regular device, you should not block your app UI at all. Our recommendation is to extract the analysis computation out of the UI thread using any queue.

Keep in mind for the first version of this library we consider every panel as a rectangle even if the content panel inside has a different shape. We will improve this in the future, for our very first release we've decided to use this approach because we will always represent the information of the panel on a rectangular screen.

### Do you want to contribute?

Feel free to contribute, we will be glad to improve this project with your help. Keep in mind that your PRs must be validated by GitHub actions before being reviewed by any core contributor.

### Acknowledgement

Special thanks to [Asun](https://github.com/asuncionjc), who never doubt we could publish this project :heart:

Developed By
------------

* Pedro Vicente Gómez Sánchez - <pedrovicente.gomez@gmail.com>

<a href="https://x.com/pedro_g_s">
  <img alt="Follow me on X" src="https://img.icons8.com/?size=100&id=6Fsj3rv2DCmG&format=png&color=000000" height="60" width="60"/>
</a>
<a href="https://es.linkedin.com/in/pedrovgs">
  <img alt="Add me to Linkedin" src="https://img.icons8.com/m_rounded/512/FFFFFF/linkedin.png" height="60" width="60"/>
</a>

License
-------

    Copyright 2020 Pedro Vicente Gómez Sánchez

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
