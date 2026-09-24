@echo off
chcp 65001 >nul
title 部署图片转换网站至 GitHub

echo ========================================================
echo           🚀 正在准备打包并部署到 GitHub...
echo ========================================================
echo.

:: 1. 添加所有修改并提交本地 Git
echo [1/3] 正在暂存文件修改...
git add .

set /p msg=请输入本次更新备注(直接回车默认使用当前时间): 
if "%msg%"=="" (
    set msg=更新网站内容: %date% %time%
)

git commit -m "%msg%"
echo.

:: 2. 推送源码至主分支进行云端备份
echo [2/3] 正在推送源码至 GitHub 仓库...
git push origin main
if %errorlevel% neq 0 (
    echo [提示] main 分支推送未成功，正在尝试推送到 master 分支...
    git push origin master
)
echo.

:: 3. 通过 MkDocs 自动化构建并发布到 GitHub Pages
echo [3/3] 正在构建并发布网页至 GitHub Pages...
mkdocs gh-deploy --force

if %errorlevel% equ 0 (
    echo.
    echo ========================================================
    echo           🎉 部署成功！
    echo   请稍等 1~2 分钟 CDN 刷新后访问：https://imgto.de5.net/
    echo ========================================================
) else (
    echo.
    echo ========================================================
    echo           ❌ 部署遇到问题，请检查上方报错提示。
    echo ========================================================
)

echo.
pause