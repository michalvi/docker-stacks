#!/bin/bash

# install mujoco-py(incomplete because of license) before gym, baselines
aptitude install -y -q -R libosmesa6-dev

mkdir -p ~/.mujoco \
    && wget https://www.roboti.us/download/mjpro150_linux.zip -O mujoco.zip \
    && unzip mujoco.zip -d ~/.mujoco \
    && rm mujoco.zip

export LD_LIBRARY_PATH=~/.mujoco/mjpro150/bin:$LD_LIBRARY_PATH

echo 'export LD_LIBRARY_PATH=~/.mujoco/mjpro150/bin:$LD_LIBRARY_PATH' >> ~/.bashrc


# install gym
echo "start to install openai/gym"

aptitude install -y -q -R libgtk2.0-0 libav-tools
# config alias for openai/rllab, install libav-tools firstly
echo "alias ffmpeg=\"avconv\"" >> /home/ros/.bashrc

aptitude install -y -q -R swig
pip3 install --no-cache-dir pyglet gym['atari','box2d','classic_control']

echo "install openai/gym complete!"


# install baselines with tensorflow-gpu
echo "start to install openai/baselines"
cd /opt/ &&  git clone https://github.com/openai/baselines.git
cd baselines && python3 setup.py sdist && pip3 install dist/*.tar.gz
cd / && rm -rf /opt/baselines
echo "install openai/baselines complete!"


# install dart
apt-add-repository -y ppa:dartsim/ppa
apt-get update -y
aptitude install -y -q -R libdart6-all-dev swig python3-pyqt5 python3-pyqt5.qtopengl

pip3 install numpy PyOpenGL PyOpenGL_accelerate pydart2

cd /opt; mkdir -p /opt/dart_sim/ && cd /opt/dart_sim

git clone https://github.com/DartEnv/dart-env
cd dart-env
pip3 install -e .[dart]


# start install openai/roboschool
echo "start to install openai/roboschool"

cd /opt/ && git clone https://github.com/openai/roboschool.git

export ROBOSCHOOL_PATH=/opt/roboschool

aptitude install -y -q -R cmake ffmpeg \
    pkg-config qtbase5-dev libqt5opengl5-dev libassimp-dev \
    libboost-python-dev libtinyxml-dev

# we try to replace libpython3.5-dev by libpython3-dev
aptitude install -y -q -R libpython3-dev

# for avoid opengl errors [issue #15](https://github.com/openai/roboschool/issues/15#issuecomment-308620049)
pip3 install -U --no-cache-dir pyopengl

cd /opt/ && git clone https://github.com/olegklimov/bullet3 -b roboschool_self_collision

mkdir bullet3/build && cd bullet3/build
cmake -DBUILD_SHARED_LIBS=ON -DUSE_DOUBLE_PRECISION=1 \
      -DCMAKE_INSTALL_PREFIX:PATH=$ROBOSCHOOL_PATH/roboschool/cpp-household/bullet_local_install  \
      -DBUILD_CPU_DEMOS=OFF -DBUILD_BULLET2_DEMOS=OFF -DBUILD_EXTRAS=OFF  \
      -DBUILD_UNIT_TESTS=OFF -DBUILD_CLSOCKET=OFF -DBUILD_ENET=OFF \
      -DBUILD_OPENGL3_DEMOS=OFF ..

make -j4
make install && cd /opt && pip3 install --no-cache-dir -e $ROBOSCHOOL_PATH

chmod a+rwx -R /opt/roboschool

echo "install openai/roboschool complete!"


# start install openai/rllab 
# (without mujoco_py, not following the exact version of python pacakge, and opencv3)
echo "start to install openai/rllab"

cd /opt/ && git clone https://github.com/openai/rllab.git

aptitude install -y -q -R python3-dev swig cmake build-essential zlib1g-dev python3-dateutil

pip3 install --no-cache-dir -r /opt/scripts/container/requirements.txt

# fix pytorch not spport for this python
pip3 install http://download.pytorch.org/whl/cu80/torch-0.1.12.post2-cp35-cp35m-linux_x86_64.whl
pip3 install --no-cache-dir torchvision

chmod a+rwx -R  /opt/rllab

echo "install openai/roboschool complete!"
echo "You should add rllab path to your PYTHONPATH environment variable."