import SwiftUI
import KeyboardShortcuts


private struct BaseView: View {
    let runme = ActiveApp()
    var body: some View {
        Text("Press Space to Animation Cancel")
            .frame(maxWidth: 100)
            .padding()
            .padding()
            .onKeyboardShortcut(.spacePressed) {
                if $0 == .keyDown {
                    runme.pressAnimationCancel()
                } else {
                    runme.releaseAnimationCancel()
                }
            }
    }
}

struct MainScreen: View {
    var body: some View {
        VStack {
            BaseView()
        }
            .frame(width: 200, height: 160)
    }
}
