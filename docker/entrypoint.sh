echo "=================="
echo "== Docker setup =="
echo "=================="
echo
# Start virtual desktop in the background
nohup /usr/bin/Xvfb :0 -screen 0 1280x720x24 > /tmp/Xvfb.log 2>&1 &\
nohup /usr/bin/x11vnc -display :0 -nopw -listen localhost -xkb -forever -shared -noxdamage -noshm -passwd ${VNC_PW} > /tmp/x11vnc.log 2>&1 &\
nohup /usr/share/novnc/utils/launch.sh --vnc localhost:5900 > /tmp/novnc.log 2>&1 &\
nohup awesome > /tmp/awesome.log 2>&1 &

# Remove dekarb_nesting.egg-info
sudo rm -rf ${PROJECT_NAME}.egg-info

# Info message for the user
echo
echo "==================="
echo "=== Information ==="
echo "==================="
echo
echo "Open a display via a web browser with the following URL:"
echo
echo "  http://${HOST_IP}:${VNC_PORT}/vnc.html "
echo
echo "Attach to the container via a new terminal and the command:"
echo
echo "  docker exec -it ${USER_NAME}_${PROJECT_NAME} bash "
echo
echo "  OR "
echo
echo "  Use Vscode 'Dev Containers' Extension to attach Vscode to the container. "
echo
echo "Shut down the container using this terminal with: Ctrl + C"
echo
echo "##############################################"
# Let the container run as a server
wait
