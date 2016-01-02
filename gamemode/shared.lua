GM.Name = "The Ship"
GM.Author = "Richard Stöckl"
GM.Email = "richard.stoeckl@aon.at"
GM.Website = "N/A"

CONF = {}

CONF.RoundTime = 20
CONF.PrepareTime = 10

CONF.MinPlayers = 2

R_STATE = {}

R_STATE.PREPARING = 0
R_STATE.HUNTING = 1
R_STATE.KILLED = 2
R_STATE.FINISHED = 3
R_STATE.PREPARING = 4
R_STATE.JOIN = 5

function GM:Initialize()
end