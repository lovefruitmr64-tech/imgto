@echo off
:: 设置字符编码为 UTF-8，防止中文显示乱码
chcp 65001 >nul
title 一键部署更新到 GitHub & GitHub Pages

echo =======================================================
echo        🚀 正在准备将源码及网页部署到 GitHub
echo =======================================================
echo.

:: 1. 检查是否存在 Git 仓库
if not exist ".git" (
    echo ❌ [错误] 当前目录下未找到 .git 文件夹，请确认是否在项目根目录运行！
    echo.
    pause
    exit /b
)

:: 2. 显示当前改动状态
echo 📋 [1/5] 当前工作区改动状态：
git status -s
echo.

:: 3. 提示输入提交说明（直接回车则使用默认命名）
set default_msg=feat: 新增赞助打赏页面与k资源仓会员权益
set /p commit_msg="📝 请输入提交说明 (直接按回车使用默认: %default_msg%): "

if "%commit_msg%"=="" (
    set commit_msg=%default_msg%
)

echo.
echo ⏳ [2/5] 正在添加变动文件 (git add)...
git add .

echo.
echo ⏳ [3/5] 正在提交源码版本 (git commit)...
git commit -m "%commit_msg%"

if %ERRORLEVEL% neq 0 (
    echo ⚠️ 没有检测到新的源码修改，跳过源码提交。
)

echo.
echo ⏳ [4/5] 正在推送源码到 GitHub 仓库 (git push)...
git push

if %ERRORLEVEL% neq 0 (
    echo.
    echo ❌ [推送失败] 源码推送到远程分支失败，请检查网络或认证！
    echo.
    pause
    exit /b
)

echo.
echo ⏳ [5/5] 正在编译并发布网页到 gh-pages 分支 (mkdocs gh-deploy)...
:: 核心发布命令：构建静态站点并推送到 gh-pages
call mkdocs gh-deploy --force

if %ERRORLEVEL% equ 0 (
    echo.
    echo =======================================================
    echo    🎉 恭喜！源码已保存，线上网页已成功发布到 GitHub Pages！
    echo =======================================================
) else (
    echo.
    echo =======================================================
    echo    ❌ [部署失败] mkdocs 部署出错，请检查 mkdocs.yml 配置或依赖！
    echo =======================================================
)

echo.
echo 按任意键退出...
pause >nul