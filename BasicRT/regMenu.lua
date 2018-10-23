--
-- Created by IntelliJ IDEA.
-- User: Katie's Work laptop
-- Date: 23/03/2017
-- Time: 15:30
-- To change this template use File | Settings | File Templates.

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"
local usernameInput
local passwordInput
local regGSBtn

--text user imputlocal function textListener( event )

local function textListener(event)
    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        --save --if(
       usernameInput = event.target.text
       print( event.target.text)
    elseif ( event.phase == "editing" ) then
        --print( event.newCharacters )
        --print( event.oldText )
        ---print( event.startPosition )
        --print( event.text )
    end
end
--2nd listener will remove after figure out how to use just one
local function passwordListener(event)
    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        --save --if(
        passwordInput = event.target.text
        print( event.target.text)
    elseif ( event.phase == "editing" ) then
        --print( event.newCharacters )
        --print( event.oldText )
        ---print( event.startPosition )
        --print( event.text )
    end
end

-- send reg request to gamesparks
local function onGSRegBtnRelease()
    --Build request
    local requestBuilder = gs.getRequestBuilder()
    local registerRequest = requestBuilder.createRegistrationRequest()

    --Set values
    registerRequest:setDisplayName(usernameInput)
    registerRequest:setUserName(usernameInput)
    registerRequest:setPassword(passwordInput)
    print("button pressed")
    --Send and check for errors, if no errors print username and message
    registerRequest:send(function(authenticationResponse)
        if not authenticationResponse:hasErrors() then
            print(" has successfully registered!")
            composer.gotoScene( "level1" )
        end
    end)
    return true
end
function scene:create( event )
    local sceneGroup = self.view

    -- display a background image
    local background = display.newImageRect( "background.jpg", display.actualContentWidth, display.actualContentHeight )
    background.anchorX = 0
    background.anchorY = 0
    background.x = 0 + display.screenOriginX
    background.y = 0 + display.screenOriginY
      -- Background First
    sceneGroup:insert( background )


    --set up text boxes
     local usernameLabel = display.newText("USERNAME : ",100,150,native.systemFont,16)
     local username = native.newTextField(300,150,180,30)
     --username.placeholder = "username"
     username:addEventListener( "userInput", textListener )
    sceneGroup:insert(usernameLabel)
    sceneGroup:insert(username)
    

    local passwordLabel = display.newText("PASSWORD : ",100,200,native.systemFont,16)
    local password = native.newTextField(300,200,180,30)
    password:addEventListener("userInput",passwordListener)
    sceneGroup:insert(passwordLabel)
    sceneGroup:insert(password)

    regGSBtn = widget.newButton{
        label="Register",
        labelColor = { default={255}, over={128} },
        default="button.png",
        over="button-over.png",
        width=154, height=40,
        onRelease = onGSRegBtnRelease	-- event listener function
    }
    regGSBtn.x = display.contentCenterX
    regGSBtn.y = display.contentHeight -50

   sceneGroup:insert(regGSBtn)

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

end
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene

