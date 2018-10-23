--
-- Created by IntelliJ IDEA.
-- User: Katie's Work laptop
-- Date: 24/03/2017
-- Time: 19:42
-- To change this template use File | Settings | File Templates.


local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"
local usernameInput
local passwordInput
local logGSBtn
local username
local password

--text user imputlocal function textListener( event )

local function textListener(event)
    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
  --  print(event.name)
       --if(event.name == "nameInput")then
            usernameInput = event.target.text
            print( event.target.text)
        --elseif(event.name == "passwordInput")then
          --  passwordInput = event.target.text
          --  print( event.target.text)
        --end



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

local function tieAccounts()
     --Build request
    local requestBuilder = gs.getRequestBuilder()
    local changeAuth = requestBuilder.createChangeUserDetailsRequest()

    --Set values
    changeAuth:setNewPassword(passwordInput)
    changeAuth:setUserName(usernameInput)
    changeAuth:setDisplayName(usernameInput)

    --Send and check for errors, if there are errors print them
    changeAuth:send(function(changeResponse)
        if changeResponse:hasErrors() then
            for key,value in pairs(changeResponse:getErrors()) do print(key,value) end

        end

    end)   

end
-- send reg request to gamesparks
local function onGSlogBtnRelease()

    tieAccounts()
    --Build request
    local requestBuilder = gs.getRequestBuilder()
    local loginAuth = requestBuilder.createAuthenticationRequest()

    --Set values
    loginAuth:setPassword(passwordInput)
    loginAuth:setUserName(usernameInput)

    --Send and check for errors, if there are errors print them
    loginAuth:send(function(authenticationResponse)
        if authenticationResponse:hasErrors() then
            for key,value in pairs(authenticationResponse:getErrors()) do print(key,value) end

        end
        print("go to game")
        composer.gotoScene( "level1" )

    end)

    return true
end


function scene:create( event )
    local Group = self.view

    -- display a background image
    local background = display.newImageRect( "background.jpg", display.actualContentWidth, display.actualContentHeight )
    background.anchorX = 0
    background.anchorY = 0
    background.x = 0 + display.screenOriginX
    background.y = 0 + display.screenOriginY

  -- Background First
    Group:insert( background )
    --set up text boxes
    --set up text boxes
    local usernameLabel = display.newText("USERNAME : ",100,150,native.systemFont,16)
    username = native.newTextField(300,150,180,30)
    --username.placeholder = "username"
    username:addEventListener( "userInput", textListener )
    Group:insert(usernameLabel)
    Group:insert(username)
    

    local passwordLabel = display.newText("PASSWORD : ",100,200,native.systemFont,16)
    password = native.newTextField(300,200,180,30)
    password:addEventListener("userInput",passwordListener)
    Group:insert(passwordLabel)
    Group:insert(password)

    logGSBtn = widget.newButton{
        label="Log In",
        labelColor = { default={255}, over={128} },
        default="button.png",
        over="button-over.png",
        width=154, height=40,
        onRelease = onGSlogBtnRelease	-- event listener function
    }
    logGSBtn.x = display.contentCenterX
    logGSBtn.y = display.contentHeight -50
    Group:insert(logGSBtn)



end


function scene:show( event )
    local Group = self.view
    local phase = event.phase

    if phase == "will" then
        -- Called when the scene is still off screen and is about to move on screen
    elseif phase == "did" then
        -- Called when the scene is now on screen
        composer.removeScene( "menu.lua" )
        --
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc.
    end
end

function scene:hide( event )
    local Group = self.view
    local phase = event.phase

    if event.phase == "will" then
        -- Called when the scene is on screen and is about to move off screen
        --
        -- INSERT code here to pause the scene
        -- e.g. stop timers, stop animation, unload sounds, etc.)
    elseif phase == "did" then
       -- remove listeners
        username:removeEventListener( "userInput", textListener )
        password:removeEventListener( "userInput", passwordListener )

        -- Called when the scene is now off screen
    end
end



function scene:destroy( event )
    local Group = self.view

end
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene

