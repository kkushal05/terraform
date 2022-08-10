FROM jenkins/jenkins:latest
#ENV JAVA_OPTS="-Dhttp.proxyHost=<proxy_url> -DproxyPort=<proxy_port>" - Use this if your env has proxy to install plugins
#I tried installing plugins using the JCASC jenkins.yaml file in the unclassified->plugin block, but it did not work for me. Hence, installing it here in Dockerfile
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
