local ASSET_URL = "http://www.roblox.com/asset?id="
local Animationids
Animationids = {
	["BombHold"] = {
		[Enum.HumanoidRigType.R6] = ASSET_URL.."94861246",
		[Enum.HumanoidRigType.R15] = ASSET_URL.."2016146879",
	},
	["BombThrow"] = {
		[Enum.HumanoidRigType.R6] = ASSET_URL.."94861252",
		[Enum.HumanoidRigType.R15] = ASSET_URL.."2016149562",
	},
	["BroomIdle"] = {
		[Enum.HumanoidRigType.R6] = ASSET_URL.."101074752",
		[Enum.HumanoidRigType.R15] = ASSET_URL.."2016194803",
	},
	["BroomWhack"] = {
		[Enum.HumanoidRigType.R6] = ASSET_URL.."101078539",
		[Enum.HumanoidRigType.R15] = ASSET_URL.."2016197675",
	},
	["ReflectorActivate"] = {
		[Enum.HumanoidRigType.R6] = ASSET_URL.."94190213",
		[Enum.HumanoidRigType.R15] = ASSET_URL.."2016204897",
	},
	["RocketLauncherFireAndReload"] = {
		[Enum.HumanoidRigType.R6] = ASSET_URL.."94771598",
		[Enum.HumanoidRigType.R15] = ASSET_URL.."1937739969"
	},
	["SlingshotEquip"] = {
		[Enum.HumanoidRigType.R6] = ASSET_URL.."94123357",
		[Enum.HumanoidRigType.R15] = ASSET_URL.."2016224711",
	},
	["SlingshotShoot"] = {
		[Enum.HumanoidRigType.R6] = ASSET_URL.."94126022",
		[Enum.HumanoidRigType.R15] = ASSET_URL.."2016213090",
	},
	["SuperballEquip"] = {
		[Enum.HumanoidRigType.R6] = ASSET_URL.."94156535",
		[Enum.HumanoidRigType.R15] = ASSET_URL.."2016244952",
	},
	["SuperballUnequip"] = {
		[Enum.HumanoidRigType.R6] = ASSET_URL.."94156580",
	},
	["SuperballIdle"] = {
		[Enum.HumanoidRigType.R6] = ASSET_URL.."94156486",
		[Enum.HumanoidRigType.R15] = ASSET_URL.."2016239591",
	},
	["SuperballThrow"] = {
		[Enum.HumanoidRigType.R6] = ASSET_URL.."94157627",
		[Enum.HumanoidRigType.R15] = ASSET_URL.."2016242911",
	},
	["SwordEquip"] = {
		[Enum.HumanoidRigType.R6] = ASSET_URL.."94160581",
		[Enum.HumanoidRigType.R15] = ASSET_URL.."2016251903",
	},
	["SwordUnequip"] = {
		[Enum.HumanoidRigType.R6] = ASSET_URL.."94095929",
		[Enum.HumanoidRigType.R15] = ASSET_URL.."2016265405",
	},
	["SwordIdle"] = {
		[Enum.HumanoidRigType.R6] = ASSET_URL.."94108418",
		[Enum.HumanoidRigType.R15] = ASSET_URL.."2016254882",
	},
	["SwordSlash"] = {
		[Enum.HumanoidRigType.R6] = ASSET_URL.."94161088",
		[Enum.HumanoidRigType.R15] = ASSET_URL.."2016260994",
	},
	["SwordThrust"] = {
		[Enum.HumanoidRigType.R6] = ASSET_URL.."94161333",
		[Enum.HumanoidRigType.R15] = ASSET_URL.."2016262978",
	},
	["SwordOverhead"] = {
		[Enum.HumanoidRigType.R6] = ASSET_URL.."94160738",
		[Enum.HumanoidRigType.R15] = ASSET_URL.."2016256809",
	},
	["FlagPlant"] = {
		[Enum.HumanoidRigType.R6] = ASSET_URL.."74897796",
		[Enum.HumanoidRigType.R15] = ASSET_URL.."2016269660",
	}
}
local AnimationSettings = {
	["BombHold"] = {
		FadeTime = 0,
		Weight = 1,
		Speed = 2,
	},
	["BroomWhack"] = {
		FadeTime = 0,
		Weight = 1,
		Speed = 10,
	},
	["ReflectorActivate"] = {
		FadeTime = 0.1,
		Weight = 1,
		Speed = 6,
	},
	["RocketLauncherFireAndReload"] = {
		FadeTime = 0.1,
		Weight = 1,
		Speed = 1.5,
	},
	["FlagPlant"] = {
		Speed = 0.5,
	}
}
local AnimationPlayer = {}
local Tool = script.Parent.Parent
local AnimationCache = {}
local function GetAnimation(AnimationId)
	if not AnimationCache[AnimationId] then
		local Animation = Instance.new("Animation")
		Animation.AnimationId = AnimationId
		AnimationCache[AnimationId] = Animation
	end
	return AnimationCache[AnimationId]
end
function AnimationPlayer:PlayAnimation(AnimationName)
	local Character = Tool.Parent
	if Character then
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		if Humanoid then
			local AnimationGroup = Animationids[AnimationName]
			if AnimationGroup then
				local Animationid = AnimationGroup[Humanoid.RigType]
				if Animationid then
					local LoadedAnimation = Humanoid:LoadAnimation(GetAnimation(Animationid))
					local AnimationData = AnimationSettings[AnimationName] or {}
					LoadedAnimation:Play(AnimationData.FadeTime,AnimationData.Weight,AnimationData.Speed)
					return LoadedAnimation
				end
			else
				warn("Missing animation name: "..tostring(AnimationName))
			end
		end
	end
end
return AnimationPlayer

