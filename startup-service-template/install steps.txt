pre request
sudo apt install build-essential

sudo pacman -Sy base-devel

sudo dnf groupinstall "Development Tools" "Development Libraries"


install ---------------
cd intel-undervolt/
./configure --enable-systemd --enable-openrc
make
sudo make install
sudo systemctl daemon-reload

------------------------------------------------------------
copy the intel-undervolt.conf to /etc/
-------------------------------------------------------------

sudo systemctl start intel-undervolt

sudo systemctl stop intel-undervolt

sudo systemctl status intel-undervolt

sudo systemctl enable intel-undervolt
