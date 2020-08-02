return {
    LrSdkVersion = 5.0,
    LrToolkitIdentifier = "com.thusoy.LiveStack",
    LrPluginName = "Live stack",
    LrLibraryMenuItems = {
        {
            title = "Stack Live photos",
            file = "LiveStack.lua",
            enabledWhen = "photosAvailable",
        },
        {
            title = "Sync picks to stack",
            file = "SyncStack.lua",
            enabledWhen = "photosAvailable",
        }
    },
    VERSION = {
        major = 1,
        minor = 0,
        revision = 0,
    },
}
