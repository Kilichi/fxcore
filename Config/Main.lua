Config = Config or {}

Config.SavePlayers = 15 -- Time in minutes to save all player data

Config.Default = {
    Rank = 'user',
    Money = { cash = 0, bank = 1500 },
    Position = { x = -1779.68, y = 458.07, z = 133.09, heading = 68.95 }
}

Config.EnablePvp = true -- Active or Desactive server pvp
Config.WantedLevel = false -- Active or Desactive police wanted level

-- Other Configs

Config.Ranks = {
    ['user'] = 0,
    ['mod'] = 1,
    ['admin'] = 2,
    ['developer'] = 3,
    ['root'] = 4
}

Config.Jobs = {
    ['unemployed'] = {
        name = 'unemployed',
        label = 'Civil',
        whitelisted = false,
        ranks = {
            [1] = {
                label = 'Desempleado',
                salary = 30
            },
        },
    },
    ['police'] = {
        name = 'police',
        label = 'Policía',
        whitelisted = true,
        ranks = {
            [1] = {
                label = 'Cadete',
                salary = 500
            },
            [2] = {
                label = 'Novato',
                salary = 800
            },
        },
    },
    ['garbage'] = {
        name = 'garbage',
        label = 'Basurero',
        whitelisted = false,
        ranks = {
            [1] = {
                label = 'Basurero',
                salary = 500
            },
        },
    }
}