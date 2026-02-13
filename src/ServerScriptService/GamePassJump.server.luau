local id = 8858062
game:GetService("MarketplaceService").PromptGamePassPurchaseFinished:Connect(function(plr,ido,purchased)
	if purchased and ido == id then
		plr.Character.Humanoid.JumpPower = 50
	end
end)
game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		if
			game:GetService("MarketplaceService"):UserOwnsGamePassAsync(game.Players[char.Name].UserId,id)then
				char.Humanoid.JumpPower = 100
			end
			end)
end)

