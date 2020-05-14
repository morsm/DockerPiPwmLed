FROM mono:latest

LABEL description="HippoPiPwmDaemon mono image"

WORKDIR /hippopwm

RUN apt-get update && apt-get install -y git

RUN git clone -b current --depth 1 https://github.com/morsm/HippoPiPwmLedDaemon.git .

RUN nuget restore

RUN msbuild -p:Configuration=Release *csproj

COPY pipwmled.json bin/Release/
COPY tlc5947spi /usr/local/bin/
COPY wiringpi-latest.deb .

RUN dpkg -i wiringpi-latest.deb

EXPOSE 9030 9031 9032 9033 9034 9035

WORKDIR /hippopwm/bin/Release

CMD mono HippoPiPwmLedDaemon.exe

