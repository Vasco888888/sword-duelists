
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ServerStorage = game:GetService("ServerStorage")

local MapsFolder = ServerStorage:WaitForChild("Maps")

local Status = ReplicatedStorage:WaitForChild("Status")

local GameLenght = 90

local prize = 1



while true do


	
	Status.Value = "Waiting for players..."
	
	repeat task.wait(1) until game.Players.NumPlayers >= 2
	
	Status.Value = "Game starting soon!"
	
	task.wait(20)
	
	local plrs = {}
	
	for i, player in game.Players:GetPlayers() do
		if player then
			table.insert(plrs,player) 
		end
	end
	
	
	task.wait(2)
	
	local AvailableMaps = MapsFolder:GetChildren()
	   
	local ChosenMap = AvailableMaps[math.random(#AvailableMaps)]
	
	Status.Value = ChosenMap.Name.." Chosen"
	
	local ClonedMap = ChosenMap:Clone()
	ClonedMap.Parent = workspace
	
	
	
	local SpawnPoints = ClonedMap:FindFirstChild("SpawnPoints")
	
	if not SpawnPoints then
		print ("Spawnpoints not found!")
	end
	
	local AvailableSpawnPoints = SpawnPoints:GetChildren()
	
	for i, player in plrs do
		if player then
			character = player.Character
			
			if character then
				
				
				character:FindFirstChild("HumanoidRootPart").CFrame = AvailableSpawnPoints[1].CFrame + Vector3.new(0,10,0)
				
				table.remove(AvailableSpawnPoints,1)
				
				
				
				local Sword = ServerStorage.Sword:Clone()
				Sword.Parent = player.Backpack
				
				local GameTag = Instance.new("BoolValue")
				GameTag.Name = "GameTag"
				GameTag.Parent = player.Character
			else
				
				if not player then
					table.remove(plrs,i)
				end
			end
		end
	end
	
	Status.Value = "Game started!"
	
	task.wait(2)
	
	for i = GameLenght,0,-1 do
		
		for x, player in plrs do
			if player then
				
				character = player.Character
				
				if not character then
					
					table.remove(plrs,x)
				else
					if character:FindFirstChild("GameTag") then
						
						print(player.Name.." is still in the game!")
					else
						
						table.remove(plrs,x)
						print(player.Name.." has been removed!")
					end
				end
			else
				table.remove(plrs,x)
				print(player.Name.." has been removed!")
			
			end
		end

	
	Status.Value = "There are "..i.." seconds remaining | "..#plrs.." players left"

	if #plrs == 1 then
		
		Status.Value = "The winner is "..plrs[1].Name
			plrs[1].leaderstats.Victories.Value = plrs[1].leaderstats.Victories.Value + prize
		break
	elseif #plrs == 0 then
		Status.Value = "Nobody won!"
		break
	elseif i == 0 then
	    Status.Value = "Game Over!"
		break
		
	end
	
	task.wait(1)

end

print("End of the game")

task.wait(2)

for i, player in game.Players:GetPlayers() do
	character = player.Character
	
	if not character then
		
	else
		if character:FindFirstChild("GameTag") then
			character.GameTag:Destroy()
		end
		
		if player.Backpack:FindFirstChild("Sword") then
			player.Backpack.Sword:Destroy()
		end
		
		if character:FindFirstChild("Sword") then
			character.Sword:Destroy()
		end
	
	end		
	player:LoadCharacter()
	   
end
	
	ClonedMap:Destroy()
	
	Status.Value = "Game ended"
	
	task.wait(3)
end

