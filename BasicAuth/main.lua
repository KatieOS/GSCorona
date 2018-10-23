-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"
local GS = require("plugin.gamesparks")
--local GSRequest = require('plugin.gamesparks.GSRequest')
--local GSResponse = require('plugin.gamesparks.GSResponse')
--local GSUtils = require('plugin.gamesparks.GSUtils')

local function writeText(string)
  print(string)
end


local function availabilityCallback(isAvailable)
writeText("Availability: " .. tostring(isAvailable) .. "\n")

  if isAvailable then
    --Do something
    local auth = gs.isAuthenticated()
    print(auth)
    
  --[[  if auth == false then
    local requestBuilder = gs.getRequestBuilder()
    local deviceAuth = requestBuilder.createDeviceAuthenticationRequest()

    deviceAuth:setDeviceId(system.getInfo("deviceID"))
    deviceAuth:setDeviceOS("Corona")

    deviceAuth:send(function(authenticationResponse)
        if authenticationResponse:hasErrors() then
            for key,value in pairs(authenticationResponse:getErrors()) do print(key,value) end

        end
        --print("go to game")
        --composer.gotoScene( "level1" )

        end)
	end--]]

   
  end

end

--Create GS Instance
gs = createGS()
--Set the logger for debugging the Responses,Messages and Requests flowning in and out
gs.setLogger(writeText)
--Set API Key
gs.setApiKey("r308383p20gg")
--Set Secret
gs.setApiSecret("oJ7J2RKVb1b5TmNyXMnFABid2zj1klqS")
--Set Credential
gs.setApiCredential("device")
--Set availability callback function
gs.setAvailabilityCallback(availabilityCallback)
--Connect to your game's backend
gs.reset();


-- load menu screen
--set up match found listener
 composer.gotoScene( "menu" )


