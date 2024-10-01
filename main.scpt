set osVersion to system version of (system info) -- 获取 macOS 的完整版本号

-- 使用 AppleScript 的 text item delimiters 来解析版本号
set text item delimiters to "."
set versionComponents to text items of osVersion

set majorVersion to item 1 of versionComponents -- 主版本号
set minorVersion to item 2 of versionComponents -- 次版本号

log "macOS majorversion: " & majorVersion
log "macOS minorversion: " & minorVersion

-- 清除 text item delimiters
set text item delimiters to ""

-- 判断主版本号
if majorVersion as integer >= 15 then
    -- 执行脚本a
    -- 获取当前系统的首选语言
    set userLanguage to do shell script "defaults read NSGlobalDomain AppleLanguages | /usr/bin/awk -F'\"' '/\"/ {print $2; exit}'"

    -- 判断系统语言
    if userLanguage is "en" or userLanguage is "en-US" then
        -- 如果语言是英语，执行英语脚本
        set scriptPath to "scrolltoggle_simple_en.scpt"
        set scriptOutput to do shell script "osascript " & quoted form of scriptPath
        return scriptOutput

    else if userLanguage is "zh-Hans" or userLanguage is "zh-Hans-CN" then
        -- 如果语言是简体中文，执行中文脚本
        set scriptPath to "scrolltoggle_simple_zh.scpt"
        set scriptOutput to do shell script "osascript " & quoted form of scriptPath
        return scriptOutput

    else
        -- 其他语言不支持
        return "Current language is not supported, only English or Chinese is supported. now: " & userLanguage
    end if
else
    -- 报告不支持
    return "Currently only macos15 is supported"
end if