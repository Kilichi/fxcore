-- Functions Module (Player)

FX.GetPlayerById = function(source, cb)
    local src = source

    if FX.Players[source] then
        if cb then
            return cb(FX.Players[source])
        else
            return FX.Players[source]
        end
    else
        if cb then
            return cb(nil)
        else
            return nil
        end
    end
end

FX.GetPlayers = function(cb)
    if cb then
        return cb(FX.Players)
    else
        return FX.Players
    end
end

-- Functions Module (Callback)

FX.RegisterCallback = function(name, cb)
    FX.Callbacks[name] = cb
end

FX.UseCallback = function(name, source, cb, ...)
    if FX.Callbacks[name] then
        FX.Callbacks[name](source, cb, ...)
    end
end

-- Functions Module

FX.Functions = function(source)
    local this = {}

    this.src = source

    -- Identifier Functions
    this.Identifier = function()
        local identifier = {}

        identifier.getSteam = function(cb)
            local steam = GetPlayerIdentifiers(this.src)[1]

            if cb then
                return cb(steam)
            else
                return steam
            end
        end

        identifier.getLicense = function(cb)
            local license = GetPlayerIdentifiers(this.src)[2]

            if cb then
                return cb(license)
            else
                return license
            end
        end

        return identifier
    end

    -- Connection Functions
    this.Connection = function()
        local connection = {}

        connection.checkPlayer = function(steam, cb)
            MySQL.Async.fetchAll('SELECT * FROM players WHERE steam = @steam', {
                ['@steam'] = steam
            }, function(result)
                local data = result[1]

                if data then
                    return cb(true)
                else
                    return cb(false)
                end
            end)
        end

        connection.createPlayer = function(cb)
            local job = {}
            job.name = Config.Jobs['unemployed'].name
            job.label = Config.Jobs['unemployed'].label
            
            job.rank_label = Config.Jobs['unemployed'].ranks[1].label
            job.rank_salary = Config.Jobs['unemployed'].ranks[1].salary
            job.rank_level = 1

            MySQL.Async.execute('INSERT INTO players (name, license, steam, rank, money, identity, inventory, job, position) VALUES (@name, @license, @steam, @rank, @money, @identity, @inventory, @job, @position)', {
                ['@name'] = GetPlayerName(this.src),
                ['@steam'] = this:Identifier().getSteam(),
                ['@license'] = this:Identifier().getLicense(),
                ['@rank'] = Config.Default.Rank,
                ['@money'] = json.encode(Config.Default.Money),
                ['@identity'] = json.encode({}),
                ['@inventory'] = json.encode({}),
                ['@job'] = json.encode(job),
                ['@position'] = json.encode(Config.Default.Position)
            }, function(rows)
                return cb(true)
            end)
        end

        connection.addPlayer = function()
            local steam = this:Identifier().getSteam()

            MySQL.Async.fetchAll('SELECT * FROM players WHERE steam = @steam', {
                ['@steam'] = steam
            }, function(result)
                local data = result[1]
                if data then
                    local player = createPlayer(this.src, { steam = this:Identifier().getSteam(), license = this:Identifier().getLicense() }, data.rank, data.job, data.money, data.inventory, data.position)
                    FX.Players[this.src] = player

                    player:Global().triggerEvent('fx:spawned', this.src, {
                        rank = player:Rank().get(),
                        job = player:Job().get(),
                        cash = player:Cash().get(),
                        bank = player:Bank().get(),
                        inventory = player:Inventory().get(),
                        position = player:Position().get()
                    })
                end
            end)
        end

        return connection
    end

    -- Commands Functions
    this.Commands = function()
        local commands = {}
    
        commands.Insert = function(name, func, cb)
            if cb then
                RegisterCommand(name, func)
                FX.Commands[name] = func

                return cb(true)
            else
                return false
            end
        end

        commands.Register = function(name, func, cb)
            local found = false

            for b,c in pairs(FX.Commands) do
                if found then 
                    return
                end

                if b == name then
                    found = true
                end
            end

            if found then
                if cb then
                    return cb(false)
                else
                    return
                end
            end

            this:Commands().Insert(name, func, function(done)
                if done then
                    if cb then
                        return cb(true)
                    else
                        return false
                    end
                end
            end)
        end

        return commands
    end

    return this
end