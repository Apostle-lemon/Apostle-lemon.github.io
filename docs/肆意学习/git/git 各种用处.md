# Git 各种用处

## Git 删除已经 Add 的⽂件

`git rm --cached <path/to/file> `，不删除物理⽂件，仅将该⽂件从缓存中删除

## Git Pull --rebase

如果想要一个相对好看的分支，那么

git add .  
git commit -m xxx  
git push 报错

git pull --rebase  
修改完冲突后，git add .，git rebase --continue  
git commit  
git push
