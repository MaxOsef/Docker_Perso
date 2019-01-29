#!/bin/sh

session="Prestashop"

version=$1

# set up tmux
tmux start-server

# create a new tmux session and windows. 
tmux new-session -d -s $session -n logs # default window #1

tmux new-window -t $session:2 -n vim
tmux new-window -t $session:3 -n "directory/"
tmux new-window -t $session:4 -n mysql

# Window 1
tmux select-window -t $session:1
tmux selectp -t 1 

# First, starting the docker container
tmux send-keys "cd /home/osef/.local/devilbox/" C-m C-l
tmux send-keys "webdocker" C-m 
sleep 1

# Then, setting up environment
tmux splitw -h -p 50 #split first pane horizontaly
tmux splitw -v -p 50 #split second pane verticaly
tmux selectp -t 1 
tmux splitw -v -p 50 #split first pane verticaly

# Showing logs

# mysql logs
tmux selectp -t 2 
sleep 2
tmux send-keys "cd /home/osef/.local/devilbox/" C-m C-l
tmux send-keys "docker-compose logs -f mysql" C-m

# php logs
tmux selectp -t 3 
sleep 1
tmux send-keys "cd /home/osef/.local/devilbox/" C-m C-l
tmux send-keys "docker-compose logs -f httpd" C-m

# httpd logs 
tmux selectp -t 4 
sleep 1
tmux send-keys "cd /home/osef/.local/devilbox/" C-m C-l
tmux send-keys "docker-compose logs -f php" C-m

# Window 2
# Moving to directory and starting vim
tmux select-window -t $session:2
tmux selectp -t 1 
tmux send-keys "cd /home/osef/Dev_Web/presta$version/htdocs/;vim" C-m 


# Window 3
# Moving to the directory
tmux select-window -t $session:3
tmux selectp -t 1 
tmux send-keys "cd /home/osef/Dev_Web/presta$version/htdocs/" C-m C-l

# Window 4 
#Connecting to Database
tmux select-window -t $session:4
tmux selectp -t 1 
tmux send-keys "cd /home/osef/.local/devilbox/" C-m C-l
tmux send-keys "./shell.sh" C-m 
sleep 4
tmux send-keys "mysql -u root -h 127.0.0.1 -P 3306 presta$version" C-m

# return to main vim window
tmux select-window -t $session:2

# Finished setup, attach to the tmux session!
tmux attach-session -t $session
