source ./docker-env.sh


echo "=============================="
echo "=== Starting the container ==="
echo "=============================="

# # Check if GPU should be used
# if [ "${USE_GPU}" = "true" ]; then
#   docker compose -p ${USER} up --force-recreate --remove-orphans
# else
#   docker compose -f docker-compose-no-gpu.yml -p ${USER} up --force-recreate --remove-orphans
# fi

docker compose -p ${USER} up --force-recreate --remove-orphans