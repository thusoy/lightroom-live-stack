local LrApplication = import 'LrApplication'
local LrLogger = import 'LrLogger'
local LrProgressScope = import 'LrProgressScope'
local LrTasks = import 'LrTasks'

local catalog = LrApplication.activeCatalog()
local logger = LrLogger('SyncStack')
logger:enable('logfile')
LSMenuItem = {}

function LSMenuItem.syncStackPicks()
    catalog:withWriteAccessDo('Sync picks to stack', function (context)
        local selectedPhotos = catalog.targetPhotos
        local progressScope = LrProgressScope({
            title="Syncing pick status to stacks",
        })
        local photosCompleted = 0
        for _, photo in ipairs(selectedPhotos) do
            if photo:getRawMetadata('isInStackInFolder') then
                if photo:getRawMetadata('stackPositionInFolder') == 1 then
                    -- If it's stacked and on top of the stack, get it's pick status and
                    -- sync it to the rest of the stack
                    local pickStatus = photo:getRawMetadata('pickStatus')
                    for _, stackedPhoto in ipairs(photo:getRawMetadata('stackInFolderMembers')) do
                        logger:debugf('Setting pick status for %s', stackedPhoto:getFormattedMetadata('fileName'))
                        stackedPhoto:setRawMetadata('pickStatus', pickStatus)
                    end
                end
            end
            photosCompleted = photosCompleted + 1
            progressScope:setPortionComplete(photosCompleted, #selectedPhotos)
        end
        progressScope:done()
    end)
end

LrTasks.startAsyncTask(LSMenuItem.syncStackPicks)
