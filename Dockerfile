FROM morsm6777/raspbian-stretch-mono:latest

LABEL description="HippoPiPwmDaemon mono container"

# Get and compile WiringPi
RUN git clone -b final_official_2.50 --depth 1 https://github.com/WiringPi/WiringPi.git \
    && cd WiringPi \
    && ./build \
    && cd .. \
    && rm -rf WiringPi

# Get and compile tlc5947
RUN git clone -b current --depth 1 https://github.com/morsm/tlc5947spi.git \
    && cd tlc5947spi \
    && g++ -o tlc5947spi -lwiringPi tlc5947spi.cpp


# Get and compile HippoPwm daemon
WORKDIR /hippopwm

RUN git clone -b current --depth 1 https://github.com/morsm/HippoPiPwmLedDaemon.git . \
    && nuget restore \
    && msbuild -p:Configuration=Release *csproj

COPY pipwmled.json bin/Release/

WORKDIR /hippopwm/bin/Release

CMD mono HippoPiPwmLedDaemon.exe

