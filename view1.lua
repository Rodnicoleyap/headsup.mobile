-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require("widget")
local scene = composer.newScene()

local function scrollListener( event )
	local phase = event.phase
	local direction = event.direction

	if event.limitReached then
		if "up" == direction then
			print("Reached Top Limit")
		elseif "down" == direction then
			print("Reached Bottom Limit")
		end
	end
	return true
end

-- local scrollView = widget.newScrollView
-- {
-- 	left = 0,
-- 	top = 0,
-- 	width = display.contentWidth,
-- 	height = display.contentHeight,
-- 	topPadding = 50,
-- 	bottomPadding = 50,
-- 	horizontalScrollDisabled = true,
-- 	verticalScrollDisabled = false,
-- 	listener = scrollListener,

-- }

local function onRowRender( event )
	local row = event.row
	local rowHeight = row.contentHeight
	local rowWidth = row.contentWidth
	local rowTitle = display.newText( row, "Notif " .. row.index, 0, 0, nil, 14 )
	rowTitle:setFillColor( 0 )
	rowTitle.align = left

	rowTitle.anchorX = 0
	rowTitle.x = 10
	rowTitle.y = rowHeight * 0.5
end

local widget = require( "widget" )

-- The "onRowRender" function may go here (see example under "Inserting Rows", above)

-- Create image sheet for custom scroll bar
-- local scrollBarOpt = {
--     width = 20,
--     height = 20,
--     numFrames = 3,
--     sheetContentWidth = 20,
--     sheetContentHeight = 60
-- }
-- local scrollBarSheet = graphics.newImageSheet( "scrollBar.png", scrollBarOpt )

-- Create the widget
local tableView = widget.newTableView(
    {
        left = display.screenOriginX,
        top = display.screenOriginY + 95,
        height = display.contentHeight,
        width = display.contentWidth,
        onRowRender = onRowRender,
        onRowTouch = onRowTouch,
        listener = scrollListener,
    }
)

-- Insert 40 rows
for i = 1, 10 do

    -- Insert a row into the tableView
    tableView:insertRow(
        {
            isCategory = false,
            rowHeight = 100,
            rowColor = { default={1,1,1}, over={1,0.5,0,0.2} },
            lineColor = { 0.5, 0.5, 0.5 }
        }
    )
end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	--
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- create a white background to fill screen
	local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	background:setFillColor( 1, 1, 1 )

	-- create some text
	local title = display.newText( "Notifications", 0, 0, native.systemFont, 20 )
	title:setFillColor( 0 )
	title.anchorX = 0
	title.x = 10
	title.y = 80

	-- local newTextParams = { text = "Loaded by the second tab's\n\"onPress\" listener\nspecified in the 'tabButtons' table",
	-- 						x = display.contentCenterX + 10,
	-- 						y = title.y + 215,
	-- 						width = 310,
	-- 						height = 310,
	-- 						font = "Roboto",
	-- 						fontSize = 14,
	-- 						align = "center" }
	-- local summary = display.newText( newTextParams )
	-- summary:setFillColor( 0 )
	-- all objects must be added to group (e.g. self.view)
	sceneGroup:insert( background )
	sceneGroup:insert( title )
	-- sceneGroup:insert( summary )
	sceneGroup:insert( tableView )
	-- sceneGroup:insert( scrollView )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		--
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-----------------------------------------------------------------------------------------

return scene
