-- save as honkit_hierarchical_toc.lua
-- 修正层级结构的 Honkit 目录生成器

local function load_file(filename)
    local f = io.open(filename, "r")
    if not f then return "" end
    local content = f:read("*a")
    f:close()
    return content
end

-- Honkit 专用锚点生成器（保持原样）
local function honkit_anchor(heading)
    -- 移除 Markdown 格式标记
    heading = heading
        :gsub("%*%*(.-)%*%*", "%1")   -- 移除粗体
        :gsub("__(.-)__", "%1")       -- 移除下划线
        :gsub("%%", "")               -- 移除百分号
    
    -- 创建基础锚点
    local anchor = heading
        :gsub("[%p]", "")  -- 移除所有标点符号
        :gsub("%s+", "-")  -- 空格替换为连字符
        :gsub("-+", "-")  -- 处理连续连字符
        :gsub("^-", "")   -- 移除开头连字符
        :gsub("-$", "")   -- 移除末尾连字符
        :lower()           -- 转换为小写
    
    -- 处理数字开头的锚点
    if tonumber(anchor:sub(1,1)) then
        anchor = "section-" .. anchor
    end
    
    return anchor
end

-- 确保锚点唯一性
local function ensure_unique_anchor(anchor, existing_anchors)
    if not existing_anchors[anchor] then
        existing_anchors[anchor] = true
        return anchor
    end
    
    local i = 1
    local new_anchor = anchor .. "-" .. i
    while existing_anchors[new_anchor] do
        i = i + 1
        new_anchor = anchor .. "-" .. i
    end
    
    existing_anchors[new_anchor] = true
    return new_anchor
end

-- 解析文件中的所有标题
local function parse_file_headings(filename)
    local content = load_file(filename)
    if content == "" then return {} end
    
    local headings = {}
    local existing_anchors = {}
    local heading_counter = 0
    
    for line in content:gmatch("[^\n]+") do
        local level, raw_heading = line:match("^(#+)%s+(.*)")
        if level and raw_heading and raw_heading ~= "" then
            heading_counter = heading_counter + 1
            local title = raw_heading:gsub("%s*$", "")  -- 移除尾部空白
            local anchor = ensure_unique_anchor(honkit_anchor(title), existing_anchors)
            
            table.insert(headings, {
                title = title,
                level = #level,
                anchor = anchor,
                order = heading_counter
            })
        end
    end
    
    return headings
end

-- 生成层级正确的目录条目
local function generate_hierarchical_toc(filename, headings)
    local toc_lines = {}
    local file_title = filename:gsub("%.md$", "")
    
    -- 文件条目（无缩进）
    table.insert(toc_lines, "* [" .. file_title .. "](" .. filename .. ")")
    
    -- 组织标题的层级关系
    local stack = {}
    
    for _, h in ipairs(headings) do
        -- 修正标题层级：文件中的一级标题变为SUMMARY中的二级标题
        local relative_level = h.level
        local indent_level = relative_level
        
        -- 如果标题前没有更高级的标题，则提升标题级别
        if relative_level == 1 then
            indent_level = 1  -- 一级标题变成缩进1级（相当于SUMMARY中的二级）
        end
        
        -- 生成缩进
        local indent = string.rep("  ", indent_level)
        local line = indent .. "* [" .. h.title .. "](" .. filename .. "#" .. h.anchor .. ")"
        
        table.insert(toc_lines, line)
    end
    
    return table.concat(toc_lines, "\n")
end

-- 主生成函数
local function create_hierarchical_summary()
    local files = {}
    local dir = io.popen('ls -1 *.md 2>/dev/null | grep -v SUMMARY.md | sort -n')
    
    if not dir then
        print("错误: 无法读取目录")
        return
    end
    
    for filename in dir:lines() do
        table.insert(files, filename)
    end
    dir:close()
    
    if #files == 0 then
        print("错误: 未找到 Markdown 文件")
        return
    end
    
    local toc_lines = {
        "# Honkit 层级目录",
        "> 文件名作为父节点，文件内标题作为子节点",
        ""
    }
    
    for _, file in ipairs(files) do
        -- 处理单个文件
        local file_headings = parse_file_headings(file)
        local file_toc = generate_hierarchical_toc(file, file_headings)
        
        table.insert(toc_lines, file_toc)
        table.insert(toc_lines, "")  -- 空行分隔不同文件
    end
    
    -- 写入文件
    local toc_content = table.concat(toc_lines, "\n")
    local outfile = io.open("SUMMARY.md", "w")
    if outfile then
        outfile:write(toc_content)
        outfile:close()
        print("\n✅ 层级目录生成成功!")
        print("处理文件数: " .. #files)
    else
        print("错误: 无法写入 SUMMARY.md 文件")
    end
end

-- 主程序
print("开始生成层级结构目录...")
create_hierarchical_summary()
