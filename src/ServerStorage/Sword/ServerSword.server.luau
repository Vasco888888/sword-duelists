local Tool = script.Parent
local Handle = Tool:WaitForChild("Handle")
local UnsheathSound = Handle:WaitForChild("UnsheathSound")
local SlashSound = Handle:WaitForChild("SlashSound")
local LungeSound = Handle:WaitForChild("LungeSound")
local OverheadSound = Handle:WaitForChild("OverheadSound")
local HitSound = Handle:WaitForChild("HitSound")
local Resources = require(script.Parent:WaitForChild("Resources"))
local RemoteEventCreator = require(Resources:GetResource("RemoteEventCreator"))
local PlayerDamager = require(Resources:GetResource("PlayerDamager"))
local Configuration = require(Resources:GetResource("Configuration"))
local WALK_SPEED_BUFF = Configuration.WALK_SPEED_BUFF
local SLASH_DAMAGE = Configuration.SLASH_DAMAGE
local LUNGE_DAMAGE = Configuration.LUNGE_DAMAGE
local OVERHEAD_SLASH_DAMAGE = Configuration.OVERHEAD_SLASH_DAMAGE
local CAN_CUT_TREES = Configuration.CAN_CUT_TREES
local TREE_NAMES = Configuration.TREE_NAMES
local SwingSwordEvent = RemoteEventCreator:CreateRemoteEvent("SwingSword")
local CurrentPlayer,CurrentCharacter,CurrentHumanoid
local HitCharacters
local CurrentDamage = 0
local Equipped = false
local ToolEnabled = true
local TreeNameMap = {}
for _,Name in TREE_NAMES do
	TreeNameMap[Name] = true
end
local function SwordUp()
	Tool.GripForward = Vector3.new(1,0,0)
	Tool.GripRight = Vector3.new(0,0,1)
	Tool.GripUp = Vector3.new(0,1,0)
end
local function SwordOut()
	Tool.GripForward = Vector3.new(0,-1,0)
	Tool.GripRight = Vector3.new(0,0,1)
	Tool.GripUp = Vector3.new(-1,0,0)
end
local function CheckInTreeModel(Ins)
	while Ins and Ins ~= game do
		if Ins:FindFirstChild("Humanoid") then return false end
		if TreeNameMap[Ins.Name] then return true end
		Ins = Ins.Parent
	end
	return false
end
function SwordHit(TouchPart)
	if not TouchPart.Parent then return end
	if not CurrentPlayer then return end
	if not CurrentHumanoid then return end
	local Character = TouchPart.Parent
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if Humanoid and Humanoid ~= CurrentHumanoid and HitCharacters and not HitCharacters[Character] and CurrentHumanoid.Health > 0 and  CurrentDamage > 0 then
		HitCharacters[Character] = true
		PlayerDamager:DamageHumanoid(CurrentPlayer,Humanoid,CurrentDamage,"Sword")
	elseif CAN_CUT_TREES and not Tool.Enabled and CheckInTreeModel(TouchPart) then
		TouchPart:BreakJoints()
	end
end
SwingSwordEvent.OnServerEvent:Connect(function(Player,SwordMode)
	if Player == CurrentPlayer and ToolEnabled and SwordMode then
		ToolEnabled = false
		Tool.Enabled = false
		HitCharacters = {[Player.Character] = true}
		if SwordMode == 1 then
			CurrentDamage = SLASH_DAMAGE
			SlashSound:Play()
			task.wait(0.6)
		elseif SwordMode == 2 then
			CurrentDamage = LUNGE_DAMAGE
			LungeSound:Play()
			task.wait(0.45)
			SwordOut()
			task.wait(0.2)
			SwordUp()
		elseif SwordMode == 3 then
			CurrentDamage = OVERHEAD_SLASH_DAMAGE
			OverheadSound:Play()
			task.wait(0.6)
		end
		CurrentDamage = 0
		HitCharacters = nil
		ToolEnabled = true
		Tool.Enabled = true
	end
end)
Tool.Equipped:Connect(function()
	if not Equipped then
		Equipped = true
		CurrentCharacter = Tool.Parent
		CurrentHumanoid = CurrentCharacter:FindFirstChildOfClass("Humanoid")
		CurrentPlayer = game.Players:GetPlayerFromCharacter(CurrentCharacter)
		CurrentHumanoid.WalkSpeed = CurrentHumanoid.WalkSpeed + WALK_SPEED_BUFF
		task.delay(0.55, function()
			if not Equipped then return end
			UnsheathSound:Play()
		end)
	end
end)
Tool.Unequipped:Connect(function()
	if Equipped then
		Equipped = false
		CurrentHumanoid.WalkSpeed = CurrentHumanoid.WalkSpeed - WALK_SPEED_BUFF
		CurrentCharacter = nil
		CurrentHumanoid = nil
		CurrentPlayer = nil
		UnsheathSound:Stop()
		SlashSound:Stop()
		LungeSound:Stop()
		OverheadSound:Stop()
		HitSound:Stop()
	end
end)
Handle.Touched:Connect(SwordHit)

