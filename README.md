# MacOS Animation Cancel App

Very basic animation canceling app for Stardew Valley (works in SMAPI as well) using Swift and SwiftUI. 

Incredibly basic, some might even say script-kiddy like, but it works (and I know enough Quartz to handle sending events/checking the active window).

Run the app, first time in game that you press Space to cancel you'll get a permissions prompt to allow the app to control your computer. After allowing it should start to cancel as expected.

**NOTE:** if you're used to the python version of this, this one is significantly more responsive (the library we use in python adds about 20-30ms of delay on a cancel, so you can cancel early and still hit the right timing). This will likely require retuning your muscle memory (I AC like garbage right now/cancel way too early).