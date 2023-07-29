local lua_ver = "Beta"
local lua_log = "v1.1.0"

print("Welcome to Umbral.tech " ..lua_ver)
print("User: " .. user.name)

local Get = menu.find
local AddCheckbox = menu.add_checkbox
local AddSlider = menu.add_slider
local AddCombo = menu.add_selection
local frames = 0
local animTime = global_vars.real_time()

local groups = {info = "Info"}

menu.add_text(groups.info, "Umbral.tech" .. lua_ver .. " " .. lua_log)
menu.add_text(groups.info, "Users: " .. user.name)
menu.add_text(groups.info, "UserID: " .. user.uid)

local hitboxes = {
    [0] = "generic",
    [1] = "head",
    [2] = "chest",
    [3] = "stomach",
    [4] = "left arm",
    [5] = "right arm",
    [6] = "left leg",
    [7] = "right leg",
    [10] = "gear",
}

local reasons = {
    [0] = "Hit",
    [1] = "resolver",
    [2] = "spread",
    [3] = "occlusion",
    [4] = "prediction error",
}

local console = render.create_font("Trebuchet MS", 15, 600, e_font_flags.ANTIALIAS)
local message = nil
local show = false
local time = global_vars.real_time()

local JitterTypes = {"None", "Static", "Center", "Random", "Random plus", "Break"}
local DesyncSides = {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real", "Sway", "Random", "Break"}
local FakelagTypes = {"Static", "Adaptive", "Random", "Break LC"}

local luamenu = {}
luamenu.toggle = menu.add_checkbox("Rage", "Jump Scout")
luamenu.hitchanceslider = menu.add_slider("Rage","hitchance",0, 100 )


local paimon_enable = menu.add_checkbox("Genshin Impact", "Enable gif", false)
local paimon_logs = menu.add_checkbox("Genshin Impact", "Hit logs", false)
local paimon_logs_timer = menu.add_slider("Genshin Impact", "Hit logs timer", 3.0, 12.0)

local enable_clantag = menu.add_checkbox("Misc", "Enable Clantag")

local lefthand = cvars.cl_righthand
local enable_lefthand = menu.add_checkbox("Misc", "Change hand when knife")
local is_enabled = menu.add_checkbox("Misc", "Enable Indicators", false)

local Water_tog = menu.add_checkbox("Misc", "Enable Watermark", true)
local Water_Col = Water_tog:add_color_picker("Watermark Color", color_t.new(255, 255, 255))
local Background_Col = Water_tog:add_color_picker("Background Color", color_t.new(0, 0, 0, 100))
local Line_Col = Water_tog:add_color_picker("Line Color", color_t.new(180,159,230))


local _set_clantag = ffi.cast("int(__fastcall*)(const char*, const char*)", memory.find_pattern("engine.dll", "53 56 57 8B DA 8B F9 FF 15"))
local _last_clantag = nil
local set_clantag = function(v)
    if not engine.is_connected() then
        return
    end
    if v == _last_clantag then
        return
    end
    _set_clantag(v, v)
    _last_clantag = v
end

local clantag = {
    "           ",
    "          U",
    "         Um",
    "        Umb",
    "       Umbr",
    "      Umbra",
    "     Umbral",
    "    Umbral.",
    "   Umbral.t",
    "  Umbral.te",
    " Umbral.tec",
    "Umbral.tech",
    "Umbral.tech",
    "Umbral.tech",
    "Umbral.tec ",
    "Umbral.te  ",
    "Umbral.t   ",
    "Umbral.    ",
    "Umbral     ",
    "Umbra      ",
    "Umbr       ",
    "Umb        ",
    "Um         ",
    "U          ",
    "           "
}

local clantag_animation_index = 1

function on_paint()
    if enable_clantag:get() then
        local animation = math.floor(math.fmod(global_vars.tick_count() / 20, #clantag) + 1)
        if animation ~= clantag_animation_index then
            set_clantag(clantag[animation])
            clantag_animation_index = animation
        end
    else
        set_clantag("") -- 禁用社群標籤時將其設置為空
        clantag_animation_index = 1
    end
end

local JitterTypes = {"None", "Static", "Center", "Random", "Random plus", "Break"}
local DesyncSides = {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real", "Sway", "Random", "Break"}
local FakelagTypes = {"Static", "Adaptive", "Random", "Break LC"}

local Lua = {
	openAntiaim = AddCheckbox("Main", "Anti-aim"),
	openFakelag = AddCheckbox("Main", "Fakelag"),

	Antiaim = {
		Preset = AddCombo("Antiaim", "Default", {"None", "Magic jitter", "Low jitter", "N-Way", "Custom"}),

		NWay = {
			Type = AddCombo("Antiaim - N-Way", "Type", {"3-Way", "4-Way", "5-Way"}),

			Timings = AddCombo("Antiaim - N-Way", "Mode", {"Static", "Randomize"}),

			YawFirstSide = AddSlider("N-Way", "Yaw - 1", -58, 58),
			YawSecondSide = AddSlider("N-Way", "Yaw - 2", -58, 58),
			YawThirdSide = AddSlider("N-Way", "Yaw - 3", -58, 58),
			YawFourthSide = AddSlider("N-Way", "Yaw - 4", -58, 58),
			YawFivthSide = AddSlider("N-Way", "Yaw - 5", -58, 58),

			Desyncopen = AddCheckbox("N-Way", "open desync"),
			DesyncFirstSide = AddSlider("N-Way", "Desync - 1", -90, 90),
			DesyncSecondSide = AddSlider("N-Way", "Desync - 2", -90, 90),
			DesyncThirdSide = AddSlider("N-Way", "Desync - 3", -90, 90),
			DesyncFourthSide = AddSlider("N-Way", "Desync - 4", -90, 90),
			DesyncFivthSide = AddSlider("N-Way", "Desync - 5", -90, 90)
		},

		Custom = {
			Mode = AddCombo("Antiaim - Custom", "Type", {"Defensive", "Standing", "Slow Walk", "Running", "In-air", "Air-Crouch", "Ducking"}),
			
			
			Deffensive = {
				Sensivity = AddSlider("Custom", "Defensive - Defensive sensivity", 0, 100),

				Pitch = AddCombo("Custom", "Defensive - Pitch", {"None", "Down", "Up", "Zero", "Jitter"}),
				Yaw = AddSlider("Custom", "Defensive - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Custom", "Defensive - Randomize yaw"),

				openJitter = AddCheckbox("Custom", "Defensive - open jitter"),
				JitterType = AddCombo("Custom", "Defensive - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Custom", "Defensive - Amount", -58, 58),

				openSpin = AddCheckbox("Custom", "Defensive - open spin"),
				SpinType = AddCombo("Custom", "Defensive - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Custom", "Defensive - Amount", 0, 360),
				SpinSpeed = AddSlider("Custom", "Defensive - Speed", 0, 100),

				DesyncType = AddCombo("Custom", "Defensive - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Custom", "Defensive - Left amount", 0, 90),
				DesyncRight = AddSlider("Custom", "Defensive - Right amount", 0, 90),
			},

			Standing = {
				Yaw = AddSlider("Custom", "Standing - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Custom", "Standing - Randomize yaw"),

				openJitter = AddCheckbox("Custom", "Standing - open jitter"),
				JitterType = AddCombo("Custom", "Standing - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Custom", "Standing - Amount", -58, 58),

				openSpin = AddCheckbox("Custom", "Standing - open spin"),
				SpinType = AddCombo("Custom", "Standing - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Custom", "Standing - Amount", 0, 360),
				SpinSpeed = AddSlider("Custom", "Standing - Speed", 0, 100),

				DesyncType = AddCombo("Custom", "Standing - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Custom", "Standing - Left amount", 0, 90),
				DesyncRight = AddSlider("Custom", "Standing - Right amount", 0, 90),
			},

			Walking = {
				Yaw = AddSlider("Custom", "Slow Walk - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Custom", "Slow Walk - Randomize yaw"),

				openJitter = AddCheckbox("Custom", "Slow Walk - open jitter"),
				JitterType = AddCombo("Custom", "Slow Walk - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Custom", "Slow Walk - Amount", -58, 58),

				openSpin = AddCheckbox("Custom", "Slow Walk - open spin"),
				SpinType = AddCombo("Custom", "Slow Walk - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Custom", "Slow Walk - Amount", 0, 360),
				SpinSpeed = AddSlider("Custom", "Slow Walk - Speed", 0, 100),

				DesyncType = AddCombo("Custom", "Slow Walk - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Custom", "Slow Walk - Left amount", 0, 90),
				DesyncRight = AddSlider("Custom", "Slow Walk - Right amount", 0, 90),
			},

			Running = {
				Yaw = AddSlider("Custom", "Running - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Custom", "Running - Randomize yaw"),

				openJitter = AddCheckbox("Custom", "Running - open jitter"),
				JitterType = AddCombo("Custom", "Running - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Custom", "Running - Amount", -58, 58),

				openSpin = AddCheckbox("Custom", "Running - open spin"),
				SpinType = AddCombo("Custom", "Running - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Custom", "Running - Amount", 0, 360),
				SpinSpeed = AddSlider("Custom", "Running - Speed", 0, 100),

				DesyncType = AddCombo("Custom", "Running - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Custom", "Running - Left amount", 0, 90),
				DesyncRight = AddSlider("Custom", "Running - Right amount", 0, 90),
			},

			Air = {
				Yaw = AddSlider("Custom", "In Air - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Custom", "In Air - Randomize yaw"),

				openJitter = AddCheckbox("Custom", "In Air - open jitter"),
				JitterType = AddCombo("Custom", "In Air - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Custom", "In Air - Amount", -58, 58),

				openSpin = AddCheckbox("Custom", "In Air - open spin"),
				SpinType = AddCombo("Custom", "In Air - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Custom", "In Air - Amount", 0, 360),
				SpinSpeed = AddSlider("Custom", "In Air - Speed", 0, 100),

				DesyncType = AddCombo("Custom", "In Air - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Custom", "In Air - Left amount", 0, 90),
				DesyncRight = AddSlider("Custom", "In Air - Right amount", 0, 90),
			},

			CrouchingInAir = {
				Yaw = AddSlider("Custom", "Air-Crouch - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Custom", "Air-Crouch - Randomize yaw"),

				openJitter = AddCheckbox("Custom", "Air-Crouch - open jitter"),
				JitterType = AddCombo("Custom", "Air-Crouch - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Custom", "Air-Crouch - Amount", -58, 58),

				openSpin = AddCheckbox("Custom", "Air-Crouch - open spin"),
				SpinType = AddCombo("Custom", "Air-Crouch - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Custom", "Air-Crouch - Amount", 0, 360),
				SpinSpeed = AddSlider("Custom", "Air-Crouch - Speed", 0, 100),

				DesyncType = AddCombo("Custom", "Air-Crouch - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Custom", "Air-Crouch - Left amount", 0, 90),
				DesyncRight = AddSlider("Custom", "Air-Crouch - Right amount", 0, 90),
			},

			Crouching = {
				Yaw = AddSlider("Custom", "Ducking - Yaw", -58, 58),
				DynamicYaw = AddCheckbox("Custom", "Ducking - Randomize yaw"),

				openJitter = AddCheckbox("Custom", "Ducking - open jitter"),
				JitterType = AddCombo("Custom", "Ducking - Jitter type", JitterTypes),
				JitterAmount = AddSlider("Custom", "Ducking - Amount", -58, 58),

				openSpin = AddCheckbox("Custom", "Ducking - open spin"),
				SpinType = AddCombo("Custom", "Ducking - Spin type", {"Static", "Ways", "Random"}),
				SpinAmount = AddSlider("Custom", "Ducking - Amount", 0, 360),
				SpinSpeed = AddSlider("Custom", "Ducking - Speed", 0, 100),

				DesyncType = AddCombo("Custom", "Ducking - Desync side", DesyncSides),
				DesyncLeft = AddSlider("Custom", "Ducking - Left amount", 0, 90),
				DesyncRight = AddSlider("Custom", "Ducking - Right amount", 0, 90),
			}
		}
	},

	Fakelag = {
		MoveType = AddCombo("Fakelag", "Movement", {"Standing", "Slow Walk", "Running", "In Air", "Air-Crouch", "Ducking"}),

		Standing = {
			Amount = AddSlider("Fakelag", "Standing - Amount", 0, 15),
			Mode = AddCombo("Fakelag", "Standing - Mode", FakelagTypes),
		},

		Walking = {
			Amount = AddSlider("Fakelag", "Slow Walk - Amount", 0, 15),
			Mode = AddCombo("Fakelag", "Slow Walk - Mode", FakelagTypes),
		},

		Running = {
			Amount = AddSlider("Fakelag", "Running - Amount", 0, 15),
			Mode = AddCombo("Fakelag", "Running - Mode", FakelagTypes),
		},

		Air = {
			Amount = AddSlider("Fakelag", "In Air - Amount", 0, 15),
			Mode = AddCombo("Fakelag", "In Air - Mode", FakelagTypes),
		},

		CrouchingInAir = {
			Amount = AddSlider("Fakelag", "[AC] - Amount", 0, 15),
			Mode = AddCombo("Fakelag", "[AC] - Mode", FakelagTypes),
		},
		
		Crouching = {
			Amount = AddSlider("Fakelag", "Ducking - Amount", 0, 15),
			Mode = AddCombo("Fakelag", "Ducking - Mode", FakelagTypes),
		}
	}
}

local Ui = {

	Exploits = {
		Doubletap = Get("aimbot", "general", "exploits", "doubletap", "enable"),
		Hideshots = Get("aimbot", "general", "exploits", "hideshots", "enable")
	},

	Antiaim = {
		Enable = Get("antiaim", "main", "general", "enable"),
		Pitch = Get("antiaim", "main", "angles", "pitch"),
		Base = Get("antiaim", "main", "angles", "yaw base"),
		Yaw = Get("antiaim", "main", "angles", "yaw add"),

		openSpin = Get("antiaim", "main", "angles", "rotate"),
		SpinAmount = Get("antiaim", "main", "angles", "rotate range"),
		SpinSpeed = Get("antiaim", "main", "angles", "rotate speed"),

		JitterType = Get("antiaim", "main", "angles", "jitter mode"),
		JitterMode = Get("antiaim", "main", "angles", "jitter type"),
		JitterAmount = Get("antiaim", "main", "angles", "jitter add"),

		DesyncSide = Get("antiaim", "main", "desync","side#stand"),
		DesyncLeft = Get("antiaim", "main", "desync","left amount#stand"),
		DesyncRight = Get("antiaim", "main", "desync","right amount#stand"),
	},

	Fakelag = {
		Amount = Get("antiaim", "main", "fakelag", "amount")
	}
}

function Clamp(x, min, max)
    if min > max then
        return math.min(math.max(x, max), min)
    else
        return math.min(math.max(x, min), max)
    end  
    
    return x
end

local function GetVelocity()
    local Entity = entity_list.get_local_player()

    local VelocityX = Entity:get_prop("m_vecVelocity[0]")
    local VelocityY = Entity:get_prop("m_vecVelocity[1]")
    local VelocityZ = Entity:get_prop("m_vecVelocity[2]")
  
    local Velocity = vec3_t(VelocityX, VelocityY, VelocityZ)

    if math.ceil(Velocity:length2d()) < 5 then
        return 0
    else 
        return math.ceil(Velocity:length2d()) 
    end
end

local Tickbase = {
	LastTickcount = global_vars.tick_count(),
	Ticks = 62,
	Difference = 0,
	Deffensive = false
}

local PreviousSimulationTime = 0
local DifferenceOfSimulation = 0
function SimulationDifference(entity)
	local CurrentSimulationTime = client.time_to_ticks(entity:get_prop("m_flSimulationTime"))
	local Difference = CurrentSimulationTime - (PreviousSimulationTime + (Lua.Antiaim.Custom.Deffensive.Sensivity:get() / 100))
	PreviousSimulationTime = CurrentSimulationTime
	DifferenceOfSimulation = Difference
	return DifferenceOfSimulation
end

function RefreshTickcount()
    Tickbase.LastTickcount = global_vars.tick_count()
end

local function AntiaimCondition()
	local LocalPlayer = entity_list.get_local_player()
	local AntiaimCondition = 0

	local Deffensive = false

    local TickBase = LocalPlayer:get_prop("m_nTickBase")
    Tickbase.Deffensive = math.abs(TickBase - Tickbase.Difference) >= 2.50
    Tickbase.Difference = math.max(TickBase, Tickbase.Difference or 0)
    if Tickbase.LastTickcount < global_vars.tick_count() - (Tickbase.Ticks / 2) + exploits.get_charge() then
		if (Tickbase.Deffensive or SimulationDifference(LocalPlayer) <= -1) and Tickbase.LastTickcount < global_vars.tick_count() and Ui.Exploits.Doubletap[2]:get() == true then
			Deffensive = true
			RefreshTickcount()
			Deffensive = false
		end

		Deffensive = true
    end

	if GetVelocity() == 0 and Deffensive then 
		AntiaimCondition = 1 
	end

	if GetVelocity() > 0 and LocalPlayer:has_player_flag(e_player_flags.ON_GROUND) and Deffensive then
		AntiaimCondition = 2
	end

	if GetVelocity() > 90 and LocalPlayer:has_player_flag(e_player_flags.ON_GROUND) and Deffensive then
        AntiaimCondition = 3
    end

    if not LocalPlayer:has_player_flag(e_player_flags.ON_GROUND) and Deffensive then
        AntiaimCondition = 4
    end

    if LocalPlayer:has_player_flag(e_player_flags.DUCKING) and LocalPlayer:has_player_flag(e_player_flags.ON_GROUND) and Deffensive then
        AntiaimCondition = 5
    end

	if not LocalPlayer:has_player_flag(e_player_flags.ON_GROUND) and LocalPlayer:has_player_flag(e_player_flags.DUCKING) and Deffensive then
		AntiaimCondition = 6
	end

	if Deffensive == false and not Ui.Exploits.Hideshots[2]:get() then
		AntiaimCondition = 7
	end

	return AntiaimCondition
end

function JitterSide()
    local JitterSide = 0
    local SwapTimer = 0
    SwapTimer = global_vars.cur_time() * 10000 % 1
    Clamp(SwapTimer, 0, 1)
    JitterSide = SwapTimer > 0.5 and 1 or -1

    return JitterSide
end

function SwapSide()
    local JitterSide = 0
    local SwapTimer = 0
    SwapTimer = math.ceil(global_vars.cur_time() * 36) % 2
    Clamp(SwapTimer, 0, 1)
    JitterSide = SwapTimer > 0.5 and 1 or -1
    return JitterSide
end

local Way = 0

local function CAntiaim()
	local Curtime = global_vars.cur_time()
	local LocalPlayer = entity_list.get_local_player()

	if Lua.Antiaim.NWay.Timings:get() == 1 then
		if JitterSide() == 1 then
			Way = Way + 1
		end
	else
		if math.ceil(Curtime * client.random_int(100, 128)) % 5 > 1 then
			Way = Way + 1
		end
	end

    if Lua.Antiaim.Preset:get() == 2 then
        Ui.Antiaim.openSpin:set(false)
		Ui.Antiaim.JitterType:set(1)

        Ui.Antiaim.Yaw:set(math.ceil(Curtime * 128) % 20 * SwapSide())

		Ui.Antiaim.DesyncSide:set(SwapSide() == 1 and 2 or 3)
		Ui.Antiaim.DesyncLeft:set(75)
		Ui.Antiaim.DesyncRight:set(75)
    end

    if Lua.Antiaim.Preset:get() == 3 then
        Ui.Antiaim.openSpin:set(false)
		Ui.Antiaim.JitterType:set(1)

        Ui.Antiaim.Yaw:set(15 + math.ceil(Curtime * client.random_int(120, 128)) % 25 * SwapSide())

		Ui.Antiaim.DesyncSide:set(3)
		Ui.Antiaim.DesyncLeft:set(75 - math.ceil(Curtime * 65) % 20)
		Ui.Antiaim.DesyncRight:set(75 - math.ceil(Curtime * 65) % 20)
    end

	if Lua.Antiaim.Preset:get() == 4 then
		Ui.Antiaim.openSpin:set(false)
		Ui.Antiaim.JitterType:set(1)

		if Way == 1 then
			Ui.Antiaim.Yaw:set(Lua.Antiaim.NWay.YawFirstSide:get())
		elseif Way == 2 then
			Ui.Antiaim.Yaw:set(Lua.Antiaim.NWay.YawSecondSide:get())
		elseif Way == 3 and Lua.Antiaim.NWay.Type:get() > 0 then
			Ui.Antiaim.Yaw:set(Lua.Antiaim.NWay.YawThirdSide:get())
		elseif Way == 4 and Lua.Antiaim.NWay.Type:get() > 1 then
			Ui.Antiaim.Yaw:set(Lua.Antiaim.NWay.YawFourthSide:get())
		elseif Way == 5 and Lua.Antiaim.NWay.Type:get() > 2 then
			Ui.Antiaim.Yaw:set(Lua.Antiaim.NWay.YawFivthSide:get())
		else
			Way = 1
		end

		if Lua.Antiaim.NWay.Desyncopen:get() then
			if Way == 1 then
				Ui.Antiaim.DesyncSide:set(Lua.Antiaim.NWay.DesyncFirstSide:get() > 0 and 3 or 2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.NWay.DesyncFirstSide:get() > 0 and Lua.Antiaim.NWay.DesyncFirstSide:get() or Lua.Antiaim.NWay.DesyncFirstSide:get() * -1)
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.NWay.DesyncFirstSide:get() > 0 and Lua.Antiaim.NWay.DesyncFirstSide:get() or Lua.Antiaim.NWay.DesyncFirstSide:get() * -1)
			elseif Way == 2 then
				Ui.Antiaim.DesyncSide:set(Lua.Antiaim.NWay.DesyncSecondSide:get() > 0 and 3 or 2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.NWay.DesyncSecondSide:get() > 0 and Lua.Antiaim.NWay.DesyncSecondSide:get() or Lua.Antiaim.NWay.DesyncSecondSide:get() * -1)
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.NWay.DesyncSecondSide:get() > 0 and Lua.Antiaim.NWay.DesyncSecondSide:get() or Lua.Antiaim.NWay.DesyncSecondSide:get() * -1)
			elseif Way == 3 and Lua.Antiaim.NWay.Type:get() > 0 then
				Ui.Antiaim.DesyncSide:set(Lua.Antiaim.NWay.DesyncThirdSide:get() > 0 and 3 or 2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.NWay.DesyncThirdSide:get() > 0 and Lua.Antiaim.NWay.DesyncThirdSide:get() or Lua.Antiaim.NWay.DesyncThirdSide:get() * -1)
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.NWay.DesyncThirdSide:get() > 0 and Lua.Antiaim.NWay.DesyncThirdSide:get() or Lua.Antiaim.NWay.DesyncThirdSide:get() * -1)
			elseif Way == 4 and Lua.Antiaim.NWay.Type:get() > 1 then
				Ui.Antiaim.DesyncSide:set(Lua.Antiaim.NWay.DesyncFourthSide:get() > 0 and 3 or 2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.NWay.DesyncFourthSide:get() > 0 and Lua.Antiaim.NWay.DesyncFourthSide:get() or Lua.Antiaim.NWay.DesyncFourthSide:get() * -1)
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.NWay.DesyncFourthSide:get() > 0 and Lua.Antiaim.NWay.DesyncFourthSide:get() or Lua.Antiaim.NWay.DesyncFourthSide:get() * -1)
			elseif Way == 5 and Lua.Antiaim.NWay.Type:get() > 2 then
				Ui.Antiaim.DesyncSide:set(Lua.Antiaim.NWay.DesyncFivthSide:get() > 0 and 3 or 2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.NWay.DesyncFivthSide:get() > 0 and Lua.Antiaim.NWay.DesyncFivthSide:get() or Lua.Antiaim.NWay.DesyncFivthSide:get() * -1)
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.NWay.DesyncFivthSide:get() > 0 and Lua.Antiaim.NWay.DesyncFivthSide:get() or Lua.Antiaim.NWay.DesyncFivthSide:get() * -1)
			else
				Way = 1
			end
		end
	end

	if Lua.Antiaim.Preset:get() == 5 then
		if AntiaimCondition() == 1 then
			Ui.Antiaim.Pitch:set(2)

			if Lua.Antiaim.Custom.Standing.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Standing.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.Standing.Yaw:get(), -Lua.Antiaim.Custom.Standing.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.Standing.Yaw:get(), Lua.Antiaim.Custom.Standing.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Standing.Yaw:get())
			end

			if Lua.Antiaim.Custom.Standing.openJitter:get() then 
				if Lua.Antiaim.Custom.Standing.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.Standing.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Standing.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Standing.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Standing.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Standing.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Standing.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Standing.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Standing.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.Standing.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Standing.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.openSpin:set(Lua.Antiaim.Custom.Standing.openSpin:get())

			if Lua.Antiaim.Custom.Standing.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Standing.SpinAmount:get())
			elseif Lua.Antiaim.Custom.Standing.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Standing.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.Standing.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.Standing.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.Standing.SpinSpeed:get())

			if Lua.Antiaim.Custom.Standing.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Standing.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Standing.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Standing.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.Standing.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.Standing.DesyncRight:get()))
			end
		end

		if AntiaimCondition() == 2 then
			Ui.Antiaim.Pitch:set(2)

			if Lua.Antiaim.Custom.Walking.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Walking.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.Walking.Yaw:get(), -Lua.Antiaim.Custom.Walking.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.Walking.Yaw:get(), Lua.Antiaim.Custom.Walking.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Walking.Yaw:get())
			end

			if Lua.Antiaim.Custom.Walking.openJitter:get() then 
				if Lua.Antiaim.Custom.Walking.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.Walking.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Walking.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Walking.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Walking.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Walking.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Walking.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Walking.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Walking.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.Walking.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Walking.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.openSpin:set(Lua.Antiaim.Custom.Walking.openSpin:get())

			if Lua.Antiaim.Custom.Walking.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Walking.SpinAmount:get())
			elseif Lua.Antiaim.Custom.Walking.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Walking.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.Walking.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.Walking.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.Walking.SpinSpeed:get())

			if Lua.Antiaim.Custom.Walking.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Walking.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Walking.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Walking.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.Walking.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.Walking.DesyncRight:get()))
			end
		end

		if AntiaimCondition() == 3 then
			Ui.Antiaim.Pitch:set(2)

			if Lua.Antiaim.Custom.Running.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Running.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.Running.Yaw:get(), -Lua.Antiaim.Custom.Running.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.Running.Yaw:get(), Lua.Antiaim.Custom.Running.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Running.Yaw:get())
			end

			if Lua.Antiaim.Custom.Running.openJitter:get() then 
				if Lua.Antiaim.Custom.Running.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.Running.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Running.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Running.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Running.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Running.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Running.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Running.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Running.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.Running.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Running.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.openSpin:set(Lua.Antiaim.Custom.Running.openSpin:get())

			if Lua.Antiaim.Custom.Running.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Running.SpinAmount:get())
			elseif Lua.Antiaim.Custom.Running.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Running.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.Running.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.Running.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.Running.SpinSpeed:get())

			if Lua.Antiaim.Custom.Running.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Running.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Running.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Running.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.Running.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.Running.DesyncRight:get()))
			end
		end

		if AntiaimCondition() == 4 then
			Ui.Antiaim.Pitch:set(2)

			if Lua.Antiaim.Custom.Air.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Air.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.Air.Yaw:get(), -Lua.Antiaim.Custom.Air.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.Air.Yaw:get(), Lua.Antiaim.Custom.Air.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Air.Yaw:get())
			end

			if Lua.Antiaim.Custom.Air.openJitter:get() then 
				if Lua.Antiaim.Custom.Air.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.Air.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Air.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Air.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Air.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Air.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Air.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Air.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Air.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.Air.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Air.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.openSpin:set(Lua.Antiaim.Custom.Air.openSpin:get())

			if Lua.Antiaim.Custom.Air.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Air.SpinAmount:get())
			elseif Lua.Antiaim.Custom.Air.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Air.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.Air.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.Air.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.Air.SpinSpeed:get())

			if Lua.Antiaim.Custom.Air.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Air.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Air.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Air.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.Air.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.Air.DesyncRight:get()))
			end
		end

		if AntiaimCondition() == 5 then
			Ui.Antiaim.Pitch:set(2)

			if Lua.Antiaim.Custom.Crouching.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Crouching.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.Crouching.Yaw:get(), -Lua.Antiaim.Custom.Crouching.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.Crouching.Yaw:get(), Lua.Antiaim.Custom.Crouching.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Crouching.Yaw:get())
			end

			if Lua.Antiaim.Custom.Crouching.openJitter:get() then 
				if Lua.Antiaim.Custom.Crouching.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.Crouching.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Crouching.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Crouching.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Crouching.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Crouching.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Crouching.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Crouching.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Crouching.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.Crouching.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Crouching.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.openSpin:set(Lua.Antiaim.Custom.Crouching.openSpin:get())

			if Lua.Antiaim.Custom.Crouching.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Crouching.SpinAmount:get())
			elseif Lua.Antiaim.Custom.Crouching.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Crouching.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.Crouching.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.Crouching.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.Crouching.SpinSpeed:get())

			if Lua.Antiaim.Custom.Crouching.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Crouching.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Crouching.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Crouching.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.Crouching.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.Crouching.DesyncRight:get()))
			end
		end

		if AntiaimCondition() == 6 then
			Ui.Antiaim.Pitch:set(2)

			if Lua.Antiaim.Custom.CrouchingInAir.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.CrouchingInAir.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.CrouchingInAir.Yaw:get(), -Lua.Antiaim.Custom.CrouchingInAir.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.CrouchingInAir.Yaw:get(), Lua.Antiaim.Custom.CrouchingInAir.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.CrouchingInAir.Yaw:get())
			end

			if Lua.Antiaim.Custom.CrouchingInAir.openJitter:get() then 
				if Lua.Antiaim.Custom.CrouchingInAir.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.CrouchingInAir.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:get())
				elseif Lua.Antiaim.Custom.CrouchingInAir.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:get())
				elseif Lua.Antiaim.Custom.CrouchingInAir.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:get())
				elseif Lua.Antiaim.Custom.CrouchingInAir.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.CrouchingInAir.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.openSpin:set(Lua.Antiaim.Custom.CrouchingInAir.openSpin:get())

			if Lua.Antiaim.Custom.CrouchingInAir.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.CrouchingInAir.SpinAmount:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.CrouchingInAir.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.CrouchingInAir.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.CrouchingInAir.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.CrouchingInAir.SpinSpeed:get())

			if Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get())
			elseif Lua.Antiaim.Custom.CrouchingInAir.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:get()))
			end
		end

		if AntiaimCondition() == 7 then
			Ui.Antiaim.Pitch:set(Lua.Antiaim.Custom.Deffensive.Pitch:get())

			if Lua.Antiaim.Custom.Deffensive.DynamicYaw:get() then
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Deffensive.Yaw:get() < 0 and client.random_int(Lua.Antiaim.Custom.Deffensive.Yaw:get(), -Lua.Antiaim.Custom.Deffensive.Yaw:get()) or client.random_int(-Lua.Antiaim.Custom.Deffensive.Yaw:get(), Lua.Antiaim.Custom.Deffensive.Yaw:get()))
			else
				Ui.Antiaim.Yaw:set(Lua.Antiaim.Custom.Deffensive.Yaw:get())
			end

			if Lua.Antiaim.Custom.Deffensive.openJitter:get() then 
				if Lua.Antiaim.Custom.Deffensive.JitterType:get() == 1 then
					Ui.Antiaim.JitterType:set(1)
					Ui.Antiaim.JitterMode:set(1)
				elseif Lua.Antiaim.Custom.Deffensive.JitterType:get() == 2 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Deffensive.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Deffensive.JitterType:get() == 3 then
					Ui.Antiaim.JitterType:set(2)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Deffensive.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Deffensive.JitterType:get() == 4 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(1)
					Ui.Antiaim.JitterAmount:set(Lua.Antiaim.Custom.Deffensive.JitterAmount:get())
				elseif Lua.Antiaim.Custom.Deffensive.JitterType:get() == 5 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(2)
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Deffensive.JitterAmount:get()) * JitterSide())
				elseif Lua.Antiaim.Custom.Deffensive.JitterType:get() == 6 then
					Ui.Antiaim.JitterType:set(3)
					Ui.Antiaim.JitterMode:set(client.random_int(1, 2))
					Ui.Antiaim.JitterAmount:set(client.random_int(0, Lua.Antiaim.Custom.Deffensive.JitterAmount:get()) * JitterSide())
				end
			end

			Ui.Antiaim.openSpin:set(Lua.Antiaim.Custom.Deffensive.openSpin:get())

			if Lua.Antiaim.Custom.Deffensive.SpinType:get() == 1 then
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Deffensive.SpinAmount:get())
			elseif Lua.Antiaim.Custom.Deffensive.SpinType:get() == 2 then
				local Side = JitterSide() == -1 and 0 or 1
				Ui.Antiaim.SpinAmount:set(Lua.Antiaim.Custom.Deffensive.SpinAmount:get() * Side)
			elseif Lua.Antiaim.Custom.Deffensive.SpinType:get() == 3 then
				Ui.Antiaim.SpinAmount:set(client.random_int(0, Lua.Antiaim.Custom.Deffensive.SpinAmount:get()))
			end

			Ui.Antiaim.SpinSpeed:set(Lua.Antiaim.Custom.Deffensive.SpinSpeed:get())

			if Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 1 then
				Ui.Antiaim.DesyncSide:set(1)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 2 then
				Ui.Antiaim.DesyncSide:set(2)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 3 then
				Ui.Antiaim.DesyncSide:set(3)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 4 then
				Ui.Antiaim.DesyncSide:set(4)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 5 then
				Ui.Antiaim.DesyncSide:set(5)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 6 then
				Ui.Antiaim.DesyncSide:set(6)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 7 then
				Ui.Antiaim.DesyncSide:set(7)
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 8 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(Lua.Antiaim.Custom.Deffensive.DesyncLeft:get())
				Ui.Antiaim.DesyncRight:set(Lua.Antiaim.Custom.Deffensive.DesyncRight:get())
			elseif Lua.Antiaim.Custom.Deffensive.DesyncType:get() == 9 then
				Ui.Antiaim.DesyncSide:set(client.random_int(2, 3))
				Ui.Antiaim.DesyncLeft:set(client.random_int(0, Lua.Antiaim.Custom.Deffensive.DesyncLeft:get()))
				Ui.Antiaim.DesyncRight:set(client.random_int(0, Lua.Antiaim.Custom.Deffensive.DesyncRight:get()))
			end
		end
	end
end

local function CFakelag(antiaim)
	local Fluctate = 0
	local BreakLagcomp = 64.0 / (GetVelocity() * global_vars.interval_per_tick())

	if AntiaimCondition() == 1 then
		Fluctate = math.ceil(global_vars.cur_time() * 7) % Lua.Fakelag.Standing.Amount:get()

		if Lua.Fakelag.Standing.Mode:get() == 1 then
			if engine.get_choked_commands() > Lua.Fakelag.Standing.Amount:get() then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Standing.Mode:get() == 2 then
			if engine.get_choked_commands() > Fluctate then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Standing.Mode:get() == 3 then
			if engine.get_choked_commands() > client.random_int(0, Lua.Fakelag.Standing.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Standing.Mode:get() == 4 then
			if engine.get_choked_commands() > Clamp(BreakLagcomp, 0, Lua.Fakelag.Standing.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		end
	elseif AntiaimCondition() == 2 then
		Fluctate = math.ceil(global_vars.cur_time() * 7) % Lua.Fakelag.Walking.Amount:get()

		if Lua.Fakelag.Walking.Mode:get() == 1 then
			if engine.get_choked_commands() > Lua.Fakelag.Walking.Amount:get() then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Walking.Mode:get() == 2 then
			if engine.get_choked_commands() > Fluctate then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Walking.Mode:get() == 3 then
			if engine.get_choked_commands() > client.random_int(0, Lua.Fakelag.Walking.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Walking.Mode:get() == 4 then
			if engine.get_choked_commands() > Clamp(BreakLagcomp, 0, Lua.Fakelag.Walking.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		end
	elseif AntiaimCondition() == 3 then
		Fluctate = math.ceil(global_vars.cur_time() * 7) % Lua.Fakelag.Running.Amount:get()

		if Lua.Fakelag.Running.Mode:get() == 1 then
			if engine.get_choked_commands() > Lua.Fakelag.Running.Amount:get() then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Running.Mode:get() == 2 then
			if engine.get_choked_commands() > Fluctate then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Running.Mode:get() == 3 then
			if engine.get_choked_commands() > client.random_int(0, Lua.Fakelag.Running.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Running.Mode:get() == 4 then
			if engine.get_choked_commands() > Clamp(BreakLagcomp, 0, Lua.Fakelag.Running.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		end
	elseif AntiaimCondition() == 4 then
		Fluctate = math.ceil(global_vars.cur_time() * 7) % Lua.Fakelag.Air.Amount:get()

		if Lua.Fakelag.Air.Mode:get() == 1 then
			if engine.get_choked_commands() > Lua.Fakelag.Air.Amount:get() then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Air.Mode:get() == 2 then
			if engine.get_choked_commands() > Fluctate then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Air.Mode:get() == 3 then
			if engine.get_choked_commands() > client.random_int(0, Lua.Fakelag.Air.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Air.Mode:get() == 4 then
			if engine.get_choked_commands() > Clamp(BreakLagcomp, 0, Lua.Fakelag.Air.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		end
	elseif AntiaimCondition() == 5 then
		Fluctate = math.ceil(global_vars.cur_time() * 7) % Lua.Fakelag.Crouching.Amount:get()

		if Lua.Fakelag.Crouching.Mode:get() == 1 then
			if engine.get_choked_commands() > Lua.Fakelag.Crouching.Amount:get() then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Crouching.Mode:get() == 2 then
			if engine.get_choked_commands() > Fluctate then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Crouching.Mode:get() == 3 then
			if engine.get_choked_commands() > client.random_int(0, Lua.Fakelag.Crouching.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.Crouching.Mode:get() == 4 then
			if engine.get_choked_commands() > Clamp(BreakLagcomp, 0, Lua.Fakelag.Crouching.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		end
	elseif AntiaimCondition() == 6 then
		Fluctate = math.ceil(global_vars.cur_time() * 7) % Lua.Fakelag.CrouchingInAir.Amount:get()

		if Lua.Fakelag.CrouchingInAir.Mode:get() == 1 then
			if engine.get_choked_commands() > Lua.Fakelag.CrouchingInAir.Amount:get() then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.CrouchingInAir.Mode:get() == 2 then
			if engine.get_choked_commands() > Fluctate then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.CrouchingInAir.Mode:get() == 3 then
			if engine.get_choked_commands() > client.random_int(0, Lua.Fakelag.CrouchingInAir.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		elseif Lua.Fakelag.CrouchingInAir.Mode:get() == 4 then
			if engine.get_choked_commands() > Clamp(BreakLagcomp, 0, Lua.Fakelag.CrouchingInAir.Amount:get()) then
				antiaim:set_fakelag(false)
			else
				antiaim:set_fakelag(true)
			end
		end
	end
end	

local function UiModule()

	Lua.Antiaim.Preset:set_visible(false)

	Lua.Antiaim.NWay.Type:set_visible(false)

	Lua.Antiaim.NWay.Timings:set_visible(false)
	Lua.Antiaim.NWay.YawFirstSide:set_visible(false)
	Lua.Antiaim.NWay.YawSecondSide:set_visible(false)
	Lua.Antiaim.NWay.YawThirdSide:set_visible(false)
	Lua.Antiaim.NWay.YawFourthSide:set_visible(false)
	Lua.Antiaim.NWay.YawFivthSide:set_visible(false)
	Lua.Antiaim.NWay.Desyncopen:set_visible(false)
	Lua.Antiaim.NWay.DesyncFirstSide:set_visible(false)
	Lua.Antiaim.NWay.DesyncSecondSide:set_visible(false)
	Lua.Antiaim.NWay.DesyncThirdSide:set_visible(false)
	Lua.Antiaim.NWay.DesyncFourthSide:set_visible(false)
	Lua.Antiaim.NWay.DesyncFivthSide:set_visible(false)

	Lua.Antiaim.Custom.Mode:set_visible(false)

	Lua.Antiaim.Custom.Standing.Yaw:set_visible(false)
	Lua.Antiaim.Custom.Standing.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.Standing.openJitter:set_visible(false)
	Lua.Antiaim.Custom.Standing.JitterType:set_visible(false)
	Lua.Antiaim.Custom.Standing.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.Standing.openSpin:set_visible(false)
	Lua.Antiaim.Custom.Standing.SpinType:set_visible(false)
	Lua.Antiaim.Custom.Standing.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.Standing.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.Standing.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.Standing.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.Standing.DesyncRight:set_visible(false)

	Lua.Antiaim.Custom.Walking.Yaw:set_visible(false)
	Lua.Antiaim.Custom.Walking.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.Walking.openJitter:set_visible(false)
	Lua.Antiaim.Custom.Walking.JitterType:set_visible(false)
	Lua.Antiaim.Custom.Walking.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.Walking.openSpin:set_visible(false)
	Lua.Antiaim.Custom.Walking.SpinType:set_visible(false)
	Lua.Antiaim.Custom.Walking.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.Walking.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.Walking.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.Walking.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.Walking.DesyncRight:set_visible(false)

	Lua.Antiaim.Custom.Running.Yaw:set_visible(false)
	Lua.Antiaim.Custom.Running.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.Running.openJitter:set_visible(false)
	Lua.Antiaim.Custom.Running.JitterType:set_visible(false)
	Lua.Antiaim.Custom.Running.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.Running.openSpin:set_visible(false)
	Lua.Antiaim.Custom.Running.SpinType:set_visible(false)
	Lua.Antiaim.Custom.Running.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.Running.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.Running.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.Running.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.Running.DesyncRight:set_visible(false)

	Lua.Antiaim.Custom.Air.Yaw:set_visible(false)
	Lua.Antiaim.Custom.Air.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.Air.openJitter:set_visible(false)
	Lua.Antiaim.Custom.Air.JitterType:set_visible(false)
	Lua.Antiaim.Custom.Air.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.Air.openSpin:set_visible(false)
	Lua.Antiaim.Custom.Air.SpinType:set_visible(false)
	Lua.Antiaim.Custom.Air.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.Air.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.Air.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.Air.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.Air.DesyncRight:set_visible(false)
	
	Lua.Antiaim.Custom.Crouching.Yaw:set_visible(false)
	Lua.Antiaim.Custom.Crouching.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.Crouching.openJitter:set_visible(false)
	Lua.Antiaim.Custom.Crouching.JitterType:set_visible(false)
	Lua.Antiaim.Custom.Crouching.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.Crouching.openSpin:set_visible(false)
	Lua.Antiaim.Custom.Crouching.SpinType:set_visible(false)
	Lua.Antiaim.Custom.Crouching.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.Crouching.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.Crouching.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.Crouching.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.Crouching.DesyncRight:set_visible(false)

	Lua.Antiaim.Custom.CrouchingInAir.Yaw:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.openJitter:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.JitterType:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.openSpin:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.SpinType:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:set_visible(false)

	Lua.Antiaim.Custom.Deffensive.Sensivity:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.Pitch:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.Yaw:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.DynamicYaw:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.openJitter:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.JitterType:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.JitterAmount:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.openSpin:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.SpinType:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.SpinAmount:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.SpinSpeed:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.DesyncType:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.DesyncLeft:set_visible(false)
	Lua.Antiaim.Custom.Deffensive.DesyncRight:set_visible(false)

	Lua.Fakelag.MoveType:set_visible(false)

	Lua.Fakelag.Standing.Amount:set_visible(false)
	Lua.Fakelag.Standing.Mode:set_visible(false)
	
	Lua.Fakelag.Walking.Amount:set_visible(false)
	Lua.Fakelag.Walking.Mode:set_visible(false)

	Lua.Fakelag.Running.Amount:set_visible(false)
	Lua.Fakelag.Running.Mode:set_visible(false)

	Lua.Fakelag.Air.Amount:set_visible(false)
	Lua.Fakelag.Air.Mode:set_visible(false)

	Lua.Fakelag.Crouching.Amount:set_visible(false)
	Lua.Fakelag.Crouching.Mode:set_visible(false)

	Lua.Fakelag.CrouchingInAir.Amount:set_visible(false)
	Lua.Fakelag.CrouchingInAir.Mode:set_visible(false)
	
	if Lua.openAntiaim:get() then
		Lua.Antiaim.Preset:set_visible(true)

		if Lua.Antiaim.Preset:get() == 4 then
			Lua.Antiaim.NWay.Type:set_visible(true)

			Lua.Antiaim.NWay.Timings:set_visible(true)

			if Lua.Antiaim.NWay.Type:get() == 1 then
				Lua.Antiaim.NWay.YawFirstSide:set_visible(true)
				Lua.Antiaim.NWay.YawSecondSide:set_visible(true)
				Lua.Antiaim.NWay.YawThirdSide:set_visible(true)
				Lua.Antiaim.NWay.YawFourthSide:set_visible(false)
				Lua.Antiaim.NWay.YawFivthSide:set_visible(false)
			elseif Lua.Antiaim.NWay.Type:get() == 2 then
				Lua.Antiaim.NWay.YawFirstSide:set_visible(true)
				Lua.Antiaim.NWay.YawSecondSide:set_visible(true)
				Lua.Antiaim.NWay.YawThirdSide:set_visible(true)
				Lua.Antiaim.NWay.YawFourthSide:set_visible(true)
				Lua.Antiaim.NWay.YawFivthSide:set_visible(false)
			elseif Lua.Antiaim.NWay.Type:get() == 3 then
				Lua.Antiaim.NWay.YawFirstSide:set_visible(true)
				Lua.Antiaim.NWay.YawSecondSide:set_visible(true)
				Lua.Antiaim.NWay.YawThirdSide:set_visible(true)
				Lua.Antiaim.NWay.YawFourthSide:set_visible(true)
				Lua.Antiaim.NWay.YawFivthSide:set_visible(true)
			end

			Lua.Antiaim.NWay.Desyncopen:set_visible(true)

			if Lua.Antiaim.NWay.Desyncopen:get() then
				if Lua.Antiaim.NWay.Type:get() == 1 then
					Lua.Antiaim.NWay.DesyncFirstSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncSecondSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncThirdSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncFourthSide:set_visible(false)
					Lua.Antiaim.NWay.DesyncFivthSide:set_visible(false)
				elseif Lua.Antiaim.NWay.Type:get() == 2 then
					Lua.Antiaim.NWay.DesyncFirstSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncSecondSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncThirdSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncFourthSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncFivthSide:set_visible(false)
				elseif Lua.Antiaim.NWay.Type:get() == 3 then
					Lua.Antiaim.NWay.DesyncFirstSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncSecondSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncThirdSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncFourthSide:set_visible(true)
					Lua.Antiaim.NWay.DesyncFivthSide:set_visible(true)
				end
			else
				Lua.Antiaim.NWay.DesyncFirstSide:set_visible(false)
				Lua.Antiaim.NWay.DesyncSecondSide:set_visible(false)
				Lua.Antiaim.NWay.DesyncThirdSide:set_visible(false)
				Lua.Antiaim.NWay.DesyncFourthSide:set_visible(false)
				Lua.Antiaim.NWay.DesyncFivthSide:set_visible(false)
			end
		end
--
		if Lua.Antiaim.Preset:get() == 5 then
			Lua.Antiaim.Custom.Mode:set_visible(true)
			
			if Lua.Antiaim.Custom.Mode:get() == 1 then
				Lua.Antiaim.Custom.Deffensive.Sensivity:set_visible(true)

				Lua.Antiaim.Custom.Deffensive.Pitch:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.Yaw:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.Deffensive.openJitter:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.JitterType:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.Deffensive.openSpin:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.SpinType:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.Deffensive.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.Deffensive.DesyncRight:set_visible(true)
			elseif Lua.Antiaim.Custom.Mode:get() == 2 then
				Lua.Antiaim.Custom.Standing.Yaw:set_visible(true)
				Lua.Antiaim.Custom.Standing.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.Standing.openJitter:set_visible(true)
				Lua.Antiaim.Custom.Standing.JitterType:set_visible(true)
				Lua.Antiaim.Custom.Standing.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.Standing.openSpin:set_visible(true)
				Lua.Antiaim.Custom.Standing.SpinType:set_visible(true)
				Lua.Antiaim.Custom.Standing.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.Standing.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.Standing.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.Standing.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.Standing.DesyncRight:set_visible(true)
			elseif Lua.Antiaim.Custom.Mode:get() == 3 then
				Lua.Antiaim.Custom.Walking.Yaw:set_visible(true)
				Lua.Antiaim.Custom.Walking.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.Walking.openJitter:set_visible(true)
				Lua.Antiaim.Custom.Walking.JitterType:set_visible(true)
				Lua.Antiaim.Custom.Walking.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.Walking.openSpin:set_visible(true)
				Lua.Antiaim.Custom.Walking.SpinType:set_visible(true)
				Lua.Antiaim.Custom.Walking.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.Walking.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.Walking.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.Walking.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.Walking.DesyncRight:set_visible(true)
			elseif Lua.Antiaim.Custom.Mode:get() == 4 then
				Lua.Antiaim.Custom.Running.Yaw:set_visible(true)
				Lua.Antiaim.Custom.Running.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.Running.openJitter:set_visible(true)
				Lua.Antiaim.Custom.Running.JitterType:set_visible(true)
				Lua.Antiaim.Custom.Running.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.Running.openSpin:set_visible(true)
				Lua.Antiaim.Custom.Running.SpinType:set_visible(true)
				Lua.Antiaim.Custom.Running.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.Running.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.Running.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.Running.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.Running.DesyncRight:set_visible(true)
			elseif Lua.Antiaim.Custom.Mode:get() == 5 then
				Lua.Antiaim.Custom.Air.Yaw:set_visible(true)
				Lua.Antiaim.Custom.Air.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.Air.openJitter:set_visible(true)
				Lua.Antiaim.Custom.Air.JitterType:set_visible(true)
				Lua.Antiaim.Custom.Air.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.Air.openSpin:set_visible(true)
				Lua.Antiaim.Custom.Air.SpinType:set_visible(true)
				Lua.Antiaim.Custom.Air.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.Air.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.Air.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.Air.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.Air.DesyncRight:set_visible(true)
			elseif Lua.Antiaim.Custom.Mode:get() == 6 then
				Lua.Antiaim.Custom.CrouchingInAir.Yaw:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.CrouchingInAir.openJitter:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.JitterType:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.CrouchingInAir.openSpin:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.SpinType:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.CrouchingInAir.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.CrouchingInAir.DesyncRight:set_visible(true)
			elseif Lua.Antiaim.Custom.Mode:get() == 7 then
				Lua.Antiaim.Custom.Crouching.Yaw:set_visible(true)
				Lua.Antiaim.Custom.Crouching.DynamicYaw:set_visible(true)

				Lua.Antiaim.Custom.Crouching.openJitter:set_visible(true)
				Lua.Antiaim.Custom.Crouching.JitterType:set_visible(true)
				Lua.Antiaim.Custom.Crouching.JitterAmount:set_visible(true)

				Lua.Antiaim.Custom.Crouching.openSpin:set_visible(true)
				Lua.Antiaim.Custom.Crouching.SpinType:set_visible(true)
				Lua.Antiaim.Custom.Crouching.SpinAmount:set_visible(true)
				Lua.Antiaim.Custom.Crouching.SpinSpeed:set_visible(true)

				Lua.Antiaim.Custom.Crouching.DesyncType:set_visible(true)
				Lua.Antiaim.Custom.Crouching.DesyncLeft:set_visible(true)
				Lua.Antiaim.Custom.Crouching.DesyncRight:set_visible(true)
			end
		end--
	end

	if Lua.openFakelag:get() then
		Lua.Fakelag.MoveType:set_visible(true)

		if Lua.Fakelag.MoveType:get() == 1 then
			Lua.Fakelag.Standing.Amount:set_visible(true)
			Lua.Fakelag.Standing.Mode:set_visible(true)
		elseif Lua.Fakelag.MoveType:get() == 2 then
			Lua.Fakelag.Walking.Amount:set_visible(true)
			Lua.Fakelag.Walking.Mode:set_visible(true)
		elseif Lua.Fakelag.MoveType:get() == 3 then
			Lua.Fakelag.Running.Amount:set_visible(true)
			Lua.Fakelag.Running.Mode:set_visible(true)
		elseif Lua.Fakelag.MoveType:get() == 4 then
			Lua.Fakelag.Air.Amount:set_visible(true)
			Lua.Fakelag.Air.Mode:set_visible(true)
		elseif Lua.Fakelag.MoveType:get() == 5 then
			Lua.Fakelag.CrouchingInAir.Amount:set_visible(true)
			Lua.Fakelag.CrouchingInAir.Mode:set_visible(true)
		elseif Lua.Fakelag.MoveType:get() == 6 then
			Lua.Fakelag.Crouching.Amount:set_visible(true)
			Lua.Fakelag.Crouching.Mode:set_visible(true)
		end
	end
end

function HookAntiaim(antiaim)
	if Lua.openFakelag:get() and Ui.Exploits.Doubletap[2]:get() == false then
		CFakelag(antiaim)
	end
end

function HookRender()
	UiModule()

	if Lua.openAntiaim:get() then
		if entity_list.get_local_player() ~= nil then
			if entity_list.get_local_player():get_prop("m_iHealth") > 0 then
				CAntiaim()
			end
		end
	end
end


local kill_say = {}
local ui = {}
kill_say.phrases = {}

-- just found all phrases on github

table.insert(kill_say.phrases, {
    name = "AD",
    phrases = {
    "你已被阳光大男孩使用Umbral.tech击杀了,现在购买shoppy.gg/@BadBottle/groups/85BNfJB",
    "You were killed by Rick Astley using Umbral.tech, Buy now shoppy.gg/@BadBottle/groups/85BNfJB"
    }
})

table.insert(kill_say.phrases, {
    name = "CN R18",
    phrases = {
    "我觉你你还是那个需要我扶一下才能进去的男孩",
	"想做一杯奶茶，被哥哥又插又吸",
                "哥哥生病了，只有你能治疗，口服注射我都行",
                "你和你妈妈说今晚去同学家睡 我要操你滴批",
                "我的双马尾可以成为哥哥的缰绳吗",
                "用腿给哥哥量腰围",
                "想在哥哥腹肌上练习深蹲",
                "哥哥是千我是北 然后我们一起边乖了",
                "湖在月下面，月在湖里面，我在你下面，你在我里面。",
	"不想喊你哥哥想含你弟弟",
	"外面的鸟看腻了，想看看你的鸟",
	"我想和你翻山越岭，翻上面的山，越下面的明明对哥哥的想念不带一丝水分可为什么想哥哥的时候，总是湿的",
	"哥哥我水最多， 来我这里游泳吗",
	"一晚上被干醒好几次看来是要买个加湿器了",
	"小时候被打屁话会哭现在被打屁股会湿或许这就是成长吧",
	"妹妹比较喜欢出暴击加攻速的男孩子",
	"我们这里雨很大，不知道哥哥那里大不大。",
	"太阳射不进的地方，哥哥可以",
	"喜欢一个人是藏不住的即使捂住嘴巴水也会从下面流出来",
	"要想在潮湿的环境里发热，就得在狭窄的空间里不断摩擦。",
	"小时候喜欢玩水气球因为它会喷水长大了发现自己也可以",
	"我和蜘蛛侠同样的手势即使看上去又脏又黑还有毛，但照样有人吃",
	"不敢顶撞哥哥，但想被哥哥顶撞。",
	"答应我，懆妹妹的时候要比妹妹的男朋友更用力。",
	"哪怕只有手指能动，也不能阻止对黑洞的探索",
	"哥哥奶茶多吗?吸管长不长?噎着的时候会不会按着头不松开?喝不下的时候会不会强行喂",
	"中国有十六亿人口，我却没有人口",
	"今天就是大禹来了也治不了我的水",
	"只要哥哥技术好，背上抓痕不会少",
	"我耐cao，屁股翘，哥哥一顶我就叫",
	"最适宜草莓生长的环境，是哥哥37度的胸膛",
	"没跟我睡过就别说别的女人活儿好",
	"什么b?我没有b，我的双腿间是哥哥的饮水机",
	"你向往的地方，每天早晚都沾满了白露",
	"你心驰神往的林荫小道，其实是车水马龙的高速公路",
	"妹妹已经水漫金山，弟弟却还在垂头丧气",
	"如果前门进不去，那就从后门进",
	"哥哥，长得吓人跟长的吓人可不是一回事。",
	"能把哥哥的手指放在我的水里转一 转吗?那样水就会变甜哦。",
	"哥哥帮我买口红,我帮哥哥口到红",
	"喜欢你是藏不住得即使捂住嘴也会从下面流出来",
	"哥哥会射箭吗，我想看哥哥击靶",
	"我好笨，想你的时候又弄得满手都是",
	"哥哥把月亮塞进我下体，然后喷出今晚的银河",
	"今晚要做小泡芙 被哥哥注满奶油",
                 "只要哥哥不喊停 厨房客厅我都行",
                 "在吗哥哥，交一下水费 最近的水都是为你流的",
                 "想做夏天的西瓜 不仅甜还水多",
                 "下雪了,你摸了摸雪 都是水 我也是",
	"小时候喜欢踩牛奶盒因为只有牛奶盒才能喷出 牛奶后来遇见了你发现你也可以"
    }
})

table.insert(kill_say.phrases, {
    name = "EN R18",
    phrases = { 
    "Your resistance only makes my penis harder!",
    "Grab them, squeeze them, pinch them, pull them, lick them, bite them, suck them!",
    "It feels like his dick is sliding into a slimy pile of macaroni!",
    "Cum, you naughty cock! Do it! Do it! DO IT!!!",
    "Ahhhh... It's like a dream come true... I get to stick my dick inside Tatsuki Chan's ass...!",
    "This is the cock block police! Hold it right there!",
    "Y-You'll break M-my womb M-Master",
    "Ohoo, getting creampied made you cum? What a lewd bitch you are!",
    "I've jerked off every single day... Given birth to countless snails... All while fantasizing about the day I'd get to fuck you!",
    "You're looking at porn when you could be using your little sister instead!",
    "Umm... I don't wanna sound rude, but have you had a bath? Your panties look a bit yellow...",
    "H-hey, hey S-Sempai... W-wanna cuddle? UwU",
    "F-fuck my bussy M-Master!",
    "Hey, who wants a piece of this plump 19-year-old boy-pussy? Single file, boys, come get it while it's hot!",
    "Kouji-Kun, if you keep thrusting that hard, my boobs will fall off!",
    "Papa you liar! How could you say that while having such a HUGE erection.",
    "I-I just wanna borrow y-your dick...",
    "Hehe don't touch me there Onii-chann UwU",
    "Your cum is all over my wet clit M-Master",
    "It Feels like you're pounding me with the force of a thousand suns Senpai",
    "I like when Y-you fill me with your baby water S-Senpai",
    "Y-yes right there S-Sempai hooyah",
    "P-please keep filling my baby chamber S-Sempai",
    "O-Onii-chan it felt so good when you punded my bussy",
    "P-please Onii-chan keep filling my baby chamber with your melty juice",
    "O-Onii-chan you just one shot my baby chamber",
    "I-Im nothing but a F-fucktoy slut for your M-monster fuckmeat!",
    "Dominate my ovaries with your vicious swimmers!",
    "Impregnate me with your viral stud genes!",
    "M-My body yearns for your sweet dick milk",
    "Y-Your meat septer has penetrated my tight boy hole",
    "M-My nipples are being tantalized",
    "Mnn FASTER... HARDER! Turn me into your femboy slut~!",
    "Penetrate me until I bust!",
    "Mmmm- soothe me, caress me, Fuck me, breed me!",
    "Probe your thick, wet, throbbing cock deeper and deeper into my boipussy~!!",
    "I'm your personal cum bucket!!",
    "Hya! Not my ears! Ah... It tickles! Ah!",
    "Can you really blame me for getting a boner after seeing that?",
    "The two of us will cover my sis with our cum!",
    "Kouta... I can't believe how BIG his... Wait! Forget about that!! Is Nyuu-chan really giving him a Tit-Fuck!?",
    "Senpai shove deeper your penis in m-my pussy (>ω<) please",
    "This... This is almost like... like somehow I'm the one raping him!",
    "I'm coming fwom you fwuking my asshole mmyyy!",
    "Boys just can't consider themselves an adult... Until they've had a chance to cum with a girl's ampit.",
    "P-Please be gentle, Goku-Senpai!",
    "We're both gonna fuck your pussy at the same time!"
       
        
    }
})

table.insert(kill_say.phrases, {
    name = "CN",
    phrases = {
        "唯一低於你的 k/d 比率的是你的陰莖大小。",
        "你為什麼想念？我不是你的女朋友。",
        "你媽媽吞下你會更好。",
        "你太醜了,你出生的時候,他們在孵化器上放了一個深色玻璃。",
        "當上帝給出情報時,你在廁所嗎？",
        "如果你的智商高出兩個智商,你就可以成為炸薯條了。",
        "盡快為您的黑客請求退款。",
        "你為什麼在這裡？同性戀酒吧就在兩個街區之外。",
        "誰在這場比賽中放置了機器人？",
        "很多人貪錢,你為什麼要免費做？",
        "你是那種在 1v1 比賽中獲得第三名的球員。",
        "我的k/d比比你的智商高。",
        "你就像樓梯：黑暗而狹窄。",
        "你為什麼接受比賽,你知道你很爛。",
        "停止使用 EzFrags,購買普通作弊器。",
        "用你媽媽的 OnlyFans 錢買一個更好的黑客。",
        "我不明白你為什麼哭,才24cm。",
        "你就像一個避孕套,你完蛋了。",
        "你真的為了那個作弊出賣了你的肛門處女嗎？",
        "你是墮胎合法化的原因。",
        "如果我從你的自我跳到你的智慧,我會在中途餓死。",
        "唯一比你更不靠譜的就是你爸用的避孕套了。",
        "最好買電腦,別在學校圖書館玩了。",
        "有些嬰兒是摔在頭上的,但你顯然是被扔在牆上的。",
        "也許上帝讓你有點太特別了。",
        "我不是說我討厭你,但我會拔掉你的生命支持來給我的手機充電。",
        "老實說,你是智障！",
        "我沒有說謊,殺你太容易了。",
        "你就像一個球,我可以踢你。",

        "你的作弊不是問題,而是你出生的問題。",
        "當我操你妹妹時,我聽到你父親在壁櫥裡自慰。",
        "嗚嗚嗚,你死了。",
        "我的 k/d 比率更高你的殺戮。",
        "誰問你想要什麼？你死了。",
        "你為這個作弊付出了代價嗎？很遺憾......",
        "我看到你用AA。用你的大腦怎麼樣？",
        "Sheeeeesh,我比你好。",
        "如果你的智商和你死的一樣多,也許你就不會流口水了。",
        "我看你喜歡看killcam,因為你總是死。",
        "你死定了,該從電腦上起來找個女朋友了。",
        "當我操你媽媽的時候,我不知道我做了什麼。9個月後......你出生了。",
        "從你的電腦上拔下電源線。在裡面小便,會發生和現在一樣的事情。你會死的。",
        "你有沒有嘗試過成為正常人？",
        "你這麼笨,還是有人幫你？"
    }
})

table.insert(kill_say.phrases, {
    name = "EN",
    phrases = {
        "The only thing lower than your k/d ratio is your penis size.",
        "Why you miss? Im not your girlfriend.",
        "Your mother would have done better to swallow you.",
        "You are so ugly that they put a dark glass on the incubator when you were born.",
        "When God gave out intelligence, were you in the toilet?",
        "If your IQ was two IQ's higher, you could be a French fry.",
        "As soon as possible, ask for a refund for your hack.",
        "Why are you here? The gay bar is two blocks away.",
        "Who put bots in this match?",
        "Many people suck for money, why do you do it for free?",
        "You're the type of player to get 3rd place in a 1v1 match.",
        "My k/d ratio higher than your IQ.",
        "You're like the staircase: dark and confined.",
        "Why did you accept the match, you knew you sucked.",
        "Stop using EzFrags, buy normal cheat.",
        "Buy a better hack with your mother's OnlyFans money.",
        "I don't understand why you're crying, it's only 24cm.",
        "You're like a condom, you're fucked.",
        "Did you really sold your anal virginity for that cheat?",
        "You're the reason abortion was legalized.",
        "If I jumped from your ego to your intelligence, Id die of starvation half-way down.",
        "The only thing more unreliable than you is the condom your dad used.",
        "Better buy PC, stop playing at school library.",
        "Some babies were dropped on their heads but you were clearly thrown at a wall.",
        "Maybe God made you a bit too special.",
        "I'm not saying I hate you, but I would unplug your life support to charge my phone.",
        "I'll be honest, you're retarded!",
        "I'm not lying, it was too easy to kill you.",
        "You're like a ball, I could kick you.",

        "Your cheat is not the problem, but that you were born.",
        "When I fucked your sister, I heard your father masturbating in the closet.",
        "Boooooooooom, u died.",
        "My k/d ratio higher your kills.",
        "Who asked what u wannt? You died.",
        "Did you pay for this cheat? It was a pity...",
        "I see you use AA. How about using your brain?",
        "Sheeeeesh, I am better than you.",
        "If you had as much IQ as you've died, maybe you wouldn't drool.",
        "I see you like watching killcam because you always die.",
        "You're dead, time to get up from the computer and get a girlfriend.",
        "When I fucked your mother I didn't know what i did. After 9 month..... u born.",
        "Unplug the power cable from your computer. Pee in it, the same thing will happen as now. You will die.",
        "Have you ever tried being normal?",
        "Are you that stupid, or is someone helping you?"
    }
})

table.insert(kill_say.phrases, {
    name = "RU",
    phrases = {
    "сьебался нахуй таракан усатый", "мать твою ебал", "нахуй ты упал иди вставай и на завод",
    "не по сезону шуршишь фраер",
    "ИЗИ ЧМО ЕБАНОЕ",
    "ливай блять не позорься",
    "AХАХ ПИДОР УПАЛ С ВАНВЕЯ ХАХАХА ОНЛИ БАИМ В БОДИ ПОТЕЕТ НА ФД АХА", "АХАХА УЛЕТЕЛ ЧМОШНИК",
    "1 МАТЬ ЖАЛЬ",
    "тебе права голоса не давали thirdworlder ебаный",
    "на завод иди",
    "не не он опять упал на конлени",
    "вставай заебал, завтра в школу", "гет гуд гет иди нахуй",
    "ну нет почему он ложится когда я прохожу", "у тебя ник нейм адео?", "парень тебе ник придумать?",
    "такой тупой :(",
    "хватит получать хс,лучше возьми свою руку и иди дрочи",
    "нет нет этот крякер такой смешной",
    "1 сын шлюхи",
    "1 мать твою ебал",
    "преобрети мой кфг клоун",
    "об кафель голову разбил?",
    "мать твою ебал",
    "хуесос дальше адайся ко мне",
    "ещё раз позови к себе на бекап",
    "не противник",
    "ник нейм дориан(",
    "iq ?",
    "упал = минус мать", "не пиши мне",
    "жаль конечно что против тебя играю, но куда деваться", "адиничкой упал", "сынок зачем тебе это ?",
    "давно в рот берёшь?", "мне можно", "ты меня так заебал, ливни уже",
    "ничему жизнь не учит (", "я не понял, ты такой жирный потомучто дошики каждый день жрешь?",
    "братка го я тебе бекап позову", "толстяк даже пройти спокойно не может"
    }
})



ui.group_name = "Kill Say"
ui.is_enabled = menu.add_checkbox(ui.group_name, "Kill Say", false)

ui.current_list = menu.add_selection(ui.group_name, "Phrase List", (function()
    local tbl = {}
    for k, v in pairs(kill_say.phrases) do
        table.insert(tbl, ("%d. %s"):format(k, v.name))
    end

    return tbl
end)())

kill_say.player_death = function(event)

    if event.attacker == event.userid or not ui.is_enabled:get() then
        return
    end

    local attacker = entity_list.get_player_from_userid(event.attacker)
    local localplayer = entity_list.get_local_player()

    if attacker ~= localplayer then
        return
    end

    local current_killsay_list = kill_say.phrases[ui.current_list:get()].phrases
    local current_phrase = current_killsay_list[client.random_int(1, #current_killsay_list)]:gsub('\"', '')
    
    engine.execute_cmd(('say "%s"'):format(current_phrase))
end

callbacks.add(e_callbacks.EVENT, kill_say.player_death, "player_death")

local paimon_images = {}
for i = 0, 72 do
    paimon_images[i] = render.load_image("./csgo/hutao/" .. i .. ".png")
end

function renderPaimon(pos, size)
    local frame = math.floor(global_vars.real_time() / 0.075) % 71
    render.texture(paimon_images[frame].id, pos, size)
end

function messageBox(pos)
    if show then
        if message == nil then
            return
        else
            local size = render.get_text_size(console, message)
            local tempTime = global_vars.real_time()

            for i = 0, 2 do
                render.rect(vec2_t.new(pos.x + size.x / 2 + 64 + i * 9, pos.y - 9), vec2_t.new(size.x / 2 - 73 + i * 9, 9 + 10), color_t.new(0, 0, 0, 255))
                render.polyline({vec2_t.new(pos.x + size.x / 2 + 64 + i * 9, pos.y + 9), vec2_t.new(pos.x + size.x / 2 + 64 + i * 9, pos.y + 9 + 11), vec2_t.new(pos.x + size.x / 2 + 73 + i * 9, pos.y + 9)}, color_t.new(0, 0, 0, 255))
                render.polygon({vec2_t.new(pos.x + size.x / 2 + 65 + i * 9, pos.y + 8), vec2_t.new(pos.x + size.x / 2 + 65 + i * 9, pos.y + 9 + 10), vec2_t.new(pos.x + size.x / 2 + 73 + i * 9, pos.y + 8)}, color_t.new(255, 255, 255, 255))
                render.rect(vec2_t.new(pos.x + size.x / 2 + 73 + i * 9, pos.y - 9), vec2_t.new(size.x / 2 - 73 - i * 9, 9 + 10), color_t.new(0, 0, 0, 255))
            end

            render.rect_filled(vec2_t.new(pos.x, pos.y - 8), vec2_t.new(size.x, 8 + 9), color_t.new(255, 255, 255, 255))
            render.text(console, message, vec2_t.new(pos.x, pos.y - 7), color_t.new(0, 0, 0, 255))

            if tempTime >= time + paimon_logs_timer:get() then
                show = false
            end
        end
    else
        time = global_vars.real_time()
    end
end

callbacks.add(e_callbacks.PAINT, function()
    local screen = render.get_screen_size()
    local in_game = engine.is_in_game()

    if paimon_enable:get() == true then
        local w = nil
        local h = nil

        local tp = menu.find("Visuals", "View", "Thirdperson", "Enable")[2]
        local tpDistance = menu.find("Visuals", "View", "Thirdperson", "Distance")

        if w == nil then
            if tpDistance:get() >= 200 then
                if tp == false then
                    w = math.floor(397 / 3)
                else
                    w = math.floor(397 / 4)
                end
            else
                w = math.floor(397 / 3)
            end
        end

        if h == nil then
            if tpDistance:get() >= 200 then
                if tp == false then
                    h = math.floor(465 / 3)
                else
                    h = math.floor(465 / 4)
                end
            else
                h = math.floor(465 / 3)
            end
        end

        if not in_game then
            return
        end

        if tp:get() == true then
            renderPaimon(vec2_t.new(screen.x / 2 - w / 2 + 400 - tpDistance:get(), screen.y / 2 - h / 2), vec2_t.new(w, h))
        else
            renderPaimon(vec2_t.new(screen.x / 2 - w / 2, screen.y - h / 2 - 190), vec2_t.new(w, h))
        end

        if paimon_logs:get() == true then
            if tp:get() == true then
                messageBox(vec2_t.new(screen.x / 2 - w / 2 + 230 - tpDistance:get(), screen.y / 2 - h / 2 - 10))
            else
                messageBox(vec2_t.new(screen.x / 2 - w / 2 + 30, screen.y / 2 + h / 2 - 10))
            end
        end
    end
end)


callbacks.add(e_callbacks.AIMBOT_SHOOT, function(shot)
    local target = shot.player
    local damage = shot.damage
    local hitgroup = hitboxes[shot.hitgroup]
    local hitchance = shot.hitchance

    message = string.format("You shot at %s for %s damage! He has %s HP left! You shot his %s with a Hit Chance of %s!", target:get_name(), damage, target:get_prop("m_iHealth"), hitgroup, hitchance)
    show = true
end)

callbacks.add(e_callbacks.AIMBOT_MISS, function(miss)
    local target = miss.player

    -- 確認目標不為nil
    if target == nil then
        return
    end

    local wanted_hitgroup = hitboxes[miss.aim_hitgroup]
    local hitchance = miss.aim_hitchance
    local reason = miss.reason_string

    message = string.format("You missed shot to %s due to %s! He has %s HP left! You tried hit his %s with a Hit Chance of %s!", target:get_name(), reason, target:get_prop("m_iHealth"), wanted_hitgroup, hitchance)
    show = true
end)

local multi_selection = menu.add_multi_selection("Animation", "options", {"Static Legs", "Zero Pitch On Land", "Static Legs In Air", "Balance modification"})
local ground_tick = 1
local end_time = 0

callbacks.add(e_callbacks.ANTIAIM, function(ctx)
    local lp = entity_list.get_local_player()
    local on_land = bit.band(lp:get_prop("m_fFlags"), bit.lshift(1,0)) ~= 0
    local air = lp:get_prop("m_vecVelocity[2]") ~= 0   
    local move = lp:get_prop("m_vecVelocity[0]")   
    local curtime = global_vars.cur_time()
        if multi_selection:get(1) then
            ctx:set_render_pose(e_poses.RUN, 0)
        end
        if multi_selection:get(2) then
            if on_land == true then
                ground_tick = ground_tick + 1
            else
                ground_tick = 0
                end_time = curtime + 1
            end
            if ground_tick > 1 and end_time > curtime then
                ctx:set_render_pose(e_poses.BODY_PITCH, 0.5)
            end
        end
        if multi_selection:get(3) then
            ctx:set_render_pose(e_poses.JUMP_FALL, 1)
        end
        if multi_selection:get(4) then
            if move ~= 0 then
            ctx:set_render_animlayer(e_animlayers.LEAN, 1)
        end
    end
end)

local pixel = render.create_font("Arial", 12, 0, e_font_flags.OUTLINE)

--binds
local isDT = menu.find("aimbot", "general", "exploits", "doubletap", "enable") -- get doubletap
local isHS = menu.find("aimbot", "general", "exploits", "hideshots", "enable") -- get hideshots
local isAP = menu.find("aimbot", "general", "misc", "autopeek", "enable") -- get autopeek
local isSW = menu.find("misc", "main", "movement", "slow walk", "enable") -- get Slow Walk
local min_damage_a = menu.find("aimbot", "auto", "target overrides", "force min. damage")
local min_damage_s = menu.find("aimbot", "scout", "target overrides", "force min. damage")
local min_damage_r = menu.find("aimbot", "revolver", "target overrides", "force min. damage")
local min_damage_d = menu.find("aimbot", "deagle", "target overrides", "force min. damage")
local min_damage_p = menu.find("aimbot", "pistols", "target overrides", "force min. damage")
local min_damage_awp = menu.find("aimbot", "awp", "target overrides", "force min. damage")
local amount_auto = unpack(menu.find("aimbot", "auto", "target overrides", "force min. damage"))
local amount_scout = unpack(menu.find("aimbot", "scout", "target overrides", "force min. damage"))
local amount_awp = unpack(menu.find("aimbot", "awp", "target overrides", "force min. damage"))
local amount_revolver = unpack(menu.find("aimbot", "revolver", "target overrides", "force min. damage"))
local amount_deagle = unpack(menu.find("aimbot", "deagle", "target overrides", "force min. damage"))
local amount_pistol = unpack(menu.find("aimbot", "pistols", "target overrides", "force min. damage"))
local isBA = menu.find("aimbot", "scout", "target overrides", "force hitbox") -- get froce baim
local isSP = menu.find("aimbot", "scout", "target overrides", "force safepoint") -- get safe point
local isAA = menu.find("antiaim", "main", "angles", "yaw base") -- get yaw base
local isRS = menu.find("aimbot", "general", "aimbot", "body lean resolver", "enable")

local function getweapon()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end

    local weapon_name = nil

    if local_player:get_prop("m_iHealth") > 0 then

        local active_weapon = local_player:get_active_weapon()
        if active_weapon == nil then return end

        weapon_name = active_weapon:get_name()


    else return end

    return weapon_name

end

--indicators
local fake = antiaim.get_fake_angle()
local currentTime = global_vars.cur_time
local function indicators2()
    if not engine.is_connected() then
        return
    end

    if not engine.is_in_game() then
        return
    end

    local local_player = entity_list.get_local_player()

    if not local_player:get_prop("m_iHealth") then
        return
    end
	
	    -- Check if indicators are enabled using the is_enabled checkbox
    if not is_enabled:get() then
        return
    end
	
    --screen size
    local x = render.get_screen_size().x
    local y = render.get_screen_size().y

    --invert state
    if antiaim.is_inverting_desync() == false then
        invert = "R"
    else
        invert = "L"
    end

    --screen size
    local ay = 20
    local alpha = math.floor(math.abs(math.sin(global_vars.real_time() * 3)) * 255) -- Lazy so borrowed from Wizuh | https://primordial.dev/resources/crosshair-indicators-roll-indicator-included.167/
    if local_player:is_alive() then -- check if player is alive
        --render
        local eternal_ts = render.get_text_size(pixel, "UMBRAL ")
        render.text(pixel, "UMBRAL ", vec2_t(x / 2, y / 2 + ay), color_t(220, 135, 49, 255), 12, true)
        render.text(pixel, "TECH", vec2_t(x / 2 + eternal_ts.x - 2, y / 2 + ay), color_t(220, 135, 49, alpha), 10, true)
        ay = ay + 10

        local text_ = ""
        local clr0 = color_t(0, 0, 0, 0)
        if isSW[2]:get() then
            text_ = "DANGEROUS "
            clr0 = color_t(255, 0, 0, 255)
        else
            text_ = "DYNAMIC "
            clr0 = color_t(180, 159, 230, 255)
        end

        local d_ts = render.get_text_size(pixel, text_)
        render.text(pixel, text_, vec2_t(x / 2, y / 2 + ay), clr0, 10, true)
        render.text(pixel, math.floor(fake) .. "", vec2_t(x / 2 + d_ts.x, y / 2 + ay), color_t(255, 255, 255, 0), 10, true)
        ay = ay + 10

        local fake_ts = render.get_text_size(pixel, "FAKE YAW: ")
        render.text(pixel, "FAKE YAW:", vec2_t(x / 2, y / 2 + ay), color_t(120, 128, 200, 255), 10, true)
        render.text(pixel, invert, vec2_t(x / 2 + fake_ts.x, y / 2 + ay), color_t(180, 159, 230, 255), 10, true)
        ay = ay + 10

        local asadsa = math.min(math.floor(math.sin((exploits.get_charge() % 2) * 1) * 122), 100)
        if isAP[2]:get() and isDT[2]:get() then
            local ts_tick = render.get_text_size(pixel, "IDEALTICK ")
            render.text(pixel, "IDEALTICK", vec2_t(x / 2, y / 2 + ay), color_t(180, 159, 230, 255), 10, true)
            render.text(pixel, "x" .. asadsa, vec2_t(x / 2 + ts_tick.x, y / 2 + ay), exploits.get_charge() == 1 and color_t(0, 255, 0, 255) or color_t(255, 0, 0, 255), 10, true)
            ay = ay + 10
        else
            if isAP[2]:get() then
                render.text(pixel, "PEEK", vec2_t(x / 2, y / 2 + ay), color_t(180, 159, 230, 255), 10, true)
                ay = ay + 10
            end
            if isDT[2]:get() then
                if exploits.get_charge() >= 1 then
                    render.text(pixel, "DT", vec2_t(x / 2, y / 2 + ay), color_t(0, 255, 0, 255), 10, true)
                    ay = ay + 10
                end
                if exploits.get_charge() < 1 then
                    render.text(pixel, "DT", vec2_t(x / 2, y / 2 + ay), color_t(255, 0, 0, 255), 10, true)
                    ay = ay + 10
                end
            end
        end
        if getweapon() == "ssg08" then
            if min_damage_s[2]:get() then
                render.text(pixel, "DMG: " .. tostring(amount_scout:get()), vec2_t(x / 2, y / 2 + ay), color_t(180, 159, 230, 255), 10, true)
                ay = ay + 10
            end
        elseif getweapon() == "deagle" then
            if min_damage_d[2]:get() then
                render.text(pixel, "DMG: " .. tostring(amount_deagle:get()), vec2_t(x / 2, y / 2 + ay), color_t(180, 159, 230, 255), 10, true)
                ay = ay + 10
            end
        elseif getweapon() == "revolver" then
            if min_damage_r[2]:get() then
                render.text(pixel, "DMG: " .. tostring(amount_revolver:get()), vec2_t(x / 2, y / 2 + ay), color_t(180, 159, 230, 255), 10, true)
                ay = ay + 10
            end
        elseif getweapon() == "awp" then
            if min_damage_awp[2]:get() then
                render.text(pixel, "DMG: " .. tostring(amount_awp:get()), vec2_t(x / 2, y / 2 + ay), color_t(180, 159, 230, 255), 10, true)
                ay = ay + 10
            end
        elseif getweapon() == "scar20" or getweapon() == "g3sg1" then
            if min_damage_a[2]:get() then
                render.text(pixel, "DMG: " .. tostring(amount_auto:get()), vec2_t(x / 2, y / 2 + ay), color_t(180, 159, 230, 255), 10, true)
                ay = ay + 10
            end
        elseif getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" then
            if min_damage_p[2]:get() then
                render.text(pixel, "DMG: " .. tostring(amount_pistol:get()), vec2_t(x / 2, y / 2 + ay), color_t(180, 159, 230, 255), 10, true)
                ay = ay + 10
            end
        end

        if isRS[2]:get() then
            render.text(pixel, "RS", vec2_t(x / 2, y / 2 + ay), color_t(120, 128, 200, 255), 12, true)
            ay = ay + 10
        end

        local ax = 0
        if isHS[2]:get() then
            render.text(pixel, "HS", vec2_t(x / 2, y / 2 + ay), color_t(120, 128, 200, 255), 12, true)
            ay = ay + 10
        end

        render.text(pixel, "BAIM", vec2_t(x / 2, y / 2 + ay), isBA[2]:get() == 2 and color_t(255, 255, 255, 0) or color_t(255, 255, 255, 0), 10, true)
        ax = ax + render.get_text_size(pixel, "BAIM ").x

        render.text(pixel, "FS", vec2_t(x / 2 + ax, y / 2 + ay), isAA:get() == 5 and color_t(255, 255, 255, 0) or color_t(255, 255, 255, 0), 10, true)
    end
end

function setleft()
    local lp = entity_list.get_local_player()
    if not lp or lp == nil then
        return
    end

    local weapon = lp:get_active_weapon()
    if not weapon or weapon == nil then
        return
    end

    local weapon_name = weapon:get_name()

    if weapon_name == 'knife' and enable_lefthand:get() then
        lefthand:set_int(1) -- 將左手設置為1，即將刀子放在左手
    else
        lefthand:set_int(0) -- 其他武器放在右手
    end
end

local custom_font = render.create_font("Verdana.ttf", 14, 400, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)

local function Watermark()
    if Water_tog:get() then
        local fps = client.get_fps()
	    local lua_ver = "Stable"
	    local lua_log = "v1.0.5"
        local WatermarkText = string.format(" Umbral.tech | " .. lua_ver .. " " .. lua_log .. " | " .. user.name .. " | " .. fps .. " fps")
        
        local text_size = render.get_text_size(custom_font, WatermarkText)
        
        render.rect_filled(vec2_t(10, 17), vec2_t(text_size.x + 10, 3), Line_Col:get())
        render.rect_filled(vec2_t(10, 18), vec2_t(text_size.x + 10, 17), Background_Col:get())
        render.text(custom_font, WatermarkText, vec2_t(10, 19), Water_Col:get())
    end
end

local elements = {
    enable = menu.add_checkbox("Misc", "Sk33t Peek", false),
}

-- Set fixed values for other elements
local fixedSize = 25
local fixedSegments = 16
local fixedStep = 12
local fixedMultiplier = 3

-- Set the fixed values for the elements
elements.size = fixedSize
elements.segments = fixedSegments
elements.step = fixedStep
elements.multiplier = fixedMultiplier

-- Remove the previous lines that set values for the fixed elements.

local color = elements.enable:add_color_picker("color")
callbacks.add(e_callbacks.PAINT, function()
    color_get = color:get()
    local r, g, b = color_get.r, color_get.g, color_get.b
    local position = ragebot.get_autopeek_pos()
    local local_player = entity_list.get_local_player()
    if position ~= nil and elements.enable:get() then   
        local circle_size = fixedSize
        local num_segments = fixedSegments
        local step = fixedStep / 10
        
        for i = 1, circle_size, step do
            local a = math.ceil(math.log(1/3 * 255) / math.log(i + fixedMultiplier * 10))
            if math.pow(a, 2) / 1.3 < i then
                a = math.ceil(a / 0.7)
            end
            if a > 100 then goto skip end

            local vertices = {}
            for j = 0, num_segments do
                local angle = (j / num_segments) * math.pi * 2
                local x = math.cos(angle) * (circle_size - i)
                local y = math.sin(angle) * (circle_size - i)
                local pos = render.world_to_screen(position + vec3_t(x, y, 0))
                table.insert(vertices, pos)
            end
            if local_player:is_alive() then
                render.polygon(vertices, color_t(r, g, b, a))
            end
            ::skip::
        end
    end
end)


local primordial = {}
primordial.scouthitchance= menu.find("aimbot", "scout", "targeting", "hitchance")

local hitchance_saved = primordial.scouthitchance:get()



local function handle_visibility()

    luamenu.hitchanceslider:set_visible(luamenu.toggle:get() == true)

end

local function handle_hitchance_air()

    if not engine.is_connected() or not engine.is_in_game() then
        return
    else

    local localplayer   = entity_list.get_local_player()
    local isAir = localplayer:get_prop("m_vecVelocity[2]") ~= 0

        if isAir == false then
            primordial.scouthitchance:set(hitchance_saved)

        else
            primordial.scouthitchance:set(luamenu.hitchanceslider:get())
        end

    end
end

local function Jump_Scout()

    handle_visibility()

    if luamenu.toggle:get() == true then
        handle_hitchance_air()
    end

end

local function on_shutdown()
    primordial.scouthitchance:set(hitchance_saved)
end


local function CombinedCallback()
    HookRender()
    on_paint()
    indicators2()
    Watermark()
    Jump_Scout()
end

callbacks.add(e_callbacks.PAINT, CombinedCallback)
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.NET_UPDATE, setleft)
callbacks.add(e_callbacks.ANTIAIM, HookAntiaim)
--end