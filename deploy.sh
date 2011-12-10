git add .
git commit -a -m 'Deploy'
git checkout master
git merge work
git push origin master
cap deploy:mydeploy
git checkout work

