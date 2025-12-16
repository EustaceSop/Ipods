net stop winmgmt /y
timeout 5
net start winmgmt /y
timeout 3
sc stop winmgmt 
timeout 1
sc start winmgmt