FROM ghcr.io/cloudnative-coop/iipod:2023.07.03-05

RUN sudo apt-get install -y \
  jp2a \
  python3-pynput
#   python3-time

RUN git clone https://github.com/abdabTheCreator/image_watcher.git
RUN git clone https://github.com/abdabTheCreator/mouse-controls.git
RUN git clone https://github.com/asweigart/pyautogui.git mouse-countrols/pyautogui
# RUN chmod a+rwx /image_watcher/image_monitor.sh

RUN wget "https://download-cdn.jetbrains.com/idea/ideaIC-2021.2.3.tar.gz" \
  && tar xvf ideaIC-2021.2.3.tar.gz \
  && sudo mv idea-IC-212.5457.46/ /opt/idea \
  && rm ideaIC-2021.2.3.tar.gz
COPY --chmod=755 idea.desktop /usr/share/applications/idea.desktop

RUN mkdir minecraftforge \
  && cd minecraftforge \
  && wget "https://maven.minecraftforge.net/net/minecraftforge/forge/1.18.2-40.2.0/forge-1.18.2-40.2.0-mdk.zip" -O temp.zip \
  && unzip temp.zip \
  && rm temp.zip
COPY --chmod=755 minecraft.desktop /usr/share/applications/minecraft.desktop
