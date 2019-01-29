#!/bin/sh

session="Webdev"

project=$1

# set up tmux
tmux start-server

# create a new tmux session and windows. 
tmux new-session -d -s $session -n logs # default window #1

tmux new-window -t $session:2 -n vim
tmux new-window -t $session:3 -n "$project"
tmux new-window -t $session:4 -n mysql

# Window 1
tmux select-window -t $session:1
tmux selectp -t 1 

# First, starting the docker container
tmux send-keys "cd /home/osef/.local/devilbox/" C-m C-l
tmux send-keys "webdocker" C-m C-l
sleep 1 

# Then, setting up environment
#Split first window
tmux splitw -h -p 50 #split first pane horizontaly
tmux splitw -v -p 50 #split second pane verticaly
tmux selectp -t 1 
tmux splitw -v -p 50 #split first pane verticaly

# Showing logs
tmux selectp -t 2 
tmux send-keys "cd /home/osef/.local/devilbox/" C-m C-l
sleep 1 
tmux send-keys "docker-compose logs -f mysql" C-m C-l
tmux selectp -t 3 
tmux send-keys "cd /home/osef/.local/devilbox/" C-m C-l
sleep 1 
tmux send-keys "docker-compose logs -f httpd" C-m C-l
tmux selectp -t 4 
tmux send-keys "cd /home/osef/.local/devilbox/" C-m C-l
sleep 1 
tmux send-keys "docker-compose logs -f php" C-m C-l

# Window 2
# Start vim
tmux select-window -t $session:2
tmux selectp -t 1 
tmux send-keys "mkdir /home/osef/Dev_Web/$project/" C-m C-l
tmux send-keys "cd /home/osef/Dev_Web/$project/;vim" C-m 


# Window 3
# Moving to the project directory
tmux select-window -t $session:3
tmux selectp -t 1 
tmux send-keys "cd /home/osef/Dev_Web/$project/" C-m C-l

# Window 4
# Connecting to Database
tmux select-window -t $session:4
tmux selectp -t 1 
tmux send-keys "cd /home/osef/.local/devilbox/" C-m C-l
sleep 1 
tmux send-keys "./shell.sh" C-m C-l
sleep 4 
tmux send-keys "mysql -u root -h 127.0.0.1 -P 3306 $project" C-m

# return to main vim window
tmux select-window -t $session:2

# Finished setup, attach to the tmux session!
tmux attach-session -t $session
