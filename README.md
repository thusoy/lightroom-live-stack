# Lightroom LiveStack

Simple Lightroom plugin that helps stack Apple's Live videos with the photos.


## Background

Apple's Live photos are photos that also have an attached 3 second video file. This can be used to get temporal context to a photo, and particularly for photos of groups, kids or animals can assist in finding a frame where all the subjects looks at the camera, or are in the frame altogether.

Support for Live photos is limited however. If you use Dropbox to automatically upload photos for example, you will only get the photo part, not the video. To actually get both the photo and video from your phone onto your computer the easiest is probably to use Photos to import then, then "Export Unmodified Original" to a directory you import into Lightroom. Lightroom supports showing both the photo and the video, but doesn't know that they are connected, thus making them slightly inconvenient to manage.

To make it more pleasant to actually manage Live photos in a sane workflow, this plugin will stack the videos with the corresponding photo. We can tell that a photo and video is connected since they have the same filename but a different extension. When stacked the photo and video won't both appear in Lightroom when stacks are collapsed, but the video is easily available if you want to see it by expanding the stack. Lightroom doesn't provide much support for doing much with the video, but as long as you keep it alongside the main photo you have the ability to open it up in Photos to extract a given frame you can re-import into Lightroom if necessary.

The plugin has to work around a kink in the Lightroom plugin API however, namely it's complete lack of support for stacking. The only way to create a stack from the API is when something is imported to the library, at which point we can stack it with an existing item. Thus for the plugin to work, you need to have imported all the photos without the video, then run the plugin to import the videos into a stack with the photo.


## Suggested workflow

- Import photos from phone with Photos
- Do a brief review, deleting obvious bad takes
- For Live photos where you want to switch the key frame, use Photos to edit the key frame, then export only these modified photos as TIFF
- Export all photos as originals from Photos
- Import all the photos into Lightroom, excluding the videos
- Run the plugin to import and stack the videos
    - If you edited the key frame of any photo, manually stack this with the original photo and video.
- Continue your regular Lightroom workflow


## Noteworthy

The plugin currently assumes you capture the Live photos with the new HEIC format and not JPG.


## License

This project is licensed under the Hippocratic License, an Ethical Source license that
specifically prohibits the use of software to violate universal standards of human rights.