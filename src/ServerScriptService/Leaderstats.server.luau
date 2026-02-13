local DataStoreService = game:GetService("DataStoreService")
local DataStore = DataStoreService:GetDataStore("VictoriesStats")
game.Players.PlayerAdded:Connect(function(Player)
	local Leaderstats = Instance.new("Folder")
	Leaderstats.Name = "leaderstats"
	Leaderstats.Parent = Player
	local Currency = Instance.new("StringValue")
	Currency.Name = "Victories"
	Currency.Value = DataStore:GetAsync(Player.UserId) or "0"
	Currency.Parent = Leaderstats
end)
game.Players.PlayerRemoving:Connect(function(Player)
	DataStore:SetAsync(Player.UserId, Player.leaderstats.Victories.Value)
end)

