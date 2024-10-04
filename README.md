1) buat network DOCKER <br>
docker network create perpus_net
<br><br>
2) buat database MYSQL container <br>
docker run -d --name mysql --network perpus_net -p 3306:3306 -e MYSQL_DATABASE=perpusku_gc -e MYSQL_ROOT_PASSWORD=root mysql:5.7 
<br><br> 
3) buat folder challenge2, cd ke folder challenge2<br>
<br><br>
4) clone repository  dan masuk ke folder perpus-laravel nya<br>
git clone https://github.com/omidiyanto/perpus-laravel.git
<br><br>
5) build docker image nya<br>
docker build -t img-perpus-username .
<br><br>
6) run container Laravel nya<br>
 docker run -d --name perpus-username --network perpus_net -p 8000:8000 img-perpus-username:latest ./setup.sh
<br><br>
7) akses di browser:<br>
IP_ADDRESS:8000
