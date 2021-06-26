function createPlayer(source, data, rank, job, money, inventory, position)
    local this = {}

    this.source = source
    this.data = data
    this.rank = rank
    this.job = json.decode(job)
    this.money = json.decode(money)
    this.inventory = json.decode(inventory)
    this.position = json.decode(position)

    -- Data Functions
    this.Data = function()
        local data = {}

        data.save = function(cb)
            MySQL.Async.execute('UPDATE players SET money = @money, rank = @rank, position = @position, job = @job WHERE steam = @steam', {
                ['@steam'] = this.data.steam,
                ['@money'] = json.encode(this.money),
                ['@rank'] = this.rank,
                ['@position'] = json.encode(this.position),
                ['@job'] = json.encode(this.job)
            }, function(rows)
                if cb then
                    return cb(true)
                else
                    return true
                end
            end)

            if cb then
                return cb(false)
            else
                return false
            end
        end

        return data
    end

    -- Global Functions
    this.Global = function()
        local global = {}

        global.triggerEvent = function(name, source, ...)
            TriggerClientEvent(name, source, ...)
        end

        return global
    end

    -- Player Functions
    this.Player = function()
        local player = {}

        player.getSource = function()
            return this.source
        end

        player.getName = function()
            return GetPlayerName(this.source)
        end

        player.getSteam = function()
            return this.data.steam
        end

        player.getLicense = function()
            return this.data.license
        end

        return player
    end

    -- Rank Functions
    this.Rank = function()
        local rank = {}

        rank.get = function()
            return this.rank
        end

        rank.check = function(rank, cb)
            if Config.Ranks[rank] <= Config.Ranks[this.rank] then
                if cb then
                    return cb(true)
                else
                    return true
                end
            else
                if cb then
                    return cb(false)
                else
                    return false
                end
            end
        end

        rank.set = function(rank, cb)
            this.rank = rank

            this:Data().save()
            this:Global().triggerEvent('fx:setRank', this.source, this.rank)

            if cb then
                return cb(true)
            end
        end

        rank.remove = function(cb)
            this.rank = Config.Default.Rank

            this:Data().save()

            if cb then
                return cb(true)
            else
                return true
            end
        end

        return rank
    end

    -- Inventory Functions
    this.Inventory = function()
        local inventory = {}

        inventory.get = function()
            return this.inventory
        end
        
        return inventory
    end

    -- Cash Functions
    this.Cash = function()
        local cash = {}

        cash.getCash = function()
            return this.money.cash
        end

        cash.addCash = function(v, r, cb)
            this.money.cash = this.money.cash + v

            this:Data().save()

            if cb then
                return cb(true)
            end

            return cb(false)
        end

        cash.removeCash = function(v, r, cb)
            if this.money.cash - v >= 0 then
                this.money.cash = this.money.cash - v
    
                this:Data().save()
    
                if cb then
                    return cb(true)
                end
    
                return cb(false)
            else
                return cb(false)
            end
        end

        return cash
    end

    -- Bank Functions
    this.Bank = function()
        local bank = {}

        bank.getBank = function()
            return this.money.bank
        end

        bank.addBank = function(v, r, cb)
            this.money.bank = this.money.bank + v
            
            this:Data().save()

            if cb then
                return cb(true)
            end

            return cb(false)
        end

        bank.removeBank = function(v, r, cb)
            if this.money.bank - v >= 0 then
                this.money.bank = this.money.bank - v
    
                this:Data().save()
    
                if cb then
                    return cb(true)
                end
    
                return cb(false)
            else
                return cb(false)
            end
        end

        return bank
    end

    -- Job Functions
    this.Job = function()
        local job = {}

        job.getJob = function(cb)
            if cb then
                return cb(this.job)
            else
                return this.job
            end
        end

        job.setJob = function(job, rank, cb)
            if Config.Jobs[job] and Config.Jobs[job].ranks[rank] then
                this.job.name = job
                this.job.label = Config.Jobs[job].label

                this.job.rank_level = rank
                this.job.rank_label = Config.Jobs[job].ranks[rank].label
                this.job.rank_salary = Config.Jobs[job].ranks[rank].salary

                this:Global().triggerEvent('fx:setJob', this.source, this.job)

                if cb then
                    return cb(true)
                else
                    return true
                end
            else
                if cb then
                    return cb(false)
                else
                    return false
                end
            end
        end

        return job
    end

    -- Position Functions
    this.Position = function()
        local position = {}

        position.get = function()
            return this.position
        end

        return position
    end

    return this
end