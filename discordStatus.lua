-- Discord rich presence script developed by: iLucasLP

discordStatus = {}

--Configuration

local serverName = "MuOnline Server Name" -- Your Server name
local customDescription = "Main Server" -- custom text next to the character name
local noGuildText = "No Guild" -- description for characters who do not have a guild

local applicationId = "APPID" -- Discord APP ID
local discordSmallImage = "pp" -- Discord app image name
local discordLargeImage = "pp" -- Discord app image name



local ffi = require("ffi")

-- Load lib discord-rpc.dll
ffi.cdef[[
    typedef struct DiscordRichPresence {
        const char* state;
        const char* details;
        int64_t startTimestamp;
        int64_t endTimestamp;
        const char* largeImageKey;
        const char* largeImageText;
        const char* smallImageKey;
        const char* smallImageText;
        const char* partyId;
        int partySize;
        int partyMax;
        const char* matchSecret;
        const char* joinSecret;
        const char* spectateSecret;
        int8_t instance;
    } DiscordRichPresence;

    typedef struct DiscordEventHandlers {
        void (*ready)(void);
        void (*disconnected)(int errorCode, const char* message);
        void (*errored)(int errorCode, const char* message);
        void (*joinGame)(const char* joinSecret);
        void (*spectateGame)(const char* spectateSecret);
        void (*joinRequest)(void);
    } DiscordEventHandlers;

    void Discord_Initialize(const char* applicationId,
                            DiscordEventHandlers* handlers,
                            int autoRegister,
                            const char* optionalSteamId);

    void Discord_Shutdown(void);

    void Discord_RunCallbacks(void);

    void Discord_UpdatePresence(const DiscordRichPresence* presence);

    void Discord_ClearPresence(void);
]]

local discordRPC = ffi.load("discord-rpc")

function getLocation(index)
    local locations = {
        [0]  = "Lorencia",
		[1]	 = "Dungeon",
		[2]	 = "Davias",
		[3]	 = "Noria",
		[4]	 = "Lost Tower",
		[5]	 = "Exilie",
		[6]	 = "Arena",
		[7]	 = "Atlans",
		[8]	 = "Tarkan",
		[9]	 = "Devil Square",
		[32] = "Devil Square",
		[10] = "Icarus",
		[11] = "Blood Castle I",
		[12] = "Blood Castle II",
		[13] = "Blood Castle III",
		[14] = "Blood Castle IV",
		[15] = "Blood Castle V",
		[16] = "Blood Castle VI",
		[17] = "Blood Castle VII",
		[52] = "Blood Castle VIII",
		[18] = "Chaos Castle 1",
		[19] = "Chaos Castle 2",
		[20] = "Chaos Castle 3",
		[21] = "Chaos Castle 4",
		[22] = "Chaos Castle 5",
		[23] = "Chaos Castle 6",
		[53] = "Chaos Castle 7",
		[24] = "Kalima 1",
		[25] = "Kalima 2",
		[26] = "Kalima 3",
		[27] = "Kalima 4",
		[28] = "Kalima 5",
		[29] = "Kalima 6",
		[36] = "Kalima 7",
		[30] = "Valle Of Loren",
		[31] = "Land Of Trial",
		[33] = "Aida",
		[34] = "Crywolf",
		[37] = "Kanturu",
		[38] = "Kanturu Remain",
		[40] = "Silent",
		[41] = "Barracks",
		[42] = "Refuge",
		[45] = "Illusion Temple",
		[46] = "Illusion Temple",
		[47] = "Illusion Temple",
		[48] = "Illusion Temple",
		[49] = "Illusion Temple",
		[50] = "Illusion Temple",
		[51] = "Elbeland",
		[56] = "Swamp of Peace",
		[57] = "Raklion",
		[63] = "Vulcanus",
		[79] = "Loren Market",
		[80] = "Karutan"
 
    }
    
    return locations[index] or "Unknown"
end

function getGuild(index) 
	local guildName = GuildGetName(index)

	if guildName == 0 or guildName == -1 or guildName == nil then
		return noGuildText
	else
		return guildName
	end
end

local function UpdateRichPresence()
    -- Define details Rich Presence
    local presence = ffi.new("struct DiscordRichPresence")
    presence.state = string.format('%s - %s', getLocation(UserGetMap()), string.format(customDescription)) -- {CharacterName} - {Custom Description}
    presence.details = string.format('%s [G]: %s', UserGetName(), getGuild(UserGetGuild()))
    presence.largeImageKey = discordLargeImage -- Discord app image
    presence.largeImageText = serverName  --ServerName
    presence.smallImageKey = discordSmallImage -- Discord app image
    presence.smallImageText = serverName --ServerName

    -- Refresh Rich Presence
    discordRPC.Discord_UpdatePresence(presence)
end

-- Init Discord RPC
local function InitDiscordRPC()
    

    local handlers = ffi.new("struct DiscordEventHandlers")
    discordRPC.Discord_Initialize(applicationId, handlers, 1, nil)
end

-- Quit Discord RPC
local function ShutdownDiscordRPC()
    discordRPC.Discord_Shutdown()
end

function discordStatus.Render()
	InitDiscordRPC() -- Init Discord RPC
	UpdateRichPresence() -- Refresh Rich Presence
end

InterfaceController.MainProc(discordStatus.Render)

return discordStatus