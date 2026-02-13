local InputBeganEvent = Instance.new("BindableEvent")
local LongInputBeganEvent = Instance.new("BindableEvent")
local InputEndedEvent = Instance.new("BindableEvent")

local InputHandler = {
	WeaponActivateBegan = LongInputBeganEvent.Event,
	WeaponActivateEnded = InputEndedEvent.Event,
	WeaponActivated = InputBeganEvent.Event,
}

local Tool = script.Parent.Parent
local Camera = game.Workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")

local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

local EventsToDisconnect = {}

function CastRay(StartPos,Direction,Length)
	local Hit,EndPos = game.Workspace:FindPartOnRay(Ray.new(StartPos,Direction * Length))
	if Hit then
		if (not Tool.Parent or Hit:IsDescendantOf(Tool.Parent)) or Hit.Transparency > 0.9 then
			return CastRay(EndPos + (Direction * 0.01),Direction,Length - ((StartPos - EndPos).magnitude))
		end
	end
	
	return EndPos
end

local function Get3DPosition(X,Y)
	local MouseRay = Camera:ScreenPointToRay(X,Y,1000)
	local EndPos = MouseRay.Origin + MouseRay.Direction
	return CastRay(Camera.CFrame.p,(EndPos - Camera.CFrame.p).unit,1000)
end

local function DisconnectEvents()
	if not Tool.Parent then
		for _,Event in EventsToDisconnect do
			Event:Disconnect()
		end
		EventsToDisconnect = {}
	end
end

local ControllerDown = false
table.insert(EventsToDisconnect,UserInputService.InputChanged:Connect(function(Input,Processed)
	if Processed then return end
	local Character = Player.Character
	if not Character then return end
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not Humanoid or Humanoid.Health <= 0 then return end
	
	
	DisconnectEvents()
	
	
	if (Input.UserInputType == Enum.UserInputType.Gamepad1 or Input.UserInputType == Enum.UserInputType.Gamepad2) and Input.KeyCode == Enum.KeyCode.ButtonR2 then
		local ShouldBeDown = (Input.Position.Z > 0.8)
		
		if ShouldBeDown and not ControllerDown then
			
			ControllerDown = true
			
			if VRService.VREnabled then
				
				
				local CameraCF = Camera.CFrame
				local Position = CastRay(CameraCF.p,CameraCF.lookVector,1000)
				LongInputBeganEvent:Fire(Position)
				InputBeganEvent:Fire(Position)
			else
				
				local Position = Get3DPosition(Mouse.X,Mouse.Y)
				LongInputBeganEvent:Fire(Position)
				InputBeganEvent:Fire(Position)
			end
		elseif not ShouldBeDown and ControllerDown then
			
			ControllerDown = false
			
			if VRService.VREnabled then
				
				
				local CameraCF = Camera.CFrame
				InputEndedEvent:Fire(CastRay(CameraCF.p,CameraCF.lookVector,1000))
			else
				
				InputEndedEvent:Fire(Get3DPosition(Mouse.X,Mouse.Y))
			end
		end
	end
end))

table.insert(EventsToDisconnect,UserInputService.InputBegan:Connect(function(Input,Processed)
	if Processed then return end
	local Character = Player.Character
	if not Character then return end
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not Humanoid or Humanoid.Health <= 0 then return end
	
	
	DisconnectEvents()
	
	
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		local Position = Get3DPosition(Input.Position.X,Input.Position.Y)
		LongInputBeganEvent:Fire(Position)
		
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			InputBeganEvent:Fire(Position)
		end
	end
end))

table.insert(EventsToDisconnect,UserInputService.TouchTap:Connect(function(Positions,Processed)
	if Processed then return end
	local Character = Player.Character
	if not Character then return end
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not Humanoid or Humanoid.Health <= 0 then return end
	
	
	DisconnectEvents()
	
	local Position = Positions[1]
	if Position then
		InputBeganEvent:Fire(Get3DPosition(Position.X,Position.Y))
	end
end))

table.insert(EventsToDisconnect,UserInputService.InputEnded:Connect(function(Input)
	
	DisconnectEvents()
	
	
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		InputEndedEvent:Fire(Get3DPosition(Input.Position.X,Input.Position.Y))
	end
end))

return InputHandler

