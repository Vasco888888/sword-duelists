game.Players.PlayerAdded:Connect(function(player)
	
	player.CharacterAdded:Connect(function(character)
		character.Humanoid.Died:Connect(function()
	
			

			
			
			
			if character.Humanoid and character.Humanoid:FindFirstChild("creator")then
				game.ReplicatedStorage.Status.Value = tostring(character.Humanoid.creator.Value).." defeated "..player.Name
			end
			if character:FindFirstChild("GameTag") then
				character.GameTag:Destroy()
			end
		
		player:LoadCharacter()
		end)
	end)
end)




