:: %time%输出时间，10点前，小时只有1位，如9:01
:: %date%输出的月、日，%time%输出的分、秒已自动加上0
@echo off
if "%time%" lss "10:00" (
    ::%date:~0,4%表示取%date%从第0位开始的4位
    ::系统时间格式设置可能不同，可根据时间格式修改%date%、%time%取值位置
    set now=%date:~0,4%-%date:~5,2%-%date:~8,2% 0%time:~1,1%:%time:~3,2%:%time:~6,2%
) else (
    set now=%date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2%
)

git add .

echo ""

git commit -m "update through script at %now%"

echo ""

git push

echo ""

echo "%now% update success"