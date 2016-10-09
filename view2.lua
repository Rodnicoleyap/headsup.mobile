-----------------------------------------------------------------------------------------
--
-- view2.lua
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require("widget")
local scene = composer.newScene()
_G.textboxTitle = native.newTextField( 1, 1, 1, 1 )
_G.textboxTo = native.newTextField( 1, 1, 1, 1 )
_G.textboxBody  = native.newTextBox( 1, 1, 1, 1 )
textboxTitle.isVisible = false
textboxTo.isVisible = false
textboxBody.isVisible = false

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

local scrollView = widget.newScrollView
{
	left = 0,
	top = 0,
	width = display.contentWidth,
	height = display.contentHeight,
	topPadding = 0,
	bottomPadding = 0,
	horizontalScrollDisabled = true,
	verticalScrollDisabled = false,
	listener = scrollListener,
}
local lotsOfText = ""
local lotsOfTextObject = display.newText( lotsOfText, 0, 0, 300, 0, "Roboto", 14)
lotsOfTextObject:setTextColor(0)
lotsOfTextObject.x = display.contentCenterX
scrollView:insert( lotsOfTextObject )

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	--
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- create a white background to fill screen
	local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	background:setFillColor( 1, 1, 1 )

	-- local box = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth-25, display.contentHeight-150)
	-- box:setFillColor( 1, 1, 1 )
	-- box.stroke = paint
	-- box.strokeWidth = 2

	-- create some text
	-- local newTextParams = { text = "Loaded by the first tab's\n\"onPress\" listener\nspecified in the 'tabButtons' table",
	-- 					x = display.contentCenterX + 10,
	-- 					y = title.y + 215,
	-- 					width = 310, height = 310,
	-- 					font = "Roboto", fontSize = 14,
	-- 					align = "center" }
	-- local summary = display.newText( newTextParams )
	-- summary:setFillColor( 1 )
	local title = display.newText( "Title: ", display.screenOriginX + 33, 100, "Roboto", 22 )
	title:setFillColor( 0 )
	local to = display.newText( "To: ", display.screenOriginX + 25, 125, "Roboto", 22 )
	to:setFillColor( 0 )
	local body = display.newText( "Body: ", display.screenOriginX + 37, 150, "Roboto", 22 )
	body:setFillColor( 0 )

	-- native.newTextField( centerX, centerY, width, height )
	-- native.newTextBox( centerX, centerY, width, height )
	textboxTitle = native.newTextField(display.contentWidth*0.6, 100, display.contentWidth*0.75, 25 )
	textboxTitle.isEditable = true
	textboxTitle.size = 14
	textboxTitle.text = ""
	textboxTitle.isFontSizeScaled = true
	textboxTitle.placeholder = "notification title"

	textboxTo = native.newTextField(display.contentWidth*0.6, 130, display.contentWidth*0.75, 25 )
	textboxTo.isEditable = true
	textboxTo.size = 14
	textboxTo.text = ""
	textboxTo.isFontSizeScaled = true
	textboxTo.placeholder = "recipient"

	textboxBody = native.newTextBox( display.contentWidth*0.5225, 335, display.contentWidth*0.90, display.contentHeight*0.55 )
	textboxBody.isEditable = true
	textboxBody.size = 14
	textboxBody.text = ""
	textboxBody.isFontSizeScaled = true
	textboxBody.placeholder = "enter your message here"

	textboxTitle.isVisible = true
	textboxTo.isVisible = true
	textboxBody.isVisible = true

	function background:tap(event)
		native.setKeyboardFocus(nil)
	end
	background:addEventListener("tap", background)

	-- all objects must be added to group (e.g. self.view)
	scrollView:insert( background )
	scrollView:insert( title )
	scrollView:insert( to )
	scrollView:insert( body )
	scrollView:insert( textboxTitle )
	scrollView:insert( textboxTo )
	scrollView:insert( textboxBody )
	sceneGroup:insert( scrollView )
	-- sceneGroup:insert( summary )
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