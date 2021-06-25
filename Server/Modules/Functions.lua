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

            MySQL.Async.execute('INSERT INTO players (name, license, steam, rank, money, identity, job, position) VALUES (@name, @license, @steam, @rank, @money, @identity, @job, @position)', {
                ['@name'] = GetPlayerName(this.src),
                ['@steam'] = this:Identifier().getSteam(),
                ['@license'] = this:Identifier().getLicense(),
                ['@rank'] = Config.Default.Rank,
                ['@money'] = json.encode(Config.Default.Money),
                ['@identity'] = json.encode({}),
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
                    local player = createPlayer(this.src, { steam = this:Identifier().getSteam(), license = this:Identifier().getLicense() }, data.rank, data.job, data.money, data.position)

                    FX.Players[this.src] = player
                end
            end)
        end

        return connection
    end

    return this
end