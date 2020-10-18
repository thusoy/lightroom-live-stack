local LrApplication = import 'LrApplication'
local LrLogger = import 'LrLogger'
local LrPathUtils = import 'LrPathUtils'
local LrProgressScope = import 'LrProgressScope'
local LrTasks = import 'LrTasks'

local catalog = LrApplication.activeCatalog()
local logger = LrLogger('LiveStack')
logger:enable('logfile')
LSMenuItem = {}

function LSMenuItem.stackLivePhotos()
    catalog:withWriteAccessDo('Stack Live photos', function (context)
        local selectedPhotos = catalog.targetPhotos
        local progressScope = LrProgressScope({
            title="Stacking live photos",
        })
        local photosCompleted = 0
        for _, photo in ipairs(selectedPhotos) do
            local fileType = photo:getFormattedMetadata('fileType')
            if fileType == 'HEIC' then
                if not photo:getRawMetadata('isInStackInFolder') then
                    local videoPath = LrPathUtils.replaceExtension(photo:getRawMetadata('path'), 'mov')
                    local status, err = LrTasks.pcall(function ()
                        catalog:addPhoto(videoPath, photo, 'below')
                    end)
                    if status then
                        logger:infof("Successfully stacked '%s' with '%s'", videoPath, photo:getFormattedMetadata('fileName'))
                    else
                        logger:debugf("No video for '%s', got err %s", photo:getFormattedMetadata('fileName'), err)
                    end
                else
                    logger:debugf("Skipping already stacked '%s'", photo:getFormattedMetadata('fileName'))
                end
            else
                logger:debugf('Skipping non-heic file %s', photo:getFormattedMetadata('fileName'))
            end
            photosCompleted = photosCompleted + 1
            progressScope:setPortionComplete(photosCompleted, #selectedPhotos)
        end
        progressScope:done()
    end)
end

LrTasks.startAsyncTask(LSMenuItem.stackLivePhotos)
