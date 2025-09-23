#!/bin/bash

# 批量在HTML文件的</body>前添加备案信息
# 使用方法: ./add_beian.sh

# 备案信息HTML代码
BEIAN_HTML='<a href="https://beian.miit.gov.cn" style="position: absolute; width: 100%; text-align: center; color: #888;">沪ICP备2025137067号</a>'

# 查找所有HTML文件并处理
find . -name "*.html" -type f | while read -r file; do
    echo "处理文件: $file"
    
    # 检查文件是否包含</body>标签
    if grep -q "</body>" "$file"; then
        # 检查是否已经包含备案信息
        if grep -q "沪ICP备2025137067号" "$file"; then
            echo "  跳过: 已包含备案信息"
        else
            # 创建备份文件
            cp "$file" "$file.bak"
            
            # 在</body>前插入备案信息
            sed -i.tmp "s|</body>|$BEIAN_HTML\n</body>|g" "$file"
            rm "$file.tmp" 2>/dev/null
            
            echo "  完成: 已添加备案信息"
        fi
    else
        echo "  跳过: 未找到</body>标签"
    fi
done

echo "处理完成!"
echo "备份文件以 .bak 结尾，如确认无误可删除备份文件"