-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require( "json" )
local mainGroup = display.newGroup();

-- include Corona's "physics" library
local physics = require "physics"
local widget = require "widget"
local matchBtn
local TestBtn
local listener = gs.getMessageHandler()
local myPlayerId
local name
local requestBuilder = gs.getRequestBuilder()
local GameSession = require("GameSession")
local mySession = nil
local GS = require("plugin.gamesparks")
local gsrt = GS.getRealTimeServices()
local data = GS.getRTData().new()
local obj2
local obj
local myObjBall

--------------------------------------------
-- Detect if multitouch is supported
if not system.hasEventSource( "multitouch" ) then

	-- Inform that multitouch is not supported
	local shade = display.newRect( mainGroup, display.contentCenterX, display.contentHeight-display.screenOriginY-18, display.actualContentWidth, 36 )
	shade:setFillColor( 0, 0, 0, 0.7 )
	local msg = display.newText( mainGroup, "Multitouch events not supported on this platform", display.contentCenterX, shade.y, appFont, 13 )
	msg:setFillColor( 1, 0, 0.2 )
else

	-- Activate multitouch
	system.activate( "multitouch" )
	isMultitouchEnabled = true
end

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX


-- Touch handling function
local function onTouch( event )

	local obj = event.target
	local phase = event.phase

	if ( "began" == phase ) then

		-- Make target and its label the top-most objects
		obj:toFront()
		obj.label:toFront()

		-- Set focus on the object based on the unique touch ID, and if multitouch is enabled
		if ( isMultitouchEnabled == true ) then
			display.currentStage:setFocus( obj, event.id )
		else
			display.currentStage:setFocus( obj )
		end
		-- Spurious events can be sent to the target, for example the user presses
		-- elsewhere on the screen and then moves the finger over the target;
		-- to prevent this, we add this flag and only move the target when it's true
		obj.isFocus = true

		-- Store initial position
		obj.x0 = event.x - obj.x
		obj.y0 = event.y - obj.y

	elseif obj.isFocus then

		if ( "moved" == phase ) then

			-- Make object move; we subtract "obj.x0" and "obj.y0" so that moves are relative
			-- to the initial touch point rather than the object snapping to that point
			obj.x = event.x - obj.x0
			obj.y = event.y - obj.y0
			--get errors when sending vector2
			--data:SetVector2(2,{x = obj.x, y = obj.y})
			data:setRTVector(2, {x = obj.x, y = obj.y,z = 0,w = 0})
			--data:setLong(1, obj.x)
			mySession.session:sendRTData(1, gsrt.deliveryIntent.RELIABLE, data, {})

			-- Update/move object label
			obj.label.text = string.format("%0.0f",obj.x)..", "..string.format("%0.0f",obj.y)
			obj.label.x = obj.x
			obj.label.y = obj.y-(obj.height/2)-14

			-- Gradually show the shape's stroke depending on how much pressure is applied
			if ( event.pressure ) then
				obj:setStrokeColor( 1, 1, 1, event.pressure )
			end

		elseif ( "ended" == phase or "cancelled" == phase ) then

			-- Release focus on the object
			if ( isMultitouchEnabled == true ) then
				display.currentStage:setFocus( obj, nil )
			else
				display.currentStage:setFocus( nil )
			end
			obj.isFocus = false

			obj:setStrokeColor( 1, 1, 1, 0 )
		end
	end
	return true
end

--can't think of better name :/
local function createBalls(matchData)
	-- Data table for position, radius, and color of objects
local objectData  = { x=160, y=100, radius=24, r=1, g=0, b=0.1 }



-- create ball that 

	-- Create object
	obj = display.newCircle( mainGroup, objectData.x, objectData.y, objectData.radius )
	obj:setFillColor( objectData.r, objectData.g, objectData.b )
	obj.isDragObject = true

	-- Set stroke color/width (used for indicating pressure touch)
	obj:setStrokeColor( 1, 1, 1, 0 )
	obj.strokeWidth = 4

	-- Create label to show x/y of object
	obj.label = display.newText( mainGroup, string.format("%0.0f",obj.x)..", "..string.format("%0.0f",obj.y), obj.x, objectData.y-(obj.height/2)-14, appFont, 12 )
	obj.label:setFillColor( 0.8 )



	local object2Data  = { x=20, y=50, radius=24, r=0, g=0, b=1 }
		-- Create object
	obj2 = display.newCircle( mainGroup, object2Data.x, object2Data.y, object2Data.radius )
	obj2:setFillColor( object2Data.r, object2Data.g, object2Data.b )
	obj2.isDragObject = true

	-- Set stroke color/width (used for indicating pressure touch)
	obj2:setStrokeColor( 1, 1, 1, 0 )
	obj2.strokeWidth = 4

	-- Create label to show x/y of object
	obj2.label = display.newText( mainGroup, string.format("%0.0f",obj2.x)..", "..string.format("%0.0f",obj2.y), obj2.x, object2Data.y-(obj2.height/2)-14, appFont, 12 )
	obj2.label:setFillColor( 0.8 )

     -- sort out peers and ball colors 
    local peer1Id = matchData[1]["data"]["id"]
    if peer1Id == myPlayerId  then
        myObjBall = "obj"
   		obj:addEventListener( "touch", onTouch)
	else
		myObjBall = "obj2"
		obj2:addEventListener("touch", onTouch)
    end

end

local function getAccountDetails()
    local accountDetails = requestBuilder.createAccountDetailsRequest()
    accountDetails:send(function(AccountDetailsResponse)
        --for key,value in pairs(AccountDetailsResponse) do print(key,value) end
        ---myPlayerId = AccountDetailsResponse:getUserId
        print_r(AccountDetailsResponse)
        --Get currencies table, loop through it, and print the values in it
   		local vCurrs = AccountDetailsResponse:getCurrencies()
   		print_r(vCurrs)
    	---print("Currencies: ")
    	--for vCurr, value in pairs(vCurrs) do
     	-- print(vCurr.." "..value)
        --end
        myPlayerId = AccountDetailsResponse["data"]["userId"]
        name =  AccountDetailsResponse["data"]["displayName"]
        print(name)

    end)

end

local function onMatchMakeRelease()

	--getAccountDetails()
	local MatchmakingBuilder = gs.getRequestBuilder()
	local MatchmakingRequest = MatchmakingBuilder.createMatchmakingRequest()
	MatchmakingRequest:setSkill(1)
    local shortCode = 'nim'
	MatchmakingRequest:setMatchShortCode(shortCode)
    MatchmakingRequest:send(function(MatchmakingResponse)
	end)
    print("look for match")
	return true	-- indicates successful touch
end
local function sendChallenge(peer2)

end
--set up match found listener
local function onMatchFoundMessage(MatchFoundMessage)

    print("Match id "..MatchFoundMessage:getMatchId())
     --  local myTable =  {}
    local myTable = MatchFoundMessage:getParticipants()
    ---print(tostring(myTable))
    print_r(myTable);
    createBalls(myTable)


    mySession = GameSession.new(MatchFoundMessage:getAccessToken(), MatchFoundMessage:getHost(), MatchFoundMessage:getPort())
    

    --RT get Packet

	-- Set the new callback depending on the packets you wish to recieve
	mySession.onPacketCB = function(packet)
	-- Choose what to do with a packet depending on its opCode
		if packet.opCode == 1 then
		-- Use packet.data to access the data in your packet and reference the type and index position of the variable
		   local otherPlayerPos = packet.data:getRTVector(2)
		    if myObjBall == "obj" then
   	    		obj2.x = otherPlayerPos.x
   	    		obj2.y = otherPlayerPos.y
   	    		obj2.label.text = string.format("%0.0f",obj2.x)..", "..string.format("%0.0f",obj2.y)
				obj2.label.x = obj2.x
				obj2.label.y = obj2.y-(obj2.height/2)-14
			else
				obj.x = otherPlayerPos.x
   	    		obj.y = otherPlayerPos.y
   	    		obj.label.text = string.format("%0.0f",obj.x)..", "..string.format("%0.0f",obj.y)
				obj.label.x = obj.x
				obj.label.y = obj.y-(obj.height/2)-14
			end

		end

	end


end

local function onMatchNotFoundMessage(MatchNotFoundMessage)
    print("NO Match for you")
end

--update function
local function updateListener()
-- If session is instantiated
  if mySession then
  --Update RT Session
    mySession.session:update()

  end

end


listener.setMatchFoundMessageHandler(onMatchFoundMessage)
listener.setMatchNotFoundMessageHandler(onMatchNotFoundMessage)
Runtime:addEventListener("enterFrame", updateListener)
function scene:create( event )
	print("IN LEVEL 1 WOO!")
	getAccountDetails()
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	 --getAccountDetails()

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()


	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( .5 )
	
	-- make a crate (off-screen), position it, and rotate slightly
	--local crate = display.newImageRect( "crate.png", 90, 90 )
	--crate.x, crate.y = 160, -100
	--crate.rotation = 15
	
	-- add physics to the crate
	--physics.addBody( crate, { density=1.0, friction=0.3, bounce=0.3 } )
	
	-- create a grass object and add physics (with custom shape)
	local grass = display.newImageRect( "grass.png", screenW, 82 )
	grass.anchorX = 0
	grass.anchorY = 1
	--  draw the grass at the very bottom of the screen
	grass.x, grass.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )


	-- create a widget button (which will loads level1.lua on release)
	matchBtn = widget.newButton{
		label="MATCH",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onMatchMakeRelease;
		--getAccountDetails()	-- event listener function
	}
	matchBtn.x = display.contentCenterX
	matchBtn.y = display.contentHeight -125
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( grass)
	--sceneGroup:insert( crate )
	sceneGroup:insert(matchBtn)
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		--
		composer.removeScene( "LogInMenu")
		composer.removeScene( "regMenu")
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
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
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene