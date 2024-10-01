on run
	-- 启动 System Settings 应用程序
	tell application "System Settings"
		launch
	end tell
	
	-- 等待并设置 Trackpad 面板
	tell application "System Settings"
		set paneLoaded to false -- 初始化面板加载标志
		set attemptCount to 0 -- 尝试计数
		repeat until paneLoaded or attemptCount > 20
			try
				-- 尝试设置当前面板为 Trackpad
				set current pane to pane "Trackpad"
				
				-- 检查是否成功设置
				if current pane is pane "Trackpad" then
					set paneLoaded to true -- 成功加载
				end if
			on error errMsg
				-- 捕获错误并输出日志，但继续重试
				log "Error while setting pane: " & errMsg
			end try
			set attemptCount to attemptCount + 1 -- 增加计数
			delay 0.1 -- 每次尝试后稍作等待
		end repeat
		
		-- 如果超过20次还没加载成功，退出并关闭窗口
		if attemptCount > 20 then
			tell application "System Settings" to quit
			log "无法加载 Trackpad 面板"
			return "操作失败，无法加载 Trackpad 面板"
		end if
	end tell

	-- 使用 System Events 来访问 UI 元素
	tell application "System Events"
		try
			-- 引用 System Settings 的 UI 元素
			tell process "System Settings"
				set attemptCount to 0 -- 初始化计数器
				-- 循环等待窗口加载
				repeat until (exists (first window)) or attemptCount > 20
					set attemptCount to attemptCount + 1
					delay 0.1
				end repeat
				
				-- 检查是否成功加载
				if attemptCount > 20 then
					tell application "System Settings" to quit
					log "无法加载窗口"
					return "操作失败，无法加载窗口"
				end if
				
				set trackpadWindow to first window
				
				set attemptCount to 0 -- 初始化计数器
				-- 循环等待 "Trackpad" 选项卡的单选按钮加载
				repeat until (exists (radio button 2 of tab group 1 of group 1 of group 2 of splitter group 1 of group 1 of trackpadWindow)) or attemptCount > 20
					set attemptCount to attemptCount + 1
					delay 0.1
				end repeat
				
				-- 检查是否成功加载
				if attemptCount > 20 then
					tell application "System Settings" to quit
					log "无法加载 Trackpad 选项卡"
					return "操作失败，无法加载 Trackpad 选项卡"
				end if
				
				-- 点击 Trackpad 选项卡中的第二个单选按钮
				set targetRadioButton to radio button 2 of tab group 1 of group 1 of group 2 of splitter group 1 of group 1 of trackpadWindow
				click targetRadioButton
				
				set attemptCount to 0 -- 初始化计数器
				-- 循环等待 "Natural scrolling" 复选框加载
				repeat until (exists (checkbox "Natural scrolling" of group 1 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1 of trackpadWindow)) or attemptCount > 20
					set attemptCount to attemptCount + 1
					delay 0.1
				end repeat
				
				-- 检查是否成功加载
				if attemptCount > 20 then
					tell application "System Settings" to quit
					log "无法加载 Natural scrolling 复选框"
					return "操作失败，无法加载 Natural scrolling 复选框"
				end if
				
				-- 点击 "Natural scrolling" 的复选框
				set targetCheckbox to checkbox "Natural scrolling" of group 1 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1 of trackpadWindow
				click targetCheckbox
				
				-- 获取复选框的当前状态
				set targetCheckboxState to value of targetCheckbox
			end tell
		on error errMsg
			-- 捕捉可能出现的错误并输出日志
			tell application "System Settings" to quit
			log "Error: " & errMsg
			return "操作失败，无法找到 UI 元素"
		end try
	end tell
	
	-- 关闭 System Settings
	tell application "System Settings"
		quit
	end tell
	
	-- 返回复选框状态
	if targetCheckboxState is 0 then
		log "自然滚动[关闭->打开]"
		return "自然滚动[关闭->打开]"
	else
		log "自然滚动[打开->关闭]"
		return "自然滚动[打开->关闭]"
	end if
end run
