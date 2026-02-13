local PlayerDamager = {}

local Debris = game:GetService("Debris")

function PlayerDamager:CanDamageHumanoid(DamagingPlayer,Humanoid)
	local HitPlayer = game.Players:GetPlayerFromCharacter(Humanoid.Parent)
	if HitPlayer and DamagingPlayer ~= HitPlayer and HitPlayer.TeamColor == DamagingPlayer.TeamColor and not HitPlayer.Neutral then
		return false
	end
	
	return true
end

function PlayerDamager:DamageHumanoid(DamagingPlayer,Humanoid,Damage,ToolName)
	
	if not PlayerDamager:CanDamageHumanoid(DamagingPlayer,Humanoid) or not Humanoid.Parent then
		return
	end
	
	
	Humanoid:TakeDamage(Damage)
	
	
	local CreatorTag = Instance.new("ObjectValue")
	CreatorTag.Name = "creator"
	CreatorTag.Value = DamagingPlayer
	CreatorTag.Parent = Humanoid
	Debris:AddItem(CreatorTag,3)
end

return PlayerDamager

