local SCRIPT_NAME = "Organized Output Directory MOD"
local VERSION_STRING = "1.0.4"

local GITHUB_PROJECT_URL = "https://github.com/MrMartin92/obs_organized_output_directory"
local GITHUB_PROJECT_LICENCE_URL = "https://raw.githubusercontent.com/MrMartin92/obs_organized_output_directory/main/LICENSE"
local GITHUB_PROJECT_BUG_TRACKER_URL = GITHUB_PROJECT_URL .. "/issues"
local GITHUB_AUTHOR_URL = "https://github.com/MrMartin92"
local TWITCH_AUTHOR_URL = "https://twitch.tv/MrMartin_"
local KOFI_URL = "https://ko-fi.com/MrMartin_"

local name_source_enum = {
    ["Window Title"] = 0,
    ["Process Name"] = 1
}

local DEFAULT_SCREENSHOT_SUB_DIR = "Screenshots"
local DEFAULT_REPLAY_SUB_DIR = "Replays"
local DEFAULT_NAME_SOURCE = name_source_enum["Window Title"]
local DEFAULT_additionalfiles_ext = ".txt"
local DEFAULT_safeallowed_chars = "_'"

local cfg_screenshot_sub_dir
local cfg_replay_sub_dir
local cfg_name_source
local cfg_additionalfiles_ext
local cfg_safeallowed_chars

local obs = obslua

function script_description()
    return "<h1>" .. SCRIPT_NAME .. "</h1><p>\z
    With \"" .. SCRIPT_NAME .. "\" you can create order in your output directory. \z
    The script automatically creates subdirectories for each game in the output directory. \z
    To do this, it searches for Window Capture or Game Capture sources in the current scene. \z
    The last active and hooked source is then used to determine the name of the subdirectory from the window title or the process name.<p>\z
    You found a bug or you have a feature request? Great! <a href=\"" .. GITHUB_PROJECT_BUG_TRACKER_URL .. "\">Open an issue on GitHub.</a><p>\z
    
    <b>🚀 Version:</b> " .. VERSION_STRING .. "<br>\z
    <b>🧑‍💻 Author:</b> Tobias Lorenz <br>\z
	<b>🧑‍💻 Extended by:</b> SplitCoreGaming <br>\z
    <b>🔬 Source:</b> <a href=\"" .. GITHUB_PROJECT_URL .. "\">GitHub.com</a><br>\z
    <b>🧾 Licence:</b> <a href=\"" .. GITHUB_PROJECT_LICENCE_URL .. "\">MIT</a>"
end

function script_properties()
    local props = obs.obs_properties_create()

    obs.obs_properties_add_text(props, "SCREENSHOT_SUB_DIR", "Screenshot directory name", obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_text(props, "REPLAY_SUB_DIR", "Replay directory name", obs.OBS_TEXT_DEFAULT)
	obs.obs_properties_add_text(props, "additionalfiles_ext", "Addtional File Ext", obs.OBS_TEXT_DEFAULT)
	obs.obs_properties_add_text(props, "safeallowed_chars", "Allow Non Standard Chars", obs.OBS_TEXT_DEFAULT)	

    local props_name_source = obs.obs_properties_add_list(props, "NAME_SOURCE", "Name source", obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_INT)
    for name, value in pairs(name_source_enum) do
        obs.obs_property_list_add_int(props_name_source, name, value)
    end

    return props
end

function script_update(settings)
    print("script_update()")

    cfg_screenshot_sub_dir = obs.obs_data_get_string(settings, "SCREENSHOT_SUB_DIR")
    cfg_replay_sub_dir = obs.obs_data_get_string(settings, "REPLAY_SUB_DIR")
    cfg_name_source = obs.obs_data_get_int(settings, "NAME_SOURCE")
	cfg_additionalfiles_ext = obs.obs_data_get_string(settings, "additionalfiles_ext")
	cfg_safeallowed_chars = obs.obs_data_get_string(settings, "safeallowed_chars")
end

function script_defaults(settings)
    print("script_defaults()")

    obs.obs_data_set_default_string(settings, "SCREENSHOT_SUB_DIR", DEFAULT_SCREENSHOT_SUB_DIR)
    obs.obs_data_set_default_string(settings, "REPLAY_SUB_DIR", DEFAULT_REPLAY_SUB_DIR)
    obs.obs_data_set_default_int(settings, "NAME_SOURCE", DEFAULT_NAME_SOURCE)
	obs.obs_data_set_default_string(settings, "additionalfiles_ext", DEFAULT_additionalfiles_ext)
	obs.obs_data_set_default_string(settings, "safeallowed_chars", DEFAULT_safeallowed_chars)
end

local function get_filename(path)
    return string.match(path, "[^/]*$")
end

local function get_base_path(path)
    local filename_length = #get_filename(path)
    return string.sub(path, 0, -1 - filename_length)
end

local function get_source_hook_infos(source)
	local cd = obs.calldata_create()
	local proc = obs.obs_source_get_proc_handler(source)

	obs.proc_handler_call(proc, "get_hooked", cd)
    local hooked = obs.calldata_bool(cd, "hooked")
	local executable = obs.calldata_string(cd, "executable")
	local title = obs.calldata_string(cd, "title")

	obs.calldata_destroy(cd)

	return executable, title, hooked
end

local function search_for_capture_source_and_get_data()
    local process_name, window_name
    local sources = obs.obs_enum_sources()

    for _, source in ipairs(sources) do
        if obs.obs_source_active(source) then
            local tmp_process_name, tmp_window_title, tmp_hooked = get_source_hook_infos(source)
    
            if tmp_hooked then
                process_name = tmp_process_name
                window_name = tmp_window_title
            end
        end
    end

    return process_name, window_name
end

local function get_game_name()
    print("get_game_name()")

    local executable, title = search_for_capture_source_and_get_data()

    if executable ~= nil then
        print("\tExecutable: " .. executable)
    end
    if title ~= nil then
        print("\tWindow title: " .. title)
    end

    if cfg_name_source == name_source_enum["Process Name"] then
        return executable
    end

    return title
end

local function move_file(src, dst)
    print("move_file()")
	
    obs.os_mkdirs(get_base_path(dst))
	
	local srcext = src:match("%..+$")
	print(srcext)
	print(cfg_additionalfiles_ext)
	
	local src = string.gsub(src, srcext, "")
	print("\t Src: " .. src)
	
	local dst = string.gsub(dst, srcext, "")
	print("\t Dst: " .. dst)
	
    if not obs.os_file_exists(dst .. srcext) then
	
	    obs.os_rename(src .. srcext, dst .. srcext)
		
		if obs.os_file_exists(src .. cfg_additionalfiles_ext) then
		    if not obs.os_file_exists(dst .. cfg_additionalfiles_ext) then
	            obs.os_rename(src .. cfg_additionalfiles_ext, dst .. cfg_additionalfiles_ext)
		    end
		end
		
	else
        print("File aready exist at the destination! So we don't move the file!")
    end
end

local function sanitize_path_string(path)
    path = string.gsub(path, "^ +", "") -- Remove leading whitespaces
    path = string.gsub(path, " +$", "") -- Remove trailing whitespaces
    path = string.gsub(path, "[^%w %+%-%(%)%." .. cfg_safeallowed_chars .. "]", "") -- Remove illegal path characters for Windows
	-- [™<>:\\/\"|?*] 
    return path
end

local function screenshot_event()
    print("screenshot_event()")

    local file_path = obs.obs_frontend_get_last_screenshot()
    local game_name = get_game_name()

    if game_name == nil then
        return
    end

    local new_file_path = get_base_path(file_path) .. sanitize_path_string(game_name) .. "/" .. sanitize_path_string(cfg_screenshot_sub_dir) .. "/".. get_filename(file_path)

    move_file(file_path, new_file_path)
end

local function replay_event()
    print("replay_event()")

    local file_path = obs.obs_frontend_get_last_replay()
    local game_name = get_game_name()

    if game_name == nil then
        return
    end

    local new_file_path = get_base_path(file_path) .. sanitize_path_string(game_name) .. "/" .. sanitize_path_string(cfg_replay_sub_dir) .. "/".. get_filename(file_path)

    move_file(file_path, new_file_path)
end

local function record_event()
    print("record_event()")

    local file_path = obs.obs_frontend_get_last_recording()
    local game_name = get_game_name()

    if game_name == nil then
        return
    end

    local new_file_path = get_base_path(file_path) .. sanitize_path_string(game_name) .. "/" .. get_filename(file_path)
    
    move_file(file_path, new_file_path)
end


local function event_dispatch(event)
    if event == obs.OBS_FRONTEND_EVENT_SCREENSHOT_TAKEN then
        screenshot_event()
    elseif event == obs.OBS_FRONTEND_EVENT_REPLAY_BUFFER_SAVED then
        replay_event()
	elseif event == obs.OBS_FRONTEND_EVENT_RECORDING_STOPPED then
		record_event()
    end
end

function script_load(settings)
    print("script_load()")
    obs.obs_frontend_add_event_callback(event_dispatch)
end
