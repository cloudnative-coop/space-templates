#!/bin/bash
echo "Starting TMUX"
tmux new -d -s $SESSION_NAME -n "ii"
tmux send-keys "sudo tail -f /var/log/cloud-init-output.log
"
echo "Starting TTYD"
ttyd tmux at 2>&1 | tee /tmp/ttyd.log &
# TODO : Install docker into the image
sudo apt install docker-ce-cli
echo "Setting up repos..."
mkdir repos
cd repos
git clone https://github.com/cncf/apisnoop.git
# Setup Ticket-Writing
git clone https://github.com/apisnoop/ticket-writing.git
cd ~/repos/ticket-writing
git remote add upstream git@github.com:apisnoop/ticket-writing.git
echo "Waiting for Kubernetes API to be readyz..."
until kubectl get --raw='/readyz?verbose'; do sleep 5; done
# Setup Kubernetes src
mkdir -p ~/go/src/k8s.io
cd ~/go/src/k8s.io
git clone https://github.com/kubernetes/kubernetes.git
cd kubernetes
git remote add ii git@github.com:ii/kubernetes.git
# sudo apt-get install -y novnc websockify tigervnc-standalone-server icewm kitty
# mkdir novnc && ln -s /usr/share/novnc/* novnc
# cp novnc/vnc.html novnc/index.html
# websockify -D --web=/home/ii/novnc 6080 localhost:5901
# tigervncserver -useold -desktop $SESSION_NAME -SecurityTypes None#
# export DISPLAY=:1
# kitty -T "${lower(data.coder_workspace.ii.name)}" --detach --hold bash -c "cd minecraftforge && ./gradlew runClient"
# Setup Istio
echo "Install istio into this cluster..."
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
kubectl get ns istio-system || kubectl create ns istio-system
helm install istio-base istio/base -n istio-system
kubectl api-resources | grep istio
helm ls -n istio-system
helm install istiod istio/istiod -n istio-system --wait
helm ls -n istio-system
helm status istiod -n istio-system
kubectl get deployments -n istio-system --output wide
# Setup Knative
echo "Install knative into this cluster..."
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.10.2/serving-crds.yaml
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.10.2/serving-core.yaml
kubectl apply -f https://github.com/knative/net-istio/releases/download/knative-v1.10.1/net-istio.yaml
kubectl --namespace istio-system get service istio-ingressgateway
kubectl get pods -n knative-serving
