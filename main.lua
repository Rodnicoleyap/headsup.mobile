-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- show default status bar (iOS)
display.setStatusBar( display.TranslucentStatusBar )

-- include Corona's "widget" library
local widget = require "widget"
local composer = require "composer"

local transition_opt0 = {
  effect = "fade",
  time = 2000
}

local transition_opt1 =
{
    effect = "slideRight",
    time = 250,
}

local transition_opt2 =
{
    effect = "slideLeft",
    time = 250,
}

local transition_opt3 =
{
    effect = "fade",
    time = 400,
}

-- event listeners for tab buttons:
local function onZerothView(event)
  composer.gotoScene( "view0", transition_opt0)
end

local function onFirstView( event )
	composer.gotoScene( "view1", transition_opt1 )
end

local function onSecondView( event )
	composer.gotoScene( "view2", transition_opt2)
end


-- create a tabBar widget with two buttons at the bottom of the screen

-- table to setup buttons
local tabButtons = {
	{ label="", defaultFile="list.png", overFile="viewList.png", width = 32, height = 32, onPress=onFirstView, selected=true},
	{ label="", defaultFile="circle.png", overFile="circleFill.png", width = 32, height = 32, onPress=onSecondView,},
}

-- create the actual tabBar widget
local tabBar = widget.newTabBar
{
	top = display.contentHeight - 50,	-- 50 is default height for tabBar widget
	buttons = tabButtons
}

-- invoke first tab button's onPress event manually

composer.showOverlay( "view0")
composer.hideOverlay( "fade")
composer.gotoScene("view1")

i = 1
local navBar
-- create panel
function widget.newPanel( options )
    local customOptions = options or {}
    local opt = {}

    opt.location = customOptions.location or "top"

    local default_width, default_height
    if ( opt.location == "top" or opt.location == "bottom" ) then
        default_width = display.contentWidth
        default_height = display.contentHeight * 0.33
    else
        default_width = display.contentWidth * 0.33
        default_height = display.contentHeight
    end

    opt.width = customOptions.width or default_width
    opt.height = customOptions.height or default_height

    opt.speed = customOptions.speed or 500
    opt.inEasing = customOptions.inEasing or easing.linear
    opt.outEasing = customOptions.outEasing or easing.linear

    if ( customOptions.onComplete and type(customOptions.onComplete) == "function" ) then
        opt.listener = customOptions.onComplete
    else
        opt.listener = nil
    end

    local container = display.newContainer( opt.width, opt.height )

    if ( opt.location == "left" ) then
        container.anchorX = 1.0
        container.x = display.screenOriginX
        container.anchorY = 0.5
        container.y =  display.screenOriginY + (opt.height/2) --display.contentCenterY
    elseif ( opt.location == "right" ) then
        container.anchorX = 0.0
        container.x = display.actualContentWidth
        container.anchorY = 0.5
        container.y = display.contentCenterY
    elseif ( opt.location == "top" ) then
        container.anchorX = 0.5
        container.x = display.contentCenterX
        container.anchorY = 1.0
        container.y = display.screenOriginY
    else
        container.anchorX = 0.5
        container.x = display.contentCenterX
        container.anchorY = 0.0
        container.y = display.actualContentHeight
    end

    function container:show()
        local options = {
            time = opt.speed,
            transition = opt.outEasing
        }
        if ( opt.listener ) then
            options.onComplete = opt.listener
            self.completeState = "shown"
        end
        if ( opt.location == "top" ) then
            options.y = display.screenOriginY + opt.height
        elseif ( opt.location == "bottom" ) then
            options.y = display.actualContentHeight - opt.height
        elseif ( opt.location == "left" ) then
            options.x = display.screenOriginX + opt.width
            options.y = display.screenOriginY + (opt.height/2)
        else
            options.x = display.actualContentWidth - opt.width
        end
        transition.to( self, options )
        local currentScene = composer.getSceneName("current")
        if(currentScene == "view2") then
            textboxTitle.isVisible = false
            textboxTo.isVisible = false
            textboxBody.isVisible = false
        end
        container:toFront()
    end

    function container:hide()
        local options = {
            time = opt.speed,
            transition = opt.outEasing
        }
        if ( opt.listener ) then
            options.onComplete = opt.listener
            self.completeState = "hidden"
        end
        if ( opt.location == "top" ) then
            options.y = display.screenOriginY
        elseif ( opt.location == "bottom" ) then
            options.y = display.actualContentHeight
        elseif ( opt.location == "left" ) then
            options.x = display.screenOriginX
        else
            options.x = display.actualContentWidth
        end
        transition.to( self, options )
        local currentScene = composer.getSceneName("current")
        if(currentScene == "view2") then
            textboxTitle.isVisible = true
            textboxTo.isVisible = true
            textboxBody.isVisible = true
        end
    end

    function myTouchListener( event )
        print( "Touch X location " .. event.x )
        print( "Touch Y location " .. event.y )
        print( "i :  " .. i )

        if(i % 2 == 0) then
            container:hide()
            navBar:hide()
            i = i+1
        end
    end
    return container
end

-- local function panelTransDone( target )
--     native.showAlert( "Panel", "Complete", { "Okay" } )
--     if ( target.completeState ) then
--         print( "PANEL STATE IS: "..target.completeState )
--     end
-- end

_G.panel = widget.newPanel{
    -- onComplete = panelTransDone,
    location = "left",
    width = display.contentWidth * 0.8,
    height = display.contentHeight * 0.910,
    speed = 250,
    inEasing = easing.outBack,
    outEasing = easing.outCubic,
}

panel.background = display.newRect( 0, 0, panel.width, panel.height )
-- panel.background:setFillColor( 0.129, 0.588, 0.953 )
panel.background:setFillColor( 0.98, 0.98, 0.98 )
panel:insert( panel.background )

panel.title = display.newText( "menu", 0, 0, "Roboto", 20 )
panel.title:setFillColor( 0, 0, 0 )
panel:insert( panel.title )

-- create navigation bar
function widget.newNavigationBar( options )
   local customOptions = options or {}
   local opt = {}
   opt.left = customOptions.left or nil
   opt.top = customOptions.top or nil
   opt.width = customOptions.width or display.contentWidth
   opt.height = customOptions.height or 50
   if ( customOptions.includeStatusBar == nil ) then
      opt.includeStatusBar = true  -- assume status bars for business apps
   else
      opt.includeStatusBar = customOptions.includeStatusBar
   end

   -- Determine the amount of space to adjust for the presense of a status bar
   local statusBarPad = 0
   if ( opt.includeStatusBar ) then
      statusBarPad = display.topStatusBarContentHeight
   end

   opt.x = customOptions.x or display.contentCenterX
   opt.y = customOptions.y or (opt.height + statusBarPad) * 0.5
   opt.id = customOptions.id
   opt.isTransluscent = customOptions.isTransluscent or true
   opt.background = customOptions.background
   opt.backgroundColor = customOptions.backgroundColor
   opt.title = customOptions.title or ""
   opt.titleColor = customOptions.titleColor or { 0, 0, 0 }
   opt.font = customOptions.font or native.systemFontBold
   opt.fontSize = customOptions.fontSize or 20
   opt.leftButton = customOptions.leftButton or nil
   opt.rightButton = customOptions.rightButton or nil

   -- If "left" and "top" parameters are passed, calculate the X and Y
   if ( opt.left ) then
      opt.x = opt.left + opt.width * 0.5
   end
   if ( opt.top ) then
      opt.y = opt.top + (opt.height + statusBarPad) * 0.5
   end

   local barContainer = display.newGroup()
   local background = display.newRect( barContainer, opt.x, opt.y, opt.width, opt.height + statusBarPad )

   if ( opt.background ) then
      background.fill = { type="image", filename=opt.background }
   elseif ( opt.backgroundColor ) then
      background.fill = opt.backgroundColor
   else
      background.fill = { 1, 1, 1 }
   end

   local title

   if ( opt.title ) then
      title = display.newText( opt.title, background.x, background.y + statusBarPad * 0.5, opt.font, opt.fontSize )
      title:setFillColor( unpack(opt.titleColor) )
      barContainer:insert( title )
   end

   local leftButton
   if ( opt.leftButton ) then
      if ( opt.leftButton.defaultFile ) then  -- construct an image button
         leftButton = widget.newButton({
            id = opt.leftButton.id,
            width = opt.leftButton.width,
            height = opt.leftButton.height,
            baseDir = opt.leftButton.baseDir,
            defaultFile = opt.leftButton.defaultFile,
            overFile = opt.leftButton.overFile,
            onEvent = opt.leftButton.onEvent,
            })
      else  -- else, construct a text button
         leftButton = widget.newButton({
            id = opt.leftButton.id,
            label = opt.leftButton.label,
            onEvent = opt.leftButton.onEvent,
            font = opt.leftButton.font or opt.font,
            fontSize = opt.fontSize,
            labelColor = opt.leftButton.labelColor or { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
            labelAlign = "left",
            })
      end
      leftButton.x = 15 + leftButton.width * 0.5
      leftButton.y = title.y
      barContainer:insert( leftButton )  -- insert button into container group
   end

   local rightButton
   if ( opt.rightButton ) then
      if ( opt.rightButton.defaultFile ) then  -- construct an image button
         rightButton = widget.newButton({
            id = opt.rightButton.id,
            width = opt.rightButton.width,
            height = opt.rightButton.height,
            baseDir = opt.rightButton.baseDir,
            defaultFile = opt.rightButton.defaultFile,
            overFile = opt.rightButton.overFile,
            onEvent = opt.rightButton.onEvent
            })
      else  -- else, construct a text button
         rightButton = widget.newButton({
            id = opt.rightButton.id,
            label = opt.rightButton.label or "",
            onEvent = opt.rightButton.onEvent,
            font = opt.leftButton.font or opt.font,
            fontSize = opt.fontSize,
            labelColor = opt.rightButton.labelColor or { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
            labelAlign = "right",
            })
      end
      rightButton.x = display.contentWidth - ( 15 + rightButton.width * 0.5 )
      rightButton.y = title.y
      barContainer:insert( rightButton )  -- insert button into container group
    end

    function barContainer:show()
        local options = {
            time = 250,
            transition = opt.outEasing
        }
        if ( opt.listener ) then
            options.onComplete = opt.listener
            self.completeState = "shown"
        end
        options.x = panel.width
        transition.to( self, options )
        composer.showOverlay( "dim_view1", transition_opt3)
    end

    function barContainer:hide()
        local options = {
            time = 100,
            transition = opt.outEasing
        }
        if ( opt.listener ) then
            options.onComplete = opt.listener
            self.completeState = "shown"
        end
        options.x = 0
        transition.to( self, options )
        composer.hideOverlay("fade", 100)
    end
    return barContainer
end

local function handleLeftButton( event )
   if ( event.phase == "began" ) then
      -- do stuff
        i = i + 1
        print( "Button was pressed and released" )
        if (i % 2 == 0) then
            panel:show()
            navBar:show()
        else
            panel:hide()
            navBar:hide()
        end
   end
   return true
end

local function handleRightButton( event )
   if ( event.phase == "ended" ) then
      -- do stuff
   end
   return true
end

local leftButton = {
   onEvent = handleLeftButton,
   width = 32,
   height = 32,
   defaultFile = "hamburger.png",
   overFile = "hamburger.png",
   onEvent = handleLeftButton
}

-- local rightButton = {
--    onEvent = handleRightButton,
--    -- label = "Add",
--    labelColor = { default =  {1, 1, 1}, over = { 0.5, 0.5, 0.5} },
--    font = "Roboto",
--    isBackButton = false
-- }

navBar = widget.newNavigationBar({
   -- title = "Navigation Bar",
   backgroundColor = {0.718, 0.11, 0.11},
   --background = "images/topBarBgTest.png",
   -- titleColor = {1, 1, 1},
   -- font = "Roboto",
   leftButton = leftButton,
   includeStatusBar = true
})

local logo = display.newImage(navBar, "icon.png", navBar.width*0.5, navBar.height*0.6)
logo:scale(0.4,0.4)