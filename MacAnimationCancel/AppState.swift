import SwiftUI
import KeyboardShortcuts
import Carbon.HIToolbox

extension KeyboardShortcuts.Name {
    static let spacePressed = Self("spacePressed")
}

@MainActor
final class AppState: ObservableObject {
    init() {
        KeyboardShortcuts.setShortcut(
                    KeyboardShortcuts.Shortcut(KeyboardShortcuts.Key.space, modifiers: []),
                    for: .spacePressed)
        // start disabled to avoid bricking the space button
        KeyboardShortcuts.isEnabled = false
    }
}

// https://stackoverflow.com/q/47199196
// will check if the active window is stardew and enable/disable shortcut watching
class ActiveApp: NSObject {
    private var acEvent = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
    
    private var pid: pid_t = -1
    
    override init() {
        super.init()
        NSWorkspace.shared.notificationCenter.addObserver(self,
            selector: #selector(checkStardewActive(notification:)),
            name: NSWorkspace.didActivateApplicationNotification,
            object:nil)

    }
    @objc func checkStardewActive(notification: NSNotification) {
        let app = notification.userInfo!["NSWorkspaceApplicationKey"] as! NSRunningApplication
        KeyboardShortcuts.isEnabled = app.bundleIdentifier == "com.concernedape.stardewvalley"
        if KeyboardShortcuts.isEnabled {
            pid = app.processIdentifier
        } else {
            releaseAnimationCancel()
            pid = -1
        }
    }
    
    public func pressAnimationCancel() {
        if pid == -1 {
            return
        }
        if let spaceKeyEvent = CGEvent(keyboardEventSource: acEvent, virtualKey: CGKeyCode(kVK_Space), keyDown: true),
           let deleteKeyEvent = CGEvent(keyboardEventSource: acEvent, virtualKey: CGKeyCode(kVK_ForwardDelete), keyDown: true),
           let rKeyEvent = CGEvent(keyboardEventSource: acEvent, virtualKey: CGKeyCode(kVK_ANSI_R), keyDown: true),
           let shiftKeyEvent = CGEvent(keyboardEventSource: acEvent, virtualKey: CGKeyCode(kVK_RightShift), keyDown: true) {
            spaceKeyEvent.postToPid(pid)
            deleteKeyEvent.postToPid(pid)
            rKeyEvent.postToPid(pid)
            shiftKeyEvent.postToPid(pid)
        }
    }

    public func releaseAnimationCancel() {
        if pid == -1 {
            return
        }
        if let spaceKeyEvent = CGEvent(keyboardEventSource: acEvent, virtualKey: CGKeyCode(kVK_Space), keyDown: false),
           let deleteKeyEvent = CGEvent(keyboardEventSource: acEvent, virtualKey: CGKeyCode(kVK_ForwardDelete), keyDown: false),
           let rKeyEvent = CGEvent(keyboardEventSource: acEvent, virtualKey: CGKeyCode(kVK_ANSI_R), keyDown: false),
           let shiftKeyEvent = CGEvent(keyboardEventSource: acEvent, virtualKey: CGKeyCode(kVK_RightShift), keyDown: false) {
            spaceKeyEvent.postToPid(pid)
            deleteKeyEvent.postToPid(pid)
            rKeyEvent.postToPid(pid)
            shiftKeyEvent.postToPid(pid)
        }
    }
}

