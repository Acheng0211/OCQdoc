# 设置Docsify服务的端口号（默认是3000）
$Port = 3000

# 启动Docsify服务
Start-Process cmd -ArgumentList "/c docsify serve" -WindowStyle Hidden

# 等待几秒钟，确保服务已经启动
# Start-Sleep -Seconds 1

# 打开默认的Web浏览器并访问localhost
Start-Process "http://localhost:$Port"